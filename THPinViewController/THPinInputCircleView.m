//
//  THPinInputCircleView.m
//  THPinViewController
//
//  Created by Thomas Heß on 14.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinInputCircleView.h"

@implementation THPinInputCircleView

static UIColor* _fillColor;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.layer.cornerRadius = [[self class] diameter] / 2.0f;
        
        [self tintColorDidChange];
    }
    return self;
}

- (void)tintColorDidChange
{
    self.backgroundColor = self.tintColor;
}

- (void)setFilled:(BOOL)filled
{
    self.backgroundColor = (filled) ? [[self class] fillColor] : self.tintColor;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake([[self class] diameter], [[self class] diameter]);
}

+ (CGFloat)diameter
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 16.0f : 12.5f;
}

+ (UIColor *)fillColor
{
    if (_fillColor == nil) {
        return [UIColor grayColor];
    }
    return _fillColor;
}

+ (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
}

@end
