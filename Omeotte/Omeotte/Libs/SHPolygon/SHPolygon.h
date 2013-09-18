//
//  SHPolygon.h
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

#import "Sparrow.h"

#import "SPDisplayObject.h"

@class SPBaseEffect;
@class SPVertexData;

@interface SHPolygon : SPDisplayObject
{
    SPBaseEffect *_baseEffect;
    SPVertexData *_vertexData;
    uint _vertexBufferName;
    uint _indexBufferName;
    ushort *_indexData;
}

- (id)initWithRadius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma;
- (id)initWithRadius:(float)radius numEdges:(uint)numEdges color:(uint)color;
- (id)initWithRadius:(float)radius numEdges:(uint)numEdges;

- (void)setColor:(uint)color ofVertex:(uint)vertexID;
- (uint)colorOfVertex:(uint)vertexID;
- (void)setAlpha:(float)alpha ofVertex:(uint)vertexID;
- (float)alphaOfVertex:(uint)vertexID;

- (void)update;
- (void)vertexDataDidChange;

+ (id)polygonWithRadius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma;
+ (id)polygonWithRadius:(float)radius numEdges:(uint)numEdges color:(uint)color;
+ (id)polygonWithRadius:(float)radius numEdges:(uint)numEdges;
+ (id)polygon;

@property (nonatomic, assign) float radius;
@property (nonatomic, assign) uint numEdges;
@property (nonatomic, assign) uint numDrawnEdges;
@property (nonatomic, assign) uint color;
@property (nonatomic, assign) BOOL requiresUpdate;
@property (nonatomic, assign) BOOL premultipliedAlpha;
@property (nonatomic, readonly) BOOL tinted;
@property (nonatomic, readonly) SPTexture *texture;
@property (nonatomic, readonly) uint centerVertexIndex;

@end
