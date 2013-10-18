//
//  OAnimation.m
//  Omeotte
//
//  Created by Jovito Royeca on 10/12/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OEffects.h"

@implementation OEffects
{
    NSMutableArray *_statFields;
    SPJuggler *_juggler;
}

- (void)dealloc
{
    [super dealloc];
    
    [_statFields release];
    [_juggler release];
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

-(void) applyEffectsOnStatField:(SPTextField*)statField
                       modValue:(int)modValue
                        message:(NSString*)message
                        xOffset:(float)x
                        yOffset:(float)y
                         parent:(SPSprite*)parent
{
    SPTextField *newField = [[SPTextField alloc] initWithWidth:statField.width height:10];
    newField.x = x;
    newField.y = y;
    newField.text = [NSString stringWithFormat:@"%@%d %@", (modValue>0 ? @"+":@""), modValue, message];
    newField.color = modValue<0 ? RED_COLOR : WHITE_COLOR;
    newField.fontSize = 10;
    newField.fontName = statField.fontName;
    newField.hAlign = statField.hAlign;
    [parent addChild:newField];
    
    SPTween *tween = [SPTween tweenWithTarget:newField time:3.0];
	[tween animateProperty:@"y" targetValue:0-newField.height];
    [tween animateProperty:@"alpha" targetValue:0];
	[_juggler addObject:tween];
    
    if (newField.y < 0)
    {
        [parent removeChild:newField];
    }
}

@end
