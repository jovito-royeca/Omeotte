//
//  SPCardsTest.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/27/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "SPCardsTest.h"

// --- private interface ---------------------------------------------------------------------------

@interface SPCardsTest ()

- (void)setup;
- (void)onResize:(SPResizeEvent *)event;

@end


@implementation SPCardsTest
{
    SPSprite *_contents;
    SPTextField *_cardLbl;
    UITableView *_table;
    SPImage *_image;
}

NSString *deck = @"arcomage deck.xml";

- (id)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    // release any resources here
    [SPMedia releaseAllAtlas];
    //    [SPMedia releaseSound];
}

- (void)setup
{
    _cards = [[OCard allCards] retain];

    [SPMedia initAtlas:deck];
    
    _contents = [SPSprite sprite];
    [self addChild:_contents];
    
    // Cards label
    _cardLbl = [[SPTextField alloc] initWithWidth:250 height:80 text:@"Cards"];
    _cardLbl.x = 30;//(background.width - textField.width) / 2;
    _cardLbl.y = 30;//(background.height / 2) - 135;
    _cardLbl.color = 0xffffff;
    [_contents addChild:_cardLbl];
    
    // table
    _table = [[UITableView alloc] initWithFrame:CGRectMake(_cardLbl.x, _cardLbl.height+10, 250, 500)];
    [_table setDataSource:self];
    [_table setDelegate:self];
    [Sparrow.currentController.view addSubview:_table];
    
    // card image
    _image = [[SPImage alloc] initWithWidth:95 height:128];
    _image.x = _table.frame.size.width + 30;
    _image.y = _table.frame.origin.y;
    [_contents addChild:_image];
    
    [self updateLocations];
    [self addEventListener:@selector(onResize:) atObject:self forType:SP_EVENT_TYPE_RESIZE];
     
}

- (void)updateLocations
{
    int gameWidth  = Sparrow.stage.width;
    int gameHeight = Sparrow.stage.height;
    
    _contents.x = (int) (gameWidth  - _contents.width)  / 2;
    _contents.y = (int) (gameHeight - _contents.height) / 2;
}

- (void)onResize:(SPResizeEvent *)event
{
    NSLog(@"new size: %.0fx%.0f (%@)", event.width, event.height,
          event.isPortrait ? @"portrait" : @"landscape");
    
    [self updateLocations];
}


// ------ UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cards count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SelectionsTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    OCard *card = [_cards objectAtIndex:indexPath.row];
    
    [[cell textLabel] setText:[card name]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OCard *card = [_cards objectAtIndex:indexPath.row];
    SPTexture *texture = [SPMedia texture:[card name] fromAtlas:deck];
    
    if (texture)
    {
        [_image setTexture:texture];
    }
    else
    {
        NSString *blank = nil;
        
        switch (card.type)
        {
            case Quarry:
            {
                blank = @"quarry_blank";
                break;
            }
            case Magic:
            {
                blank = @"magic_blank";
                break;
            }
            case Dungeon:
            {
                blank = @"dungeon_blank";
                break;
            }
            case Mixed:
            default:
            {
                blank = @"blank";
                break;
            }
        }
        
        [_image setTexture:[SPMedia texture:blank fromAtlas:deck]];
    }
}

@end
