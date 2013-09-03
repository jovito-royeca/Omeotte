//
//  OButton.m
//  Omeotte
//
//  Created by Jovito Royeca on 9/2/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OButtonTextureUI.h"

@implementation OButtonTextureUI

- (id)initWithWidth:(float)width
             height:(float)height
       cornerRadius:(float)cornerRadius
        strokeWidth:(float)strokeWidth
        strokeColor:(uint)strokeColor
              gloss:(BOOL)gloss
         startColor:(uint)startColor
           endColor:(uint)endColor
{
    if ((self = [super initWithWidth:width height:height
                                draw:^(CGContextRef context)
                                {
                                    CGRect rect = CGRectMake(0, 0, width, height);
                                    CGColorRef color1 = [UIColor colorWithRed:SP_COLOR_PART_RED(startColor)/255.0 green:SP_COLOR_PART_GREEN(startColor)/255.0 blue:SP_COLOR_PART_BLUE(startColor)/255.0 alpha:1].CGColor;
                                    CGColorRef color2 = [UIColor colorWithRed:SP_COLOR_PART_RED(endColor)/255.0 green:SP_COLOR_PART_GREEN(endColor)/255.0 blue:SP_COLOR_PART_BLUE(endColor)/255.0 alpha:1].CGColor;
                                    CGColorRef whiteColor1 = [UIColor colorWithRed:1 green:1 blue:1 alpha:.4].CGColor;
                                    CGColorRef whiteColor2 = [UIColor colorWithRed:1 green:1 blue:1 alpha:.1].CGColor;
                                    CGColorRef buttonStrokeColor = [UIColor colorWithRed:SP_COLOR_PART_RED(strokeColor) green:SP_COLOR_PART_GREEN(strokeColor) blue:SP_COLOR_PART_BLUE(strokeColor) alpha:1].CGColor;
                                    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
                                    NSArray *colors = [NSArray arrayWithObjects:(id)color1, (id)color2, nil];
                                    CGFloat locations[] = { 0,1 };
                                    CGGradientRef gradient = CGGradientCreateWithColors(rgb, (CFArrayRef)colors, locations);
                                    CGContextSaveGState(context);
                                    CGContextClipToRect(context, rect);
                                    rect.size.width -= strokeWidth;
                                    rect.size.height -= strokeWidth;
                                    rect.origin.x += strokeWidth / 2.0;
                                    rect.origin.y += strokeWidth / 2.0;
                                    if (cornerRadius != 0 && cornerRadius) {
                                        CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
                                        CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
                                        CGContextMoveToPoint(context, minx, midy);
                                        CGContextAddArcToPoint(context, minx, miny, midx, miny, cornerRadius);
                                        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, cornerRadius);
                                        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, cornerRadius);
                                        CGContextAddArcToPoint(context, minx, maxy, minx, midy, cornerRadius);
                                        CGContextClosePath(context);
                                    }
                                    CGContextClip(context);
                                    CGPoint start = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y);
                                    CGPoint end = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height);
                                    CGContextDrawLinearGradient(context, gradient, start, end, 0);
                                    CGGradientRelease(gradient);
                                    if (gloss) {
                                        NSArray *colors = [NSArray arrayWithObjects:(id)whiteColor1, (id)whiteColor2, nil];
                                        CGGradientRef gradient = CGGradientCreateWithColors(rgb, (CFArrayRef)colors, locations);
                                        CGPoint start = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y);
                                        CGPoint end = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2);
                                        CGContextDrawLinearGradient(context, gradient, start, end, 0);
                                        CGGradientRelease(gradient);
                                    }
                                    CGColorSpaceRelease(rgb);
                                    CGContextRestoreGState(context);
                                    if (strokeWidth != 0 && strokeWidth) {
                                        if (cornerRadius == 0 || !cornerRadius) {
                                            CGContextSetStrokeColorWithColor(context, buttonStrokeColor);
                                            CGContextSetLineWidth(context, strokeWidth);
                                            CGContextStrokeRect(context, rect);
                                        }
                                        else {
                                            CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
                                            CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
                                            CGContextMoveToPoint(context, minx, midy);
                                            CGContextAddArcToPoint(context, minx, miny, midx, miny, cornerRadius);
                                            CGContextAddArcToPoint(context, maxx, miny, maxx, midy, cornerRadius);
                                            CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, cornerRadius);
                                            CGContextAddArcToPoint(context, minx, maxy, minx, midy, cornerRadius);
                                            CGContextClosePath(context);
                                            CGContextSetStrokeColorWithColor(context, buttonStrokeColor);
                                            CGContextSetLineWidth(context, strokeWidth);
                                            CGContextStrokePath(context);
                                        }
                                    }
                                }])){}
    return self;
}

@end
