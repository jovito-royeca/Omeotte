//
//  SPCardsTest.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/27/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "CardTestScene.h"

@implementation CardTestScene
{
    NSString *_deck;
}

@synthesize cardUI;
@synthesize searchBar;
@synthesize tblCards;

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

    [cardUI release];
    [searchBar release];
    [tblCards release];
    [OMedia releaseAllAtlas];
}

- (void)setup
{
    _deck = @"cards.xml";
    [OMedia initAtlas:_deck];
    
    alphabet = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
                @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U",
                @"V", @"W", @"X", @"Y", @"Z", nil];
    [alphabet retain];
    
    int stageWidth = Sparrow.stage.width;
    int stageHeight = Sparrow.stage.height;
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat currentWidth = 0;
    CGFloat currentHeight = 0;
    
    currentHeight = stageHeight;
    currentWidth = (currentHeight * CARD_WIDTH_PIXELS) / CARD_HEIGHT_PIXELS;
    currentX = ((stageWidth/2) - currentWidth) /2;
    cardUI = [[OCardUI alloc] initWithWidth:currentWidth height:currentHeight];
    cardUI.x = currentX;
    cardUI.y = currentY;
    [self addChild:cardUI];
    
    currentX = stageWidth/2;
    currentWidth = stageWidth/2;
    currentHeight = 88;
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(currentX, currentY, currentWidth, currentHeight)];
    searchBar.delegate = self;
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"All", @"Quarry", @"Magic", @"Dungeon", nil];
    searchBar.showsScopeBar = YES;
    [Sparrow.currentController.view addSubview:searchBar];
    
    currentY = searchBar.frame.size.height;
    currentHeight = stageHeight-searchBar.frame.size.height;
    tblCards = [[UITableView alloc] initWithFrame:CGRectMake(currentX, currentY, currentWidth, currentHeight)];
    tblCards.delegate = self;
    tblCards.dataSource = self;
    [Sparrow.currentController.view addSubview:tblCards];
    
    results = [self searchCards:@"" cardType:0];
    [self createSections];
}

- (NSArray*) searchCards:(NSString*)query cardType:(int)type
{
    if (query.length == 1)
    {
        NSMutableString *predicateString = [NSMutableString stringWithFormat:@"SELF.name beginswith[cd] \'%@\'", query];
    
        if (type != 0)
        {
            [predicateString appendFormat:@" AND SELF.type = %d", type-1];
        }
        NSPredicate *predicate = [NSPredicate
                                    predicateWithFormat:predicateString];
    
        return [[OCard allCards] filteredArrayUsingPredicate:predicate];
    }
    else if (query.length > 1)
    {
        NSMutableString *predicateString = [NSMutableString stringWithFormat:@"SELF.name contains[cd] \'%@\'", query];
        
        if (type != 0)
        {
            [predicateString appendFormat:@" AND SELF.type = %d", type-1];
        }
        NSPredicate *predicate = [NSPredicate
                                  predicateWithFormat:predicateString];
        
        return [[OCard allCards] filteredArrayUsingPredicate:predicate];
    }
    else
    {
        return [OCard allCards];
    }
}

- (void) createSections
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSString *letter in alphabet)
    {
        for (OCard *card in results)
        {
            if ([card.name hasPrefix:letter] && ![array containsObject:letter])
            {
                [array addObject:letter];
            }
        }
    }
    
    sections = nil;
    sections = [NSArray arrayWithArray:array];
    [sections retain];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *query = [sections objectAtIndex:indexPath.section];
    OCard *card = [[self searchCards:query cardType:searchBar.selectedScopeButtonIndex] objectAtIndex:indexPath.row];
    
    [cardUI setLocked:NO];
    [cardUI setCard:card];
    [cardUI paintCard];
    [searchBar resignFirstResponder];
}

- (NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self searchCards:[sections objectAtIndex:section] cardType:searchBar.selectedScopeButtonIndex];
    return [array count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UILabel *label = [[UILabel alloc] init];
    
    label.text = [sections objectAtIndex:section];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor lightTextColor];
    return label;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sections objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tblCards dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *query = [sections objectAtIndex:indexPath.section];
    OCard *card = [[self searchCards:query cardType:searchBar.selectedScopeButtonIndex] objectAtIndex:indexPath.row];
    cell.textLabel.text = card.name;
    
    return cell;
}

#pragma mark - UISearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)bar
{
    results = [self searchCards:bar.text cardType:bar.selectedScopeButtonIndex];

    [self createSections];
    [tblCards reloadData];
    [bar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)bar
{
    results = [self searchCards:bar.text cardType:bar.selectedScopeButtonIndex];
    
    [self createSections];
    [tblCards reloadData];

}

- (void)searchBar:(UISearchBar *)bar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    results = [self searchCards:bar.text cardType:selectedScope];
    
    [self createSections];
    [tblCards reloadData];
    [bar resignFirstResponder];
}

@end
