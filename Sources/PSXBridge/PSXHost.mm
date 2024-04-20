//
//  PSXHost.mm
//  
//
//  Created by Ian Clawson on 4/20/21.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wall"
#pragma clang diagnostic ignored "-Wextra"

#include <mednafen/mednafen.h>
#include <mednafen/settings-driver.h>
#include <mednafen/state-driver.h>
#include <mednafen/mednafen-driver.h>
#include <mednafen/MemoryStream.h>

//#include "mednafen.h"
//#include "settings-driver.h"
//#include "state-driver.h"
//#include "mednafen-driver.h"
//#include "MemoryStream.h"

#pragma clang diagnostic pop

#import "PSXHost.h"

static Mednafen::MDFNGI *psxMednafenGame;
static Mednafen::MDFN_Surface *psxMednafenSurface;

const int PSXMap[] = {
    4,  // up
    6,  // down
    7,  // left
    5,  // right
    24, // left analog up
    23, // left analog down
    22, // left analog left
    21, // left analog right
    20, // right analog up
    19, // right analog down
    18, // right analog left
    17, // right analog right
    12, // triangle
    13, // circle
    14, // cross
    15, // square
    10, // l1
    8,  // l2
    1,  // l3
    11, // r1
    9,  // r2
    2,  // r3
    3,  // start
    0,  // select
    16, // analog mode
};

//@interface PSXHost (MultiDisc)
//+ (NSDictionary<NSString*,NSNumber*>*_Nonnull)psxMultiDiscGameDict;
//@end

@interface PSXHost ()
{
    
    uint32_t *inputBuffer[8];
    int videoWidth, videoHeight;
    int videoOffsetX, videoOffsetY;
    
    int multiTapPlayerCount;
    NSString *mednafenCoreModule;
    
    const struct Mednafen::EmulateSpecStruct emptySpec;
    Mednafen::EmulateSpecStruct spec;
}

@end

@implementation PSXHost

+ (instancetype)sharedInstance
{
    static PSXHost *_host = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _host = [[self alloc] init];
    });
    
    return _host;
}

- (id)init
{
    if((self = [super init]))
    {
        mednafenCoreModule = @"psx";
        multiTapPlayerCount = 2;
        
        for(unsigned i = 0; i < 8; i++) {
            inputBuffer[i] = (uint32_t *) calloc(9, sizeof(uint32_t));
        }
    }
    
    return self;
}

- (void)dealloc
{
    for(unsigned i = 0; i < 8; i++) {
        free(inputBuffer[i]);
    }
    
    delete psxMednafenSurface;
}

#pragma mark - Emulation State -

- (void)startHostWithGameURL:(NSURL *)gameURL
            biosDirectoryURL:(NSURL *)biosDirectoryURL
             biosSCPH5500URL:(NSURL *)biosSCPH5500URL
             biosSCPH5501URL:(NSURL *)biosSCPH5501URL
             biosSCPH5502URL:(NSURL *)biosSCPH5502URL
           gameDirectoryPath:(NSString *)gameDirectoryPath
              PSXGameInputL1:(int)PSXGameInputL1
              PSXGameInputL2:(int)PSXGameInputL2
              PSXGameInputR1:(int)PSXGameInputR1
              PSXGameInputR2:(int)PSXGameInputR2
          PSXGameInputCircle:(int)PSXGameInputCircle
{
    // all PSX images come as either
    // - a .bin (the actual game), and
    // - a .cue (a file telling the PSX where and how to begin playing the disc)
    // - an optional .m3u file if a mutli-disc game
    
    // If given an M3U file with all of the .cue files listed in order,
    // Mednafen then understands them as separate discs of a single game.
    
    // M3Us are merely a list of the cue files the game is concerned with:
    /*
     Final Fantasy VII (Disc 1).cue
     Final Fantasy VII (Disc 2).cue
     Final Fantasy VII (Disc 3).cue
     */
    
    // And cue files in my testing all seem to be of the same format, regardless of game:
    /*
     FILE "whatever.bin" BINARY
     TRACK 01 MODE2/2352
     INDEX 01 00:00:00
     */
    // This being the case, Delta should then be able to infer/autogenerate the m3u/cue files as needed,
    // so long as there is some way for multidisc games to be associated with and know about their companions.
    
    // in the meantime, this implementation is fragile as I don't want to code any more ui than I need to,
    // but for now we will *expect* that the cue/m3u files exist and are in the same dir as the bin.
    
    // ANOTHER possible implmentation is to track all of the games with
    // divergent cue files (similar to what's been done for multitap and multidisc)
    
    NSLog(@"INIT!!!!");
    NSLog(@"INIT!!!!");
    NSLog(@"INIT!!!!");
    NSLog(@"INSIDE PSX::::: %@", gameURL.path);
    
    // Initialize Mednafen
    Mednafen::MDFNI_InitializeModules();
    
    std::vector<Mednafen::MDFNSetting> settings;
    
    Mednafen::MDFNI_Initialize(biosDirectoryURL.fileSystemRepresentation, settings);
    //
    // Set bios/system file and memcard save paths
    Mednafen::MDFNI_SetSetting("psx.bios_jp", biosSCPH5500URL.fileSystemRepresentation); // JP SCPH-5500 BIOS
    Mednafen::MDFNI_SetSetting("psx.bios_na", biosSCPH5501URL.fileSystemRepresentation); // NA SCPH-5501 BIOS
    Mednafen::MDFNI_SetSetting("psx.bios_eu", biosSCPH5502URL.fileSystemRepresentation); // EU SCPH-5502 BIOS
    Mednafen::MDFNI_SetSetting("filesys.path_sav", [gameURL.path stringByDeletingLastPathComponent].fileSystemRepresentation); // Memcards
    Mednafen::MDFNI_SetSetting("filesys.path_sav", gameDirectoryPath.fileSystemRepresentation); // Memcards
    
    // Enable time synchronization(waiting) for frame blitting.
    // Disable to reduce latency, at the cost of potentially increased video "juddering", with the maximum reduction in latency being about 1 video frame's time.
    // Will work best with emulated systems that are not very computationally expensive to emulate, combined with running on a relatively fast CPU.
    // Default: 1
    Mednafen::MDFNI_SetSettingB("video.blit_timesync", false);
    Mednafen::MDFNI_SetSettingB("video.fs", false); // Enable fullscreen mode. Default: 0
    
    Mednafen::MDFNI_SetSetting("psx.h_overscan", "0"); // Remove PSX overscan
    Mednafen::MDFNI_SetSetting("psx.region_default", "na"); // Set default region to NA in case of auto detect failing
    Mednafen::MDFNI_SetSettingB("psx.input.analog_mode_ct", false); // Enable Analog mode toggle
    
    // Analog/Digital Toggle
    uint64 amct =
    ((1 << PSXMap[PSXGameInputL1]) | (1 << PSXMap[PSXGameInputR1]) | (1 << PSXMap[PSXGameInputL2]) | (1 << PSXMap[PSXGameInputR2]) | (1 << PSXMap[PSXGameInputCircle])) ||
    ((1 << PSXMap[PSXGameInputL1]) | (1 << PSXMap[PSXGameInputR1]) | (1 << PSXMap[PSXGameInputCircle]));
    Mednafen::MDFNI_SetSettingUI("psx.input.analog_mode_ct.compare", amct);
    Mednafen::MDFNI_SetSetting("cheats", "1");
    
    /* end init mednafen */
    
    Mednafen::NativeVFS fs = Mednafen::NativeVFS();
    
    NSURL *urlToUse = gameURL;
    if (![gameURL.path.pathExtension.lowercaseString isEqualToString:@"m3u"]) {
        //         urlToUse = self.gameM3uURL; // enforcing usage of .m3u files for now.
        urlToUse = [NSURL URLWithString: [gameURL.path.stringByDeletingPathExtension stringByAppendingPathExtension:@"m3u"]];
    }
    psxMednafenGame = Mednafen::MDFNI_LoadGame([mednafenCoreModule UTF8String], &fs, urlToUse.path.fileSystemRepresentation);
    
    if(!psxMednafenGame) {
        NSLog(@"FAILED TO LOAD GAME!!!!");
        NSLog(@"FAILED TO LOAD GAME!!!!");
        NSLog(@"FAILED TO LOAD GAME!!!!");
        return;
    }
    
    // BGRA pixel format
    Mednafen::MDFN_PixelFormat pix_fmt(Mednafen::MDFN_COLORSPACE_RGB, 16, 8, 0, 24);
    psxMednafenSurface = new Mednafen::MDFN_Surface(NULL, psxMednafenGame->fb_width, psxMednafenGame->fb_height, psxMednafenGame->fb_width, pix_fmt);
    
    for(unsigned i = 0; i < multiTapPlayerCount; i++) {
        // Center the Dual Analog Sticks
        uint8 *buf = (uint8 *)inputBuffer[i];
        Mednafen::MDFN_en16lsb(&buf[3], (uint16) 32767);
        Mednafen::MDFN_en16lsb(&buf[3]+2, (uint16) 32767);
        Mednafen::MDFN_en16lsb(&buf[3]+4, (uint16) 32767);
        Mednafen::MDFN_en16lsb(&buf[3]+6, (uint16) 32767);
        // Do we want to use gamepad when not using an MFi device?
        psxMednafenGame->SetInput(i, "dualshock", (uint8_t *)inputBuffer[i]);
    }
    
    // Multi-Disc check; keeping this around for historical reasons, but not exactly needed for now
    //     BOOL multiDiscGame = NO;
    //     NSString* romSerial = @"";
    //     NSNumber *discCount = [PSXHost psxMultiDiscGameDict][romSerial];
    //     if (discCount) {
    //         self.maxDiscs = [discCount intValue];
    //         multiDiscGame = YES;
    //     }
    //     if (multiDiscGame && ![path.pathExtension.lowercaseString isEqualToString:@"m3u"]) {
    //         NSString *m3uPath = [path.stringByDeletingPathExtension stringByAppendingPathExtension:@"m3u"];
    //         NSRange rangeOfDocuments = [m3uPath rangeOfString:@"/Documents/" options:NSCaseInsensitiveSearch];
    //         if (rangeOfDocuments.location != NSNotFound) {
    //             m3uPath = [m3uPath substringFromIndex:rangeOfDocuments.location + 11];
    //         }
    //
    //         NSString *message = [NSString stringWithFormat:@"This game requires multiple discs and must be loaded using a m3u file with all %lu discs.\n\nTo enable disc switching and ensure save files load across discs, it cannot be loaded as a single disc.\n\nPlease install a .m3u file with the filename %@.\nSee https://bitly.com/provm3u", self.maxDiscs, m3uPath];
    //         NSLog(message);
    //     }
    //     if (self.maxDiscs > 1) {
    //         // Parse number of discs in m3u
    //         NSString *m3uString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //         NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".cue|.ccd" options:NSRegularExpressionCaseInsensitive error:nil];
    //         NSUInteger numberOfMatches = [regex numberOfMatchesInString:m3uString options:0 range:NSMakeRange(0, [m3uString length])];
    //
    //         NSLog(@"Loaded m3u containing %lu cue sheets or ccd",numberOfMatches);
    //     }
    
    [self setMedia:false forDisc:0]; // (close disc tray to start)
}

- (void)setMedia:(BOOL)openTray forDisc:(NSUInteger)disc {
    Mednafen::MDFNI_SetMedia(0, openTray ? 0 : 2, (uint32) disc, 0);
}

- (void)stopMednafen
{
    Mednafen::MDFNI_CloseGame();
    Mednafen::MDFNI_Kill();
}

#pragma mark - Game Loop -

- (void)runFrameAndProcessVideo:(BOOL)processVideo
{
    static int16_t sound_buf[0x10000];
    int32 rects[psxMednafenGame->fb_height];//int32 *rects = new int32[game->fb_height]; //(int32 *)malloc(sizeof(int32) * game->fb_height);
    
    memset(rects, 0, psxMednafenGame->fb_height*sizeof(int32));
    rects[0] = ~0;
    
    spec = emptySpec;
    spec.surface = psxMednafenSurface;
    spec.SoundRate = 44100; // sampleRate
    spec.SoundBuf = sound_buf;
    spec.LineWidths = rects;
    spec.SoundBufMaxSize = sizeof(sound_buf) / 2;
    spec.SoundBufSize = 0;
    spec.SoundVolume = 1.0;
    spec.soundmultiplier = 1.0;
    spec.skip = !processVideo;
    
    Mednafen::MDFNI_Emulate(&spec);
    
    videoOffsetX = spec.DisplayRect.x;
    videoOffsetY = spec.DisplayRect.y;
    if (psxMednafenGame->multires) {
        videoWidth = rects[spec.DisplayRect.y];
    } else {
        videoWidth = spec.DisplayRect.w ?: rects[spec.DisplayRect.y];
    }
    videoHeight = spec.DisplayRect.h;
    
}

- (int)videoOffsetX { return videoOffsetX; }
- (int)videoOffsetY { return videoOffsetY; }
- (int)videoWidth { return videoWidth; }
- (int)videoHeight { return videoHeight; }
- (int)videoBufferSize { return psxMednafenGame->fb_width * psxMednafenGame->fb_height * 4; }
- (int)soundBufferSize { return spec.SoundBufSize * (psxMednafenGame->soundchan) * 2; }
- (int16_t *)soundBuffer { return spec.SoundBuf; }
- (uint32_t *)surfacePixels { return psxMednafenSurface->pixels; }

#pragma mark - Inputs -

- (void)activateInput:(NSInteger)inputValue value:(double)value at:(NSInteger)playerIndex
{
    inputBuffer[playerIndex][0] |= 1 << PSXMap[inputValue];
}

- (void)deactivateInput:(NSInteger)inputValue at:(NSInteger)playerIndex
{
    inputBuffer[playerIndex][0] &= ~(1 << PSXMap[inputValue]);
}

#pragma mark - Game Saves -

- (void)saveGameSaveToURL:(NSURL *)URL
{
}

- (void)loadGameSaveFromURL:(NSURL *)URL
{
}

- (void)saveSaveStateToURL:(NSURL *)URL
{
    Mednafen::MDFNI_SaveState(URL.fileSystemRepresentation, "", NULL, NULL, NULL);
}

- (void)loadSaveStateFromURL:(NSURL *)URL
{
    Mednafen::MDFNI_LoadState(URL.fileSystemRepresentation, "");
}

@end


//void Mednafen::MDFND_OutputNotice(MDFN_NoticeType t, const char* s) noexcept {}
//void Mednafen::MDFND_OutputInfo(const char *s) noexcept {}
//void Mednafen::MDFND_MidSync(EmulateSpecStruct *espec, const unsigned flags) {}
//void Mednafen::MDFND_MediaSetNotification(uint32 drive_idx, uint32 state_idx, uint32 media_idx, uint32 orientation_idx) {}
//bool Mednafen::MDFND_CheckNeedExit(void) { return false; }
////void Mednafen::MDFND_NetplayText(const char* text, bool NetEcho) {}
////void Mednafen::MDFND_NetplaySetHints(bool active, bool behind, uint32 local_players_mask) {}
//void Mednafen::MDFND_SetStateStatus(StateStatusStruct *status) noexcept {}
