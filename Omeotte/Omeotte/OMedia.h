//
//  Media.h
//  AppScaffold
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"

@interface OMedia : NSObject 

+ (void)initAtlas:(NSString *)name;
+ (void)releaseAtlas:(NSString *)name;
+ (void)releaseAllAtlas;

+ (SPTexture*)texture:(NSString *)name fromAtlas:(NSString *)atlas;
+ (NSArray*)texturesWithPrefix:(NSString *)prefix fromAtlas:(NSString *)atlas;

+ (SPSoundChannel*) sound:(NSString *)name;
+ (void)releaseSound:(NSString *)name;
+ (void)releaseAllSounds;

@end
