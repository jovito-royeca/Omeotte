//
//  Media.h
//  AppScaffold
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"

@interface SPMedia : NSObject 

+ (void)initAtlas:(NSString *)name;
+ (void)releaseAtlas:(NSString *)name;
+ (void)releaseAllAtlas;

+ (SPTexture *)texture:(NSString *)name fromAtlas:(NSString *)atlas;
+ (NSArray *)texturesWithPrefix:(NSString *)prefix fromAtlas:(NSString *)atlas;

+ (void)initSound;
+ (void)releaseSound;

+ (SPSoundChannel *)soundChannel:(NSString *)soundName;
+ (void)playSound:(NSString *)soundName;

@end
