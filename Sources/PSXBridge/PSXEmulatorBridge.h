//
//  PSXEmulatorBridge.h
//  PSXDeltaCore
//
//  Created by Ian Clawson on 9/13/20.
//


#import <Foundation/Foundation.h>

@protocol DLTAEmulatorBridging;

NS_ASSUME_NONNULL_BEGIN

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything" // Silence "Cannot find protocol definition" warning due to forward declaration.
@interface PSXEmulatorBridge : NSObject <DLTAEmulatorBridging>
#pragma clang diagnostic pop

@property (class, nonatomic, readonly) PSXEmulatorBridge *sharedBridge;

@property (nonatomic, readonly) NSString *gameDirectoryPath;
@property (nonatomic, readonly) NSURL *gameCueURL;
@property (nonatomic, readonly) NSURL *gameM3uURL;
//@property (nonatomic, readonly) NSURL *biosSCPH5500URL;
//@property (nonatomic, readonly) NSURL *biosSCPH5501URL;
//@property (nonatomic, readonly) NSURL *biosSCPH5502URL;
- (NSURL *)biosSCPH5500URL:(NSURL *)biosDirectoryURL;
- (NSURL *)biosSCPH5501URL:(NSURL *)biosDirectoryURL;
- (NSURL *)biosSCPH5502URL:(NSURL *)biosDirectoryURL;
- (void)setMedia:(BOOL)open forDisc:(NSUInteger)disc;

@end

NS_ASSUME_NONNULL_END

