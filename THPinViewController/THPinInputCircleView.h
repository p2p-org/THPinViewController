//
//  THPinInputCircleView.h
//  THPinViewController
//
//  Created by Thomas Heß on 14.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface THPinInputCircleView : UIView

@property (nonatomic, assign) BOOL filled;
@property (class) UIColor* fillColor;

+ (CGFloat)diameter;
+ (void)setFillColor:(UIColor *)fillColor;

@end

NS_ASSUME_NONNULL_END
