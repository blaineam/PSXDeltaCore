//
//  PSXEmulatorBridge.m
//  PSXDeltaCore
//
//  Created by Ian Clawson on 9/13/20.
//

//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wall"
//#pragma clang diagnostic ignored "-Wextra"
//
//#include <mednafen/mednafen.h>
//#include <mednafen/settings-driver.h>
//#include <mednafen/state-driver.h>
//#include <mednafen/mednafen-driver.h>
//#include <mednafen/MemoryStream.h>
//
////#include "mednafen.h"
////#include "settings-driver.h"
////#include "state-driver.h"
////#include "mednafen-driver.h"
////#include "MemoryStream.h"
//
//#pragma clang diagnostic pop

#import "PSXHost.h"
#import "PSXEmulatorBridge.h"

@import DeltaCore;
@import LibMednafen;
@import PSXSwift;

//@interface PSXEmulatorBridge (MultiDisc)
//+ (NSDictionary<NSString*,NSNumber*>*_Nonnull)psxMultiDiscGameDict;
//@end

@interface PSXEmulatorBridge ()
{
}

@property (nonatomic, copy, nullable, readwrite) NSURL *gameURL;

@property (nonatomic, assign) NSUInteger maxDiscs;

@end

@implementation PSXEmulatorBridge
@synthesize audioRenderer = _audioRenderer;
@synthesize videoRenderer = _videoRenderer;
@synthesize saveUpdateHandler = _saveUpdateHandler;
@synthesize durrrURL = _durrrURL;

+ (instancetype)sharedBridge
{
    static PSXEmulatorBridge *_emulatorBridge = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emulatorBridge = [[self alloc] init];
    });
    
    return _emulatorBridge;
}

- (id)init
{
    if((self = [super init]))
    {
    }
    
    return self;
}

- (void)dealloc
{
}

#pragma mark - Emulation State -

- (void)startWithGameURL:(NSURL *)URL
{
    self.gameURL = URL;
    
    [PSXHost.sharedInstance startHostWithGameURL:self.gameURL
                                biosDirectoryURL:self.durrrURL
                                 biosSCPH5500URL:[self biosSCPH5500URL: self.durrrURL]
                                 biosSCPH5501URL:[self biosSCPH5501URL: self.durrrURL]
                                 biosSCPH5502URL:[self biosSCPH5502URL: self.durrrURL]
                               gameDirectoryPath:self.gameDirectoryPath
                                  PSXGameInputL1:PSXGameInputL1
                                  PSXGameInputL2:PSXGameInputL2
                                  PSXGameInputR1:PSXGameInputR1
                                  PSXGameInputR2:PSXGameInputR2
                              PSXGameInputCircle:PSXGameInputCircle];
}

-(void)setMedia:(BOOL)open forDisc:(NSUInteger)disc {
    [PSXHost.sharedInstance setMedia:open forDisc:disc];
}

- (void)stop
{
    [PSXHost.sharedInstance stopMednafen];
}

- (void)pause
{
}

- (void)resume
{
}

#pragma mark - Game Loop -

- (void)runFrameAndProcessVideo:(BOOL)processVideo
{
    [PSXHost.sharedInstance runFrameAndProcessVideo:processVideo];
    
    if (processVideo)
    {
        self.videoRenderer.viewport = CGRectMake(PSXHost.sharedInstance.videoOffsetX,
                                                 PSXHost.sharedInstance.videoOffsetY,
                                                 PSXHost.sharedInstance.videoWidth,
                                                 PSXHost.sharedInstance.videoHeight);
        
        memcpy(self.videoRenderer.videoBuffer, PSXHost.sharedInstance.surfacePixels, PSXHost.sharedInstance.videoBufferSize);
        [self.videoRenderer processFrame];
    }
    
    [self.audioRenderer.audioBuffer writeBuffer:PSXHost.sharedInstance.soundBuffer size:PSXHost.sharedInstance.soundBufferSize];
}

#pragma mark - Inputs -

- (void)activateInput:(NSInteger)inputValue value:(double)value at:(NSInteger)playerIndex
{
    [PSXHost.sharedInstance activateInput:inputValue value:value at:playerIndex];
}

- (void)deactivateInput:(NSInteger)inputValue at:(NSInteger)playerIndex
{
    [PSXHost.sharedInstance deactivateInput:inputValue at:playerIndex];
}

- (void)resetInputs
{
    for(NSInteger i = 0; i < 8; i++)
    {
        for(NSInteger input = 0; input <= 24; input++)
        {
            [self deactivateInput:input at:i];
        }
    }
}

#pragma mark - Game Saves -

- (void)saveGameSaveToURL:(NSURL *)URL
{
}

- (void)loadGameSaveFromURL:(NSURL *)URL
{
}

#pragma mark - Save States -

- (void)saveSaveStateToURL:(NSURL *)URL
{
    [PSXHost.sharedInstance saveSaveStateToURL:URL];
}

- (void)loadSaveStateFromURL:(NSURL *)URL
{
    [PSXHost.sharedInstance loadSaveStateFromURL:URL];
}

#pragma mark - Cheats -

- (BOOL)addCheatCode:(NSString *)cheatCode type:(NSString *)type
{
    return NO;
}

- (void)resetCheats
{
}

- (void)updateCheats
{
}

#pragma mark - Getters/Setters -

- (NSTimeInterval)frameDuration
{
    return (1.0 / 60.0);
}

- (NSURL *)biosSCPH5500URL:(NSURL *)biosDirectoryURL
{
    //    return [PSXEmulatorBridge.coreDirectoryURL URLByAppendingPathComponent:@"scph5500.bin"];
    return [biosDirectoryURL URLByAppendingPathComponent:@"scph5500.bin"];
}

- (NSURL *)biosSCPH5501URL:(NSURL *)biosDirectoryURL
{
    //    return [PSXEmulatorBridge.coreDirectoryURL URLByAppendingPathComponent:@"scph5501.bin"];
    return [biosDirectoryURL URLByAppendingPathComponent:@"scph5501.bin"];
}

- (NSURL *)biosSCPH5502URL:(NSURL *)biosDirectoryURL
{
    //    return [PSXEmulatorBridge.coreDirectoryURL URLByAppendingPathComponent:@"scph5502.bin"];
    return [biosDirectoryURL URLByAppendingPathComponent:@"scph5502.bin"];
}

// this implementation is fragile as I don't want to code any more ui than I need to,
// but for now we will *expect* that the cue/m3u files exist and are inline with the bin.

- (NSURL *)gameCueURL // this is dumb
{
    return [NSURL URLWithString: [self.gameURL.path.stringByDeletingPathExtension stringByAppendingPathExtension:@"cue"]];
}

- (NSURL *)gameM3uURL // this is dumb
{
    return [NSURL URLWithString: [self.gameURL.path.stringByDeletingPathExtension stringByAppendingPathExtension:@"m3u"]];
}

- (NSString *)gameDirectoryPath
{
    return [self.gameURL.path stringByDeletingLastPathComponent];
}

@end
