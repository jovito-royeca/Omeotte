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
#import "SXParticleSystem.h"

@interface OEffects : NSObject

-(void) advanceTime:(double)seconds;

-(void) applyFloatingTextOnStatField:(SPTextField*)statField
                       modValue:(int)modValue
                        message:(NSString*)message
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
