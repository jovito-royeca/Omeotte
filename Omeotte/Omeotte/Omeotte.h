//
//  Omeotte.h
//  Deck of Omeotte
//
//  Created by Jovito Royeca on 9/4/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#ifndef Deck_of_Omeotte_Omeotte_h
#define Deck_of_Omeotte_Omeotte_h

#define GAME_TITLE    @"Deck of Omeotte"

#define MAX_CARDS_IN_HAND       6
#define DEFAULT_CARDS_IN_DECK   500
#define MAX_GAME_TURNS          250

#define RED_COLOR               0xB22222  // firebrick
#define BLUE_COLOR              0x0000CD  // medium blue
#define GREEN_COLOR             0x228B22  // forestgreen
#define GOLD_COLOR              0xD9D919  // bright gold
#define WHITE_COLOR             0xF0FFFF  // azure
#define BLACK_COLOR             0x000000

#define GAME_TURN               30        // seconds

#define CALLIGRAPHICA_FILE      @"Kingthings_Calligraphica.fnt"
#define CALLIGRAPHICA_FONT      @"Kingthings Calligraphica"
#define EXETER_FILE             @"Kingthings_Exeter.fnt"
#define EXETER_FONT             @"Kingthings Exeter"

#define stage_width_mod(height,x)  ((x)/(Sparrow.stage.width)) * (Sparrow.stage.height)
#define stage_height_mod(width,x)  ((x)/(Sparrow.stage.height)) * (Sparrow.stage.width)

//#define CARD_TO_TEST            @"Lodestone"
#define CARDS_TO_BAN            [NSArray arrayWithObjects:@"Foundations", \
                                                          @"Mother Lode", \
                                                          @"Copping the Tech", \
                                                          @"Flood Water", \
                                                          @"Barracks", \
                                                          @"Shift", \
                                                          @"Bag of Baubles", \
                                                          @"Parity", \
                                                          @"Lightning Shard", \
                                                          @"Spearman", \
                                                          @"Spizzer", \
                                                          @"Unicorn", \
                                                          @"Elven Archers", \
                                                          @"Corrosion Cloud", \
                                                          @"Thief", \
                                                          nil];
#define GAME_SOUNDS_ON          1
#define CARD_BROWSER_ON         1

#endif
