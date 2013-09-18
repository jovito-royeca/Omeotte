//
//  SHPolygonImage.h
//  Sparrow 2.X
//
//  Created by Shilo White on 7/28/13.
//
//  Highly based on the following Sparrow extensions created by Daniel Sperl @ Gamua:
//  Polygon:         https://gist.github.com/PrimaryFeather/5352978
//  TexturedPolygon: https://gist.github.com/PrimaryFeather/5679832
//
//  Hit test code based on the following Starling extension, created by RomainThery:
//  Polygon.as:      https://gist.github.com/RomainThery/5366504/
//

#import "SHPolygon.h"

@class SPTexture;
@class SPPoint;
@class SPRectangle;

@interface SHPolygonImage : SHPolygon
{
    SPTexture *_texture;
}

- (id)initWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma;
- (id)initWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges color:(uint)color;
- (id)initWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges;

- (id)initWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma generateMipmaps:(BOOL)mipmaps;
- (id)initWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma;
- (id)initWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color;
- (id)initWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges;

+ (id)polygonImageWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma;
+ (id)polygonImageWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges color:(uint)color;
+ (id)polygonImageWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges;

+ (id)polygonImageWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma generateMipmaps:(BOOL)mipmaps;
+ (id)polygonImageWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma;
+ (id)polygonImageWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color;
+ (id)polygonImageWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges;

@property (nonatomic, strong) SPTexture *texture;
@property (nonatomic, strong) SPRectangle *textureFrame;
@property (nonatomic, assign) float textureFrameX;
@property (nonatomic, assign) float textureFrameY;
@property (nonatomic, assign) float textureFrameWidth;
@property (nonatomic, assign) float textureFrameHeight;

@end
