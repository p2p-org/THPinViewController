//
//  THPinInputCircleView.m
//  THPinViewController
//
//  Created by Thomas Heß on 14.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinInputCircleView.h"

@interface THPinInputCircleView ()
@property (nonatomic, strong) UIColor* defaultColor;
@end

@implementation THPinInputCircleView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        if (@available(iOS 11.0, *)) {
            self.defaultColor = [UIColor colorNamed:@"THPinViewController.CircleViewBackground"];
        }

        if (self.defaultColor == nil) {
            self.defaultColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.98 alpha:1.0];
        }

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
    UIColor *filledColor;
    if (@available(iOS 11.0, *)) {
        filledColor = [UIColor colorNamed:@"THPinViewController.CircleViewFilled"];
    }

    if (filledColor == nil) {
        filledColor = [UIColor colorWithRed:0.42 green:0.50 blue:0.96 alpha:1.0];
    }
    self.backgroundColor = (filled) ? filledColor : self.defaultColor;
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
