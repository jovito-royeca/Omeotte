//
//  Media.h
//  AppScaffold
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"

@interface SPMedia : NSObject 

+ (void)initAtlas;
+ (void)releaseAtlas;

+ (SPTexture *)atlasTexture:(NSString *)name;
+ (NSArray *)atlasTexturesWithPrefix:(NSString *)prefix;

+ (void)initSound;
+ (void)releaseSound;

+ (SPSoundChannel *)soundChannel:(NSString *)soundName;
+ (void)playSound:(NSString *)soundName;

@end
