//
//  OButton.h
//  Omeotte
//
//  Created by Jovito Royeca on 9/2/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "Sparrow.h"

@interface OButtonTextureUI : SPTexture

- (id)initWithWidth:(float)width
             height:(float)height
       cornerRadius:(float)cornerRadius
        strokeWidth:(float)strokeWidth
        strokeColor:(uint)strokeColor
              gloss:(BOOL)gloss
         startColor:(uint)startColor
           endColor:(uint)endColor;

@end
