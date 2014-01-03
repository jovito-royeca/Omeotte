//
//  SPCardsTest.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/27/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sparrow.h"

#import "OBackgroundMusicScene.h"
#import "OCard.h"
#import "OCardUI.h"
#import "OPlayer.h"
#import "OMedia.h"

@interface CardTestScene : SPSprite <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, OBackgroundMusicScene>
{
    NSArray *results;
    NSArray *sections;
    NSArray *alphabet;
}

@property (strong, nonatomic) OCardUI *cardUI;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *tblCards;

- (NSArray*) searchCards:(NSString*)query cardType:(int)type;
- (void) createSections;

@end
