//
//  OCardUI.h
//  Omeotte
//
//  Created by Jovito Royeca on 9/1/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "Sparrow.h"
#import "SPSprite.h"

#import "OCard.h"

@interface OCardUI : SPSprite

@property(strong,nonatomic) OCard *card;
@property(strong,nonatomic) SPTextField *lblName;
@property(strong,nonatomic) SPTextField *lblCost;
@property(strong,nonatomic) SPImage *imgArt;
@property(strong,nonatomic) SPTextField *lblText;


@end
