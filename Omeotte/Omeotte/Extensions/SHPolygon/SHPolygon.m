//
//  SHPolygon.m
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
#import "SPBaseEffect.h"
#import "SPVertexData.h"
#import "SPPoint.h"
#import "SPMacros.h"
#import "SPRenderSupport.h"
#import "SPBlendMode.h"
#import "SPRectangle.h"
#import "SPMatrix.h"

@implementation SHPolygon
{
    float _radius;
    uint _numDrawnEdges;
    BOOL _requiresUpdate;
    BOOL _tinted;
}

@synthesize radius = _radius;
@synthesize requiresUpdate = _requiresUpdate;
@synthesize numDrawnEdges = _numDrawnEdges;

- (id)initWithRadius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma
{
    if ((self = [super init]))
    {
        _radius = radius;
        _tinted = color != 0xffffff;
        _numDrawnEdges = MAX(3, numEdges);
        _baseEffect = [[SPBaseEffect alloc] init];
        
        _vertexData = [[SPVertexData alloc] initWithSize:_numDrawnEdges+1 premultipliedAlpha:pma];
        for (int i=0; i<_vertexData.numVertices; ++i)
            _vertexData.vertices[i].color = SPVertexColorMakeWithColorAndAlpha(color, 1.0f);
        
        _requiresUpdate = YES;
        
        [self vertexDataDidChange];
    }
    return self;
}

- (id)initWithRadius:(float)radius numEdges:(uint)numEdges color:(uint)color
{
    return [self initWithRadius:radius numEdges:numEdges color:color premultipliedAlpha:YES];
}

- (id)initWithRadius:(float)radius numEdges:(uint)numEdges
{
    return [self initWithRadius:radius numEdges:numEdges color:SP_WHITE];
}

- (id)init
{
    return [self initWithRadius:32.0f numEdges:5];
}

- (void)dealloc
{
    free(_indexData);
}

- (void)update
{
    [self setupVertices];
    [self createBuffers];
    
    _requiresUpdate = NO;
}

- (void)setupVertices
{
    // set up vertex data
    uint numEdges = _vertexData.numVertices-1;
    for (int i=0; i<numEdges; ++i)
    {
        float polarLength = (i<_numDrawnEdges)?_radius:0;
        
        SPPoint *edge = [[SPPoint alloc] initWithPolarLength:polarLength angle:i*2*PI / numEdges];
        [_vertexData setPosition:edge atIndex:i];
    }
    
    [_vertexData setPositionWithX:0.0f y:0.0f atIndex:numEdges]; // center vertex
    
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

- (void)createBuffers
{
    int numIndices  = (_vertexData.numVertices - 1) * 3;
    
    if (_vertexBufferName) glDeleteBuffers(1, &_vertexBufferName);
    if (_indexBufferName)  glDeleteBuffers(1, &_indexBufferName);
    
    glGenBuffers(1, &_vertexBufferName);
    glGenBuffers(1, &_indexBufferName);
    
    if (!_vertexBufferName || !_indexBufferName)
        [NSException raise:SP_EXC_OPERATION_FAILED format:@"could not create vertex buffers"];
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferName);
    glBufferData(GL_ARRAY_BUFFER, sizeof(SPVertex) * _vertexData.numVertices, _vertexData.vertices,
                 GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferName);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(ushort) * numIndices, _indexData, GL_STATIC_DRAW);
}

- (void)render:(SPRenderSupport *)support
{
    if (_requiresUpdate) [self update];
    
    [support finishQuadBatch]; // finish previously batched quads
    [support addDrawCalls:1];  // update stats display
    
    _baseEffect.mvpMatrix = support.mvpMatrix;
    _baseEffect.alpha = support.alpha;
    [_baseEffect prepareToDraw];
    
    [SPBlendMode applyBlendFactorsForBlendMode:support.blendMode
                            premultipliedAlpha:_vertexData.premultipliedAlpha];
    
    int attribPosition  = _baseEffect.attribPosition;
    int attribColor     = _baseEffect.attribColor;
    
    glEnableVertexAttribArray(attribPosition);
    glEnableVertexAttribArray(attribColor);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferName);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferName);
    
    glVertexAttribPointer(attribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(SPVertex),
                          (void *)(offsetof(SPVertex, position)));
    
    glVertexAttribPointer(attribColor, 4, GL_UNSIGNED_BYTE, GL_TRUE, sizeof(SPVertex),
                          (void *)(offsetof(SPVertex, color)));
    
    int numIndices = (_vertexData.numVertices - 1) * 3;
    glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_SHORT, 0);
}

- (SPRectangle*)boundsInSpace:(SPDisplayObject*)targetSpace
{
    if (_requiresUpdate) [self update];
    if (!targetSpace) targetSpace = self;
    
    SPMatrix *matrix = [self transformationMatrixToSpace:targetSpace];
    return [_vertexData boundsAfterTransformation:matrix];
}

- (SPDisplayObject *)hitTestPoint:(SPPoint *)localPoint
{
    if ([super hitTestPoint:localPoint])
    {
        int i;
        int j;
        BOOL hit = NO;
        for (i=0, j=_vertexData.numVertices-2; i<_vertexData.numVertices-1; j=i++)
        {
            SPPoint *point1 = [_vertexData positionAtIndex:i];
            SPPoint *point2 = [_vertexData positionAtIndex:j];
            if (((point1.y > localPoint.y) != (point2.y > localPoint.y)) && (localPoint.x < (point2.x - point1.x) * (localPoint.y - point1.y) / (point2.y - point1.y) + point1.x))
                hit = !hit;
        }
        
        if (hit) return self;
        else return nil;
    }
    else return nil;
}

- (void)setNumEdges:(uint)numEdges
{
    if (numEdges != _vertexData.numVertices-1)
    {
        uint baseColor = self.color;
        uint lastNumVertices = _vertexData.numVertices;
        
        _numDrawnEdges = numEdges;
        _vertexData.numVertices = numEdges + 1;
        for (int i=lastNumVertices; i<_vertexData.numVertices; ++i)
            _vertexData.vertices[i].color = SPVertexColorMakeWithColorAndAlpha(baseColor, 1.0f);
    
        _requiresUpdate = YES;
    }
}

- (uint)numEdges
{
    return _vertexData.numVertices-1;
}

- (void)setNumDrawnEdges:(uint)numDrawnEdges
{
    if (numDrawnEdges != _numDrawnEdges)
    {
        _numDrawnEdges = MAX(3, MIN(numDrawnEdges, _vertexData.numVertices-1));
        _requiresUpdate = YES;
    }
}

- (void)setRadius:(float)radius
{
    if (radius != _radius)
    {
        _radius = radius;
        _requiresUpdate = YES;
    }
}

- (void)setColor:(uint)color ofVertex:(uint)vertexID
{
    [_vertexData setColor:color atIndex:vertexID];
    [self vertexDataDidChange];
    
    if (color != 0xffffff) _tinted = YES;
    else _tinted = (self.alpha != 1.0f) || _vertexData.tinted;
    
    _requiresUpdate = YES;
}

- (uint)colorOfVertex:(uint)vertexID
{
    return [_vertexData colorAtIndex:vertexID];
}

- (void)setColor:(uint)color
{
    for (int i=0; i<_vertexData.numVertices; ++i)
        [_vertexData setColor:color atIndex:i];
    
    [self vertexDataDidChange];
    
    if (color != 0xffffff) _tinted = YES;
    else _tinted = (self.alpha != 1.0f) || _vertexData.tinted;
    
    _requiresUpdate = YES;
}

- (uint)color
{
    return [self colorOfVertex:0];
}

- (void)setAlpha:(float)alpha ofVertex:(uint)vertexID
{
    [_vertexData setAlpha:alpha atIndex:vertexID];
    [self vertexDataDidChange];
    
    if (alpha != 1.0) _tinted = true;
    else _tinted = (self.alpha != 1.0f) || _vertexData.tinted;
    
    _requiresUpdate = YES;
}

- (float)alphaOfVertex:(uint)vertexID
{
    return [_vertexData alphaAtIndex:vertexID];
}

- (void)setAlpha:(float)alpha
{
    super.alpha = alpha;
    
    if (self.alpha != 1.0f) _tinted = true;
    else _tinted = _vertexData.tinted;
}

- (BOOL)premultipliedAlpha
{
    return _vertexData.premultipliedAlpha;
}

- (void)setPremultipliedAlpha:(BOOL)premultipliedAlpha
{
    if (premultipliedAlpha != self.premultipliedAlpha)
        _vertexData.premultipliedAlpha = premultipliedAlpha;
}

- (BOOL)tinted
{
    return _tinted;
}

- (SPTexture *)texture
{
    return nil;
}

- (uint)centerVertexIndex
{
    return _vertexData.numVertices-1;
}

- (void)vertexDataDidChange
{
    // override in subclass
}

+ (id)polygonWithRadius:(float)radius numEdges:(uint)numEdges color:(uint)color premultipliedAlpha:(BOOL)pma
{
    return [[self alloc] initWithRadius:radius numEdges:numEdges color:color premultipliedAlpha:pma];
}

+ (id)polygonWithRadius:(float)radius numEdges:(uint)numEdges color:(uint)color
{
    return [[self alloc] initWithRadius:radius numEdges:numEdges color:color];
}

+ (id)polygonWithRadius:(float)radius numEdges:(uint)numEdges
{
    return [[self alloc] initWithRadius:radius numEdges:numEdges];
}
+ (id)polygon
{
    return [[self alloc] init];
}

@end
