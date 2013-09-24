//
//  CWrapper.h
//  Omeotte
//
//  Created by Jovito Royeca on 9/20/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWrapper : NSObject

/*
structs in NSArray...

// add:
[array addObject:[NSValue value:&p withObjCType:@encode(struct Point)]];

// extract:
struct Point p;
[[array objectAtIndex:i] getValue:&p];
 */

+(void) addVoidPointer:(void*)vptr toNSArray:(NSArray*)array;

@end
