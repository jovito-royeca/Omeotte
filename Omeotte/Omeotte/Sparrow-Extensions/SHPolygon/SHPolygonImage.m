//
//  SHPolygonImage.m
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

#import "SHPolygonImage.h"
#import "SPPoint.h"
#import "SPTexture.h"
#import "SPGLTexture.h"
#import "SPRenderSupport.h"
#import "SPMacros.h"
#import "SPVertexData.h"
#import "SPRectangle.h"

@implementation SHPolygonImage
{
    SPRectangle *_textureFrame;
}

@synthesize texture = _texture;
@synthesize textureFrame = _textureFrame;

- (id)initWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma
{
    if ((self = [super initWithRadius:radius numEdges:numEdges color:color premultipliedAlpha:pma]))
    {
        _texture = texture;
        _textureFrame = nil;
    }
    return self;
}

- (id)initWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges color:(uint)color
{
    return [self initWithTexture:texture radius:radius numEdges:numEdges color:color premultipliedAlpha:YES];
}

- (id)initWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges
{
    return [self initWithTexture:texture radius:radius numEdges:numEdges color:SP_WHITE];
}

- (id)initWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma generateMipmaps:(BOOL)mipmaps
{
    return [self initWithTexture:[SPTexture textureWithContentsOfFile:path generateMipmaps:mipmaps] radius:radius numEdges:numEdges color:color premultipliedAlpha:pma];
}

- (id)initWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma
{
    return [self initWithContentsOfFile:path radius:radius numEdges:numEdges color:color premultipliedAlpha:pma generateMipmaps:NO];
}

- (id)initWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color
{
    return [self initWithContentsOfFile:path radius:radius numEdges:numEdges color:color premultipliedAlpha:YES];
}

- (id)initWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges
{
    return [self initWithContentsOfFile:path radius:radius numEdges:numEdges color:SP_WHITE];
}

- (void)setupVertices
{
    // set up vertex data
    float diameter = self.radius*2;
    float textureWidth = _textureFrame ? _textureFrame.width/diameter: 1.0f;
    float textureHeight = _textureFrame ? _textureFrame.height/diameter : 1.0f;
    float textureX = _textureFrame ? -(((_textureFrame.x/diameter)/textureWidth)+((1.0f-textureWidth)/2/-textureWidth)) : 0.0f;
    float textureY = _textureFrame ? -(((_textureFrame.y/diameter)/textureHeight)+((1.0f-textureHeight)/2/-textureHeight)) : 0.0f;
    
    uint numEdges = _vertexData.numVertices-1;
    for (int i=0; i<numEdges; ++i)
    {
        float polarLength = (i<self.numDrawnEdges)?self.radius:0;
        
        SPPoint *edge = [[SPPoint alloc] initWithPolarLength:polarLength angle:i*2*PI / numEdges];
        [_vertexData setPosition:edge atIndex:i];
        
        if (_textureFrame)
        {
            [_vertexData setTexCoordsWithX:0.5f + edge.x / (2 * polarLength * textureWidth) + textureX
                                         y:0.5f + edge.y / (2 * polarLength * textureHeight) + textureY
                                   atIndex:i];
        }
        else
        {
            [_vertexData setTexCoordsWithX:0.5f + edge.x / (2 * polarLength)
                                         y:0.5f + edge.y / (2 * polarLength)
                                   atIndex:i];
        }
    }
    
     // center vertex
    [_vertexData setPositionWithX:0.0f y:0.0f atIndex:numEdges];
    [_vertexData setTexCoordsWithX:0.5f+textureX y:0.5f+textureY atIndex:numEdges];
    
    // above, we have inserted the "high level" vertex data, using a [0-1] range. The actual
    // texture coordinates for OpenGL might differ; the following method will adjust them.
    [_texture adjustVertexData:_vertexData atIndex:0 numVertices:numEdges+1];
    
    // set up index data
    
    int numIndices = numEdges * 3;
    
    if (!_indexData) _indexData = malloc(sizeof(ushort) * numIndices);
    else             _indexData = realloc(_indexData, sizeof(ushort) * numIndices);
    
    for (int i=0; i<numEdges; ++i)
    {
        _indexData[i*3]   = numEdges;
        _indexData[i*3+1] = i;
        _indexData[i*3+2] = (i+1) % numEdges;
    }
}

- (void)render:(SPRenderSupport *)support
{
    if (self.requiresUpdate) [self update];
    
    [support finishQuadBatch]; // finish previously batched quads
    [support addDrawCalls:1];  // update stats display
    
    _baseEffect.mvpMatrix = support.mvpMatrix;
    _baseEffect.alpha = support.alpha;
    _baseEffect.texture = _texture;
    [_baseEffect prepareToDraw];
    
    [SPBlendMode applyBlendFactorsForBlendMode:support.blendMode
                            premultipliedAlpha:_vertexData.premultipliedAlpha];
    
    int attribPosition  = _baseEffect.attribPosition;
    int attribColor     = _baseEffect.attribColor;
    int attribTexCoords = _baseEffect.attribTexCoords;
    
    glEnableVertexAttribArray(attribPosition);
    glEnableVertexAttribArray(attribColor);
    glEnableVertexAttribArray(attribTexCoords);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferName);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferName);
    
    glVertexAttribPointer(attribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(SPVertex),
                          (void *)(offsetof(SPVertex, position)));
    
    glVertexAttribPointer(attribColor, 4, GL_UNSIGNED_BYTE, GL_TRUE, sizeof(SPVertex),
                          (void *)(offsetof(SPVertex, color)));
    
    if (self.texture)
        glVertexAttribPointer(attribTexCoords, 2, GL_FLOAT, GL_FALSE, sizeof(SPVertex),
                              (void *)(offsetof(SPVertex, texCoords)));
    
    int numIndices = (_vertexData.numVertices - 1) * 3;
    glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_SHORT, 0);
}

- (void)setTexture:(SPTexture *)value
{
    if (value == nil)
    {
        [NSException raise:SP_EXC_INVALID_OPERATION format:@"texture cannot be nil!"];
    }
    else if (value != _texture)
    {
        _texture = value;
        self.requiresUpdate = YES;
        [_vertexData setPremultipliedAlpha:_texture.premultipliedAlpha updateVertices:YES];
        [self vertexDataDidChange];
    }
}

- (void)setTextureFrame:(SPRectangle *)textureFrame
{
    if (textureFrame != _textureFrame)
    {
        _textureFrame = textureFrame;
        self.requiresUpdate = YES;
    }
}

- (void)setTextureFrameX:(float)textureFrameX
{
    _textureFrame.x = textureFrameX;
    self.requiresUpdate = YES;
}

- (void)setTextureFrameY:(float)textureFrameY
{
    _textureFrame.y = textureFrameY;
    self.requiresUpdate = YES;
}

- (void)setTextureFrameWidth:(float)textureFrameWidth
{
    _textureFrame.width = textureFrameWidth;
    self.requiresUpdate = YES;
}

- (void)setTextureFrameHeight:(float)textureFrameHeight
{
    _textureFrame.height = textureFrameHeight;
    self.requiresUpdate = YES;
}

- (float)textureFrameX
{
    return _textureFrame.x;
}

- (float)textureFrameY
{
    return _textureFrame.y;
}

- (float)textureFrameWidth
{   
    return _textureFrame.width;
}

- (float)textureFrameHeight
{
    return _textureFrame.height;
}

+ (id)polygonImageWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma
{
    return [[self alloc] initWithTexture:texture radius:radius numEdges:numEdges color:color premultipliedAlpha:pma];
}

+ (id)polygonImageWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges color:(uint)color
{
    return [[self alloc] initWithTexture:texture radius:radius numEdges:numEdges color:color];
}

+ (id)polygonImageWithTexture:(SPTexture *)texture radius:(float)radius numEdges:(uint)numEdges
{
    return [[self alloc] initWithTexture:texture radius:radius numEdges:numEdges];
}

+ (id)polygonImageWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma generateMipmaps:(BOOL)mipmaps
{
    return [[self alloc] initWithContentsOfFile:path radius:radius numEdges:numEdges color:color premultipliedAlpha:pma generateMipmaps:mipmaps];
}

+ (id)polygonImageWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma
{
    return [[self alloc] initWithContentsOfFile:path radius:radius numEdges:numEdges color:color premultipliedAlpha:pma];
}

+ (id)polygonImageWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges color:(uint)color
{
    return [[self alloc] initWithContentsOfFile:path radius:radius numEdges:numEdges color:color];
}

+ (id)polygonImageWithContentsOfFile:(NSString *)path radius:(float)radius numEdges:(uint)numEdges
{
    return [[self alloc] initWithContentsOfFile:path radius:radius numEdges:numEdges];
}

@end
