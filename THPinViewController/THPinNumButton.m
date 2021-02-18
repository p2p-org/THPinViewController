//
//  THPinNumButton.m
//  THPinViewController
//
//  Created by Thomas Heß on 14.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinNumButton.h"
#import "THPinViewController.h"
#import "THPinInputCircleView.h"

@interface THPinNumButton ()

@property (nonatomic, readwrite, assign) NSUInteger number;
@property (nonatomic, readwrite, copy) NSString *letters;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *lettersLabel;

@property (nonatomic, strong) UIColor *backgroundColorBackup;

@end

@implementation THPinNumButton

static UIColor* _textColor;
static UIColor* _textHighlightColor;
static UIColor* _backgroundHighlightColor;

- (instancetype)initWithNumber:(NSUInteger)number letters:(NSString *)letters
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        _number = number;
        _letters = letters;
        
        self.layer.cornerRadius = [[self class] diameter] / 2.0f;
        
        UIView *contentView = [[UIView alloc] init];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.userInteractionEnabled = NO;
        [self addSubview:contentView];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _numberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)number];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont systemFontOfSize:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 41.0f : 36.0f];
        [contentView addSubview:_numberLabel];
        [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[numberLabel]|" options:0
                                                                            metrics:nil
                                                                              views:@{ @"numberLabel" : _numberLabel }]];
        
        CGSize numberSize = [_numberLabel.text sizeWithAttributes:@{ NSFontAttributeName : _numberLabel.font }];
        CGFloat contentViewHeight = ceil(numberSize.height);
        
        if (_letters)
        {
            _lettersLabel = [[UILabel alloc] init];
            _lettersLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _lettersLabel.text = _letters;
            _lettersLabel.textAlignment = NSTextAlignmentCenter;
            _lettersLabel.font = [UIFont systemFontOfSize:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 11.0f : 9.0f];
            [contentView addSubview:_lettersLabel];
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lettersLabel]|" options:0
                                                                                metrics:nil
                                                                                  views:@{ @"lettersLabel" : _lettersLabel }]];
            
            CGFloat numberLabelYCorrection = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0.0f : -3.5f;
            CGFloat lettersLabelYCorrection = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? -6.5f : -4.0f;
            
            CGSize lettersSize = [_lettersLabel.text sizeWithAttributes:@{ NSFontAttributeName : _lettersLabel.font }];
            contentViewHeight += ceil(lettersSize.height) + numberLabelYCorrection;
            
            // pin number label to top
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:contentView attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:numberLabelYCorrection]];
            // pin letter label to bottom
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lettersLabel attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:contentView attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:lettersLabelYCorrection]];
        } else {
            
            // pin number label to top
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:contentView attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:0.0f]];
        }

        // set contentView height
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual toItem:nil attribute:0
                                                        multiplier:0.0f constant:contentViewHeight]];
        // center contentView horizontally
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f constant:0.0f]];
        // center contentView vertically
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f constant:0.0f]];
        [self tintColorDidChange];
    }
    return self;
}

- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithNumber:0 letters:nil];
}

- (nonnull instancetype)initWithCoder:(nonnull NSCoder *)aDecoder
{
    return [self initWithNumber:0 letters:nil];
}

- (void)tintColorDidChange
{
//    self.layer.borderColor = self.tintColor.CGColor;
    self.backgroundColor = self.tintColor;
    self.numberLabel.textColor = [[self class] textColor];
    self.lettersLabel.textColor = [[self class] textColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.backgroundColorBackup = self.backgroundColor;
    self.backgroundColor = [self.class backgroundHighlightColor];
    UIColor *textColor = [self.class textHighlightColor];
    self.numberLabel.textColor = textColor;
    self.lettersLabel.textColor = textColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self resetHighlight];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self resetHighlight];
}

- (void)resetHighlight
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.backgroundColor = self.backgroundColorBackup;
                     } completion:^(BOOL finished) {
                         self.numberLabel.textColor = [[self class] textColor];
                         self.lettersLabel.textColor = [[self class] textColor];
                     }];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake([[self class] diameter], [[self class] diameter]);
}

+ (CGFloat)diameter
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 82.0f : 75.0f;
}

+ (UIColor *)textColor
{
    if (_textColor == nil) {
        return UIColor.blackColor;
    }
    return _textColor;
}

+ (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
}

+ (UIColor *)textHighlightColor
{
    if (_textHighlightColor == nil) {
        return _textColor;
    }
    return _textHighlightColor;
}

+ (void)setTextHighlightColor:(UIColor *)textHighlightColor
{
    _textHighlightColor = textHighlightColor;
}

+ (UIColor *)backgroundHighlightColor
{
    if (_backgroundHighlightColor == nil) {
        return [UIColor clearColor];
    }
    return _backgroundHighlightColor;
}

+ (void)setBackgroundHighlightColor:(UIColor *)backgroundHighlightColor
{
    _backgroundHighlightColor = backgroundHighlightColor;
}

@end
