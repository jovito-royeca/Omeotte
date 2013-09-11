//
//  OCardUI.h
//  Omeotte
//
//  Created by Jovito Royeca on 9/1/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "Sparrow.h"

#import "OCard.h"
#import "OMedia.h"

@interface OCardUI : SPSprite

@property(strong,nonatomic) OCard *card;
@property(strong,nonatomic) SPTextField *lblName;
@property(strong,nonatomic) SPTextField *lblCost;
@property(strong,nonatomic) SPImage *imgArt;
@property(strong,nonatomic) SPTextField *lblText;
@property(strong,nonatomic) SPQuad *frmBackground;

-(id) initWithWidth:(float)width height:(float)height;
-(void) paintCard:(BOOL) unlocked;

@end
