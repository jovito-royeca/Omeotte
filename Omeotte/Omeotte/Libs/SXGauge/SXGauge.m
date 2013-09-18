#import "SXGauge.h"

@implementation SXGauge
{
    SPImage *_image;
    float _ratio;
}

@synthesize ratio = _ratio;

- (id)initWithTexture:(SPTexture*)texture
{
    if ((self = [super init]))
    {
        _ratio = 1.0f;
        _image = [SPImage imageWithTexture:texture];
        [self addChild:_image];
    }
    return self;
}

- (id)init
{
    return [self initWithTexture:[SPTexture emptyTexture]];
}

- (void)update
{
    _image.scaleX = _ratio;
    [_image setTexCoordsWithX:_ratio y:0.0f ofVertex:1];
    [_image setTexCoordsWithX:_ratio y:1.0f ofVertex:3];
}

- (void)setRatio:(float)value
{
    _ratio = MAX(0.0f, MIN(1.0f, value));
    [self update];
}

+ (SXGauge *)gaugeWithTexture:(SPTexture *)texture
{
    return [[SXGauge alloc] initWithTexture:texture];
}

@end