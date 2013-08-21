//
//  OCard.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OCard.h"

@implementation OCard

@synthesize name;
@synthesize image;
@synthesize cost;
@synthesize text;
@synthesize type;
@synthesize playAgain;
@synthesize statFields;
@synthesize ops;

NSMutableArray *_cards;

+(NSArray*)allCards
{
    if (!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
        NSArray *cards = [NSArray arrayWithObjects:@"quarry", @"magic", @"dungeon", nil];
        
        for (NSString *card in cards)
        {
            NSString *plistPath;
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                      NSUserDomainMask, YES) objectAtIndex:0];
            plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"data/%@.plist", card]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
            {
                plistPath = [[NSBundle mainBundle] pathForResource:card ofType:@"plist"];
            }
            
            NSMutableArray *ma = [NSMutableArray arrayWithContentsOfFile:plistPath];
            for (NSDictionary *dict in ma)
            {
                OCard *card = [[OCard alloc] init];
            
                card.name = [dict valueForKey:@"name"];
                card.image = [dict valueForKey:@"image"];
                card.cost = [[dict valueForKey:@"cost"] intValue];
                card.text = [dict valueForKey:@"text"];
                switch ([[dict valueForKey:@"type"] intValue])
                {
                    case 0:
                    {
                        card.type = Quarry;
                        break;
                    }
                    case 1:
                    {
                        card.type = Magic;
                        break;
                    }
                    case 2:
                    {
                        card.type = Dungeon;
                        break;
                    }
                }
                card.playAgain = [[dict valueForKey:@"playAgain"] boolValue];
                if ([dict valueForKey:@"statFields"] && [dict valueForKey:@"statValues"])
                {
                    card.statFields = [NSDictionary dictionaryWithObjectsAndKeys:[dict valueForKey:@"statFields"], [dict valueForKey:@"statValues"], nil];
                }
            
                NSArray *ops = [dict valueForKey:@"ops"];
                if (ops)
                {
                    CFMutableArrayRef arrayRef = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
                    NSMutableArray *cardOps = (NSMutableArray *)arrayRef;
                    
                    for (NSDictionary *x in ops)
                    {
                        Ops o = create_ops;
                        
                        o->op1 = [[x valueForKey:@"op1"] intValue];
                        o->op2 = [[x valueForKey:@"op2"] intValue];
                        o->opResult = [[x valueForKey:@"opResult"] intValue];
                        o->opTarget = [[x valueForKey:@"opTarget"] intValue];
                        o->opValue = [[x valueForKey:@"opValue"] intValue];
                        switch ([[x valueForKey:@"opType"] intValue])
                        {
                            case 0:
                            {
                                o->opType = Eval;
                                break;
                            }
                            case 1:
                            {
                                o->opType = Eq;
                                break;
                            }
                        }
                        [cardOps addObject:(id)o];
                    }
                    card.ops = cardOps;
                }
            
                [_cards addObject:card];
            }
        }
    }
    
    return _cards;
}

@end
