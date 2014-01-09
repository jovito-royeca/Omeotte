//
//  Media.m
//  AppScaffold
//

#import "OMedia.h"


@implementation OMedia

static NSMutableDictionary *atlases = nil;
static NSMutableDictionary *sounds = nil;

#pragma mark Texture Atlas


+ (void)initAtlas:(NSString *)name
{
    if (!atlases)
        atlases = [[NSMutableDictionary alloc] init];
    
    if (![atlases objectForKey:name])
    {
        SPTextureAtlas *atlas = [[SPTextureAtlas alloc] initWithContentsOfFile:name];
        [atlases setValue:atlas forKey:name];
    }
}

+ (void)releaseAtlas:(NSString *)name
{
    if (atlases)
    {
        [atlases removeObjectForKey:name];
    }
}

+ (void)releaseAllAtlas;
{
    if (atlases)
    {
        [atlases removeAllObjects];
    }
    atlases = nil;
}

+ (SPTexture *)texture:(NSString *)name fromAtlas:(NSString *)atlas;
{
    [self initAtlas:atlas];
    return [[atlases objectForKey:atlas] textureByName:name];
}

+ (NSArray *)texturesWithPrefix:(NSString *)prefix fromAtlas:(NSString *)atlas
{
    [self initAtlas:atlas];
    return [[atlases objectForKey:atlas] texturesStartingWith:prefix];
}

#pragma mark Audio
+ (SPSoundChannel*) sound:(NSString *)name
{
    if (!sounds)
    {
        sounds = [[NSMutableDictionary alloc] init];
        [SPAudioEngine start];
    }
    
    if (![sounds objectForKey:name])
    {
        SPSound *sound = [[SPSound alloc] initWithContentsOfFile:name];
        [sounds setValue:sound forKey:name];
    }
    
    return [sounds[name] createChannel];
}

+ (void)releaseSound:(NSString *)name
{
    if (sounds)
    {
        [sounds removeObjectForKey:name];
    }
}

+ (void)releaseAllSounds
{
    if (sounds)
    {
        [sounds removeAllObjects];
    }
    sounds = nil;
    
    [SPAudioEngine stop];    
}

@end
