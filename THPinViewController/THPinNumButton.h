//
//  THPinNumButton.h
//  THPinViewController
//
//  Created by Thomas Heß on 14.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface THPinNumButton : UIButton

@property (nonatomic, readonly, assign) NSUInteger number;
@property (nonatomic, readonly, copy, nullable) NSString *letters;
@property (class) UIColor* textColor;
@property (class) UIColor* textHighlightColor;
@property (class) UIColor* backgroundHighlightColor;

- (instancetype)initWithNumber:(NSUInteger)number letters:(nullable NSString *)letters NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("Use -initWithNumber:letters: instead")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("Use -initWithNumber:letters: instead")));

+ (CGFloat)diameter;
+ (void)setTextColor:(UIColor *)textColor;
+ (void)setTextHighlightColor:(UIColor *)textHighlightColor;
+ (void)setBackgroundHighlightColor:(UIColor *)backgroundHighlightColor;

@end

NS_ASSUME_NONNULL_END
