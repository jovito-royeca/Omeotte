//
//  OAnimation.m
//  Omeotte
//
//  Created by Jovito Royeca on 10/12/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OFx.h"

@implementation OFx
{
    NSMutableArray *_statFields;
    SPJuggler *_juggler;
}

- (void)dealloc
{
    [_statFields release];
    [_juggler release];
    [super dealloc];
}

-(id) init
{
    if ((self = [super init]))
    {
        _statFields = [[NSMutableArray alloc] init];
        _juggler = [[SPJuggler alloc] init];
        
    }
    return self;
}

-(void) advanceTime:(double)seconds
{
    [_juggler advanceTime:seconds];
}

-(void) playSound:(SoundType)type loop:(BOOL)bLoop
{
#ifndef GAME_SOUNDS_ON
    return;
#endif

    SPSoundChannel *soundChannel = [OMedia sound:[self soundFileName:type]];
    soundChannel.loop = bLoop;
    [soundChannel play];
    
    if (!bLoop)
    {
        [soundChannel release];
    }
}

-(void) stopSound:(SoundType)type
{
#ifndef GAME_SOUNDS_ON
    return;
#endif
    SPSoundChannel *soundChannel = [OMedia sound:[self soundFileName:type]];
    
    [soundChannel stop];
    [soundChannel release];
}

- (NSString*) soundFileName:(SoundType)type
{
    switch (type)
    {
        case DrawSound:
        case DiscardSound:
        {
            
            return @"card.caf";
        }
        case ResourceUpSound:
        {
            return @"resb_upO.caf";
        }
        case ResourceDownSound:
        {
            return @"resb_downO.caf";
        }
        case ResourceValueUpSound:
        {
            return @"ress_upO.caf";
        }
        case ResourceValueDownSound:
        {
            return @"ress_downO.caf";
        }
        case TowerUpSound:
        {
            return @"tower_upO.caf";
        }
        case TowerDownSound:
        case WallDownSound:
        {
            return @"damageO.caf";
        }
        case WallUpSound:
        {
            return @"wall_upO.caf";
        }
        case DefeatSound:
        {
            return @"defeat.caf";
        }
        case VictorySound:
        {
            return @"victory.caf";
        }
    }
}

-(void) applyFloatingTextOnStatField:(SPTextField*)statFieldText
                               field:(StatField)field
                            modValue:(int)modValue
                             xOffset:(float)x
                             yOffset:(float)y
                              parent:(SPSprite*)parent
{
    SPTextField *newField = [[SPTextField alloc] initWithWidth:statFieldText.width height:10];
    newField.x = x;
    newField.y = y;
    newField.text = [NSString stringWithFormat:@"%@%d %@", (modValue>0 ? @"+":@""), modValue, [OStats statName:field]];
    newField.color = modValue<0 ? RED_COLOR : WHITE_COLOR;
    newField.fontSize = 10;
    newField.fontName = statFieldText.fontName;
    newField.hAlign = statFieldText.hAlign;
    [parent addChild:newField];
    
    SPTween *tween = [SPTween tweenWithTarget:newField time:3.0];
	[tween animateProperty:@"y" targetValue:0-newField.height];
    [tween animateProperty:@"alpha" targetValue:0];
	[_juggler addObject:tween];
    
    if (newField.y < 0)
    {
        [parent removeChild:newField];
        [newField release];
    }
}

-(void) setFireOnStructure:(SPImage*)structure
                   xOffset:(float)x
                   yOffset:(float)y
                    parent:(SPSprite*)parent
{
    // create particle system
    SXParticleSystem *ps = [[SXParticleSystem alloc] initWithContentsOfFile:@"fire.pex"];
    ps.x = x;
    ps.y = y;
    ps.emitterXVariance = 0;
    ps.emitterYVariance = 0;
    ps.maxNumParticles  = 100;
    ps.emitAngleVariance= 15;
    ps.scaleY = -1;
    
    [parent addChild:ps];
    [_juggler addObject:ps];
//    [ps release];
    
    [ps start];
    
    // emit particles for one second, then stop
    [ps startBurst:0.5];
    
    // stop emitting particles
//    [ps stop];
    
    // or get notified when all particles are gone
    [ps addEventListenerForType:SP_EVENT_TYPE_COMPLETED block:^(id event)
    {
        [parent removeChild:ps];
        [ps release];
    }];
}

-(void) animate:(SPDisplayObject*)target
  withPropeties:(NSDictionary*)properties
           time:(float)time
       callback:(void (^)(void))callback
{
    SPTween *tween = [SPTween tweenWithTarget:target time:time];
    
    for (NSString *key in [properties allKeys])
    {
        NSNumber *number = [properties objectForKey:key];
        [tween animateProperty:key targetValue:[number floatValue]];
    }
    
	[_juggler addObject:tween];
    
    if (callback)
    {
        [_juggler delayInvocationByTime:time block:callback];
    }
}

@end
