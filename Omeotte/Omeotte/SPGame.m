//
//  SPGame.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/22/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "SPGame.h"

@implementation SPGame

- (id)init
{
    if ((self = [super init]))
    {
        // This is where the code of your game will start;
        // in this sample, we add just a simple quad to see if it works.
        
        SPQuad *quad = [SPQuad quadWithWidth:100 height:100];
        quad.color = 0xff0000;
        quad.x = 50;
        quad.y = 50;
        
        SPQuad *quad2 = [SPQuad quadWithWidth:100 height:100];
        quad2.color = 0x00ff00;
        quad2.x = 150;
        quad2.y = 150;
        
        SPQuad *quad3 = [SPQuad quadWithWidth:100 height:100];
        quad3.color = 0x0000ff;
        quad3.x = 250;
        quad3.y = 250;
        
        [self addChild:quad];
        [self addChild:quad2];
        [self addChild:quad3];
        
        
        // Per default, this project compiles as an universal application. To change that, enter the
        // project info screen, and in the "Build"-tab, find the setting "Targeted device family".
        //
        // Now Choose:
        //   * iPhone      -> iPhone only App
        //   * iPad        -> iPad only App
        //   * iPhone/iPad -> Universal App
        //
        // The "iOS deployment target" setting must be at least "iOS 5.0" for Sparrow 2.
        // Always used the latest available version as the base SDK.
    }
    return self;
}

@end
