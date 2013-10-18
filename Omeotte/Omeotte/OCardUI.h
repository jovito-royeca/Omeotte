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
#import "Omeotte.h"
#import "SHPolygon.h"

#define CARD_WIDTH_PIXELS  375
#define CARD_HEIGHT_PIXELS 523

@protocol OCardUIDelegate;

@interface OCardUI : SPSprite

@property(strong,nonatomic) OCard *card;
@property(strong,nonatomic) SPTextField *lblName;
@property(strong,nonatomic) SPQuad *qdCost;
@property(strong,nonatomic) SPTextField *lblCost;
@property(strong,nonatomic) SPImage *imgArt;
@property(strong,nonatomic) SPTextField *lblText;
@property(strong,nonatomic) SPImage *imgBackground;
@property(strong,nonatomic) SPImage *imgTower;
@property(strong,nonatomic) SPQuad *qdBorder;
@property(strong,nonatomic) SPQuad *qdBackground;
@property(strong,nonatomic) SPImage *imgLocked;
@property(strong,nonatomic) SPTextField *lblDiscarded;

@property(nonatomic) BOOL touchStatus;

@property(nonatomic, assign) id<OCardUIDelegate> delegate;

-(id) initWithWidth:(float)width
             height:(float)height
             faceUp:(BOOL)faceUp;
-(void) showFace:(BOOL)locked;
-(void) showBack:(BOOL)opponent;
-(void) showDiscarded;

-(void) advanceTime:(double)seconds;
-(void) setupAnimation:(float)x
                     y:(float)y
                  time:(float)time;
@end

@protocol OCardUIDelegate <NSObject>
- (void)promote:(OCardUI*)cardUI;
- (void)play:(OCardUI*)cardUI;
- (void)discard:(OCardUI*)cardUI;
- (void)demote:(OCardUI*)cardUI;
@end