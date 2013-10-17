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

@interface OEffects : NSObject

+(void) applyEffectsOnStatField:(SPTextField*)statField
                       modValue:(int)modValue
                        message:(NSString*)message
                              xOffset:(float)x
                         parent:(SPSprite*)parent;

@end
