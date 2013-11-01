//
//  Media.m
//  AppScaffold
//

#import "OMedia.h"


@implementation OMedia

static NSMutableDictionary *atlases = NULL;
static NSMutableDictionary *sounds = NULL;

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
+ (void)initSound
{
    if (sounds)
        return;
    
    [SPAudioEngine start];
    sounds = [[NSMutableDictionary alloc] init];
    
    // enumerate all sounds
    
    NSString *soundDir = [[NSBundle mainBundle] resourcePath];    
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:soundDir];   
    
    NSString *filename;
    while (filename = [dirEnum nextObject]) 
    {
        if ([[filename pathExtension] isEqualToString: @"caf"])
        {
            SPSound *sound = [[SPSound alloc] initWithContentsOfFile:filename];            
            sounds[filename] = sound;
        }
    }
}

+ (void)releaseSound
{
    sounds = nil;
    
    [SPAudioEngine stop];    
}

+ (void)playSound:(NSString *)soundName
{
    SPSound *sound = sounds[soundName];
    
    if (sound)
        [sound play];
    else        
        [[SPSound soundWithContentsOfFile:soundName] play];
}

+ (SPSoundChannel *)soundChannel:(NSString *)soundName
{
    SPSound *sound = sounds[soundName];
    
    // sound was not preloaded
    if (!sound)        
        sound = [SPSound soundWithContentsOfFile:soundName];
    
    return [sound createChannel];
}

@end
