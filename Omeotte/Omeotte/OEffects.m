//
//  OAnimation.m
//  Omeotte
//
//  Created by Jovito Royeca on 10/12/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OEffects.h"

@implementation OEffects

+(void) applyEffectsOnStatField:(SPTextField*)statField
                       modValue:(int)modValue
                        message:(NSString*)message
                              xOffset:(float)x
                         parent:(SPSprite*)parent
{
    SPTextField *newField = [[SPTextField alloc] initWithWidth:statField.width height:10];
    newField.x = x;
    newField.y = statField.y;
    newField.text = [NSString stringWithFormat:@"%@%d %@", (modValue>0 ? @"+":@""), modValue, message];
    newField.color = modValue<0 ? RED_COLOR : 0xffffff;
    newField.fontSize = 10;
    newField.fontName = statField.fontName;
    newField.hAlign = statField.hAlign;
    [parent addChild:newField];
    
    SPTween *tween = [SPTween tweenWithTarget:newField time:3.0];
	[tween animateProperty:@"y" targetValue:0-newField.height];
    [tween animateProperty:@"alpha" targetValue:0];
	[Sparrow.juggler addObject:tween];
    
    if (newField.y < 0)
    {
        [parent removeChild:newField];
    }
}

@end
