//
//  OAnimation.h
//  Omeotte
//
//  Created by Jovito Royeca on 10/12/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sparrow.h"

#import "Omeotte.h"
#import "OMedia.h"
#import "OStats.h"
#import "SXParticleSystem.h"

typedef enum
{
    DrawSound = 0,
    DiscardSound,
    ResourceFacilityUpSound,
    ResourceFacilityDownSound,
    ResourcesUpSound,
    ResourcesDownSound,
    TowerUpSound,
    TowerDownSound,
    WallUpSound,
    WallDownSound,
    DefeatSound,
    VictorySound,
    MenuSound,
    BattleSound1,
    BattleSound2
} SoundType;

@interface OFx : NSObject

-(void) advanceTime:(double)seconds;

-(void) playSound:(SoundType)type loop:(BOOL)bLoop;

-(void) stopSound:(SoundType)type;

-(void) applyFloatingTextOnStatField:(SPTextField*)statFieldText
                               field:(StatField)field
                       modValue:(int)modValue
                        xOffset:(float)x
                        yOffset:(float)y
                         parent:(SPSprite*)parent;

-(void) setFireOnStructure:(SPImage*)structure
                             xOffset:(float)x
                             yOffset:(float)y
                              parent:(SPSprite*)parent;

-(void) animate:(SPDisplayObject*)target
  withPropeties:(NSDictionary*)properties
             time:(float)time
         callback:(void (^)(void))callback;


@end
