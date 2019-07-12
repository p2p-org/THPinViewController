//
//  THPinInputCircleView.m
//  THPinViewController
//
//  Created by Thomas Heß on 14.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinInputCircleView.h"

@implementation THPinInputCircleView

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
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1.0];
}

- (void)setFilled:(BOOL)filled
{
    self.backgroundColor = (filled) ? [UIColor colorWithRed:0.42 green:0.50 blue:0.96 alpha:1.0] : [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1.0];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake([[self class] diameter], [[self class] diameter]);
}

+ (CGFloat)diameter
{
    return 20.0f;
}

@end
