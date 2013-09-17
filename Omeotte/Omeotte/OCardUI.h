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
#import "SHPolygon.h"

#define CARD_WIDTH_PIXELS  375
#define CARD_HEIGHT_PIXELS 523

@protocol OCardUIDelegate <NSObject>

- (void)promote:(OCard*)card;
- (void)play:(OCard*)card;
- (void)discard:(OCard*)card;
- (void)demote:(OCard*)card;

@end

@interface OCardUI : SPSprite
{
    int touchStatus;
}

@property(strong,nonatomic) OCard *card;
@property(strong,nonatomic) SPTextField *lblName;
@property(strong,nonatomic) SPTextField *lblCost;
@property(strong,nonatomic) SPImage *imgArt;
@property(strong,nonatomic) SPTextField *lblText;
@property(strong,nonatomic) SPImage *imgBackground;

@property (nonatomic, assign) id<OCardUIDelegate> delegate;

-(id) initWithWidth:(float)width height:(float)height;
-(void) paintCard:(BOOL) unlocked;

@end
