//
//  PSXHost.h
//  
//
//  Created by Ian Clawson on 4/20/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PSXHost : NSObject

@property (class, nonatomic, readonly) PSXHost *sharedInstance;

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
          PSXGameInputCircle:(int)PSXGameInputCircle;
- (void)setMedia:(BOOL)open forDisc:(NSUInteger)disc;
- (void)stopMednafen;
#pragma mark - Game Loop -
- (void)runFrameAndProcessVideo:(BOOL)processVideo;
- (int)videoOffsetX;
- (int)videoOffsetY;
- (int)videoWidth;
- (int)videoHeight;
- (int)videoBufferSize;
- (int)soundBufferSize;
- (int16_t *)soundBuffer;
- (uint32_t *)surfacePixels;
#pragma mark - Inputs -
- (void)activateInput:(NSInteger)inputValue value:(double)value at:(NSInteger)playerIndex;
- (void)deactivateInput:(NSInteger)inputValue at:(NSInteger)playerIndex;
#pragma mark - Game Saves -
- (void)saveGameSaveToURL:(NSURL *)URL;
- (void)loadGameSaveFromURL:(NSURL *)URL;
- (void)saveSaveStateToURL:(NSURL *)URL;
- (void)loadSaveStateFromURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END

