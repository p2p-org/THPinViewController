//
//  THPinView.m
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 21.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinView.h"
#import "THPinInputCirclesView.h"
#import "THPinNumPadView.h"
#import "THPinNumButton.h"

@interface THPinView () <THPinNumPadViewDelegate>

@property (nonatomic, strong) THPinInputCirclesView *inputCirclesView;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) THPinNumPadView *numPadView;
@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, assign) CGFloat paddingBetweenInputCirclesAndNumPad;

@property (nonatomic, strong) NSMutableString *input;

@end

@implementation THPinView

- (instancetype)initWithDelegate:(id<THPinViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        _delegate = delegate;
        _input = [NSMutableString string];
        
        // configure stackView
        _stackView = [[UIStackView alloc] init];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = 0;
        
        // configure input circles view
        _inputCirclesView = [[THPinInputCirclesView alloc] initWithPinLength:[_delegate pinLengthForPinView:self]];
        _inputCirclesView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // configure error label
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.numberOfLines = 0;
        _errorLabel.font = [UIFont systemFontOfSize: 15.0f];
        [_errorLabel setTextColor:UIColor.redColor];
        [_errorLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel
                                                      forAxis:UILayoutConstraintAxisHorizontal];
        
        // configure num pad view
        _numPadView = [[THPinNumPadView alloc] initWithDelegate:self];
        _numPadView.translatesAutoresizingMaskIntoConstraints = NO;
        _numPadView.backgroundColor = self.backgroundColor;
        
        // configure bottom button
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _bottomButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_bottomButton setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel
                                                       forAxis:UILayoutConstraintAxisHorizontal];
        [_bottomButton setTitleColor: [self promptColor] forState:UIControlStateNormal];
        [self updateBottomButton];
        [self.bottomButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        
        // layout
        [self addSubview:_stackView];
        
        [self addConstraint:[_stackView.topAnchor constraintEqualToAnchor:self.topAnchor]];
        [self addConstraint:[_stackView.leftAnchor constraintEqualToAnchor:self.leftAnchor]];
        [self addConstraint:[_stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]];
        [self addConstraint:[_stackView.rightAnchor constraintEqualToAnchor:self.rightAnchor]];
        
        [_stackView addArrangedSubview:_inputCirclesView];
        [_stackView addArrangedSubview:_errorLabel];
        [_stackView addArrangedSubview:_numPadView];
        
        // spacing
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _paddingBetweenInputCirclesAndNumPad = 52.0f;
        } else {
            _paddingBetweenInputCirclesAndNumPad = 41.5f;
        }
        
        [_stackView setCustomSpacing:16.0f afterView:_inputCirclesView];
        [_stackView setCustomSpacing:_paddingBetweenInputCirclesAndNumPad afterView:_errorLabel];
        
        // layout bottom button (touchId/faceId button)
        [self addSubview:_bottomButton];
       
        // place button right of zero number button
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f constant:-[THPinNumButton diameter] / 2.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f constant:-[THPinNumButton diameter] / 2.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:0
                                                        multiplier:0.0f constant:[THPinNumButton diameter]]];
    }
    return self;
}

- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithDelegate:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithDelegate:nil];
}

- (CGSize)intrinsicContentSize
{
    CGFloat height = (self.inputCirclesView.intrinsicContentSize.height + self.paddingBetweenInputCirclesAndNumPad +
                      self.numPadView.intrinsicContentSize.height);
    return CGSizeMake(self.numPadView.intrinsicContentSize.width, height);
}

#pragma mark - Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    super.backgroundColor = backgroundColor;
    self.numPadView.backgroundColor = self.backgroundColor;
}

- (UIColor *)promptColor
{
    return _bottomButton.titleLabel.textColor;
}

- (void)setPromptColor:(UIColor *)promptColor
{
    [_bottomButton setTitleColor: [self promptColor] forState:UIControlStateNormal];
}

- (BOOL)hideLetters
{
    return self.numPadView.hideLetters;
}

- (void)setHideLetters:(BOOL)hideLetters
{
    self.numPadView.hideLetters = hideLetters;
}

- (void)setDisableCancel:(BOOL)disableCancel
{
    if (self.disableCancel == disableCancel) {
        return;
    }
    _disableCancel = disableCancel;
    [self updateBottomButton];
}

- (void)setLeftBottomButton:(UIButton *)leftBottomButton
{
    if (self.leftBottomButton == leftBottomButton) {
        return;
    }
    _leftBottomButton = leftBottomButton;
    [self updateLeftBottomButton];
}

- (void)setBottomButtonImage:(UIImage *)bottomButtonImage
{
    if (self.bottomButtonImage == bottomButtonImage) {
        return;
    }
    _bottomButtonImage = [bottomButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_bottomButton setImage:_bottomButtonImage forState:UIControlStateNormal];
}

- (NSString *)errorTitle
{
    return self.errorLabel.text;
}

- (void)setErrorTitle:(NSString *)errorTitle
{
    self.errorLabel.text = errorTitle;
}

#pragma mark - Public

- (void)updateBottomButton
{
    if (self.input.length == 0) {
        self.bottomButton.hidden = YES;
        return;
    }
    
    self.bottomButton.hidden = NO;
    
    if (_bottomButtonImage == nil) {
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"THPinViewController"
                                                                                    ofType:@"bundle"]];
        
            self.bottomButton.hidden = NO;
            [self.bottomButton setTitle:NSLocalizedStringFromTableInBundle(@"delete_button_title", @"THPinViewController",
                                                                           bundle, nil)
                               forState:UIControlStateNormal];
    } else {
        [_bottomButton setImage:_bottomButtonImage forState:UIControlStateNormal];
        [_bottomButton setTintColor:self.promptColor];
    }
    
}

- (void)updateLeftBottomButton
{
    if (!_leftBottomButton) {
        return;
    }
    
    _leftBottomButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_leftBottomButton setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel
                                                   forAxis:UILayoutConstraintAxisHorizontal];
    
    [self addSubview:_leftBottomButton];
    
    // place button right of zero number button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftBottomButton attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f constant:[THPinNumButton diameter] / 2.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftBottomButton attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f constant:-[THPinNumButton diameter] / 2.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftBottomButton attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:0
                                                    multiplier:0.0f constant:[THPinNumButton diameter]]];
}

#pragma mark - User Interaction

- (void)delete:(id)sender
{
    if (self.input.length < 2) {
        [self resetInput];
    } else {
        [self.input deleteCharactersInRange:NSMakeRange(self.input.length - 1, 1)];
        [self.inputCirclesView unfillCircleAtPosition:self.input.length];
    }
}

#pragma mark - THPinNumPadViewDelegate

- (void)pinNumPadView:(THPinNumPadView *)pinNumPadView numberTapped:(NSUInteger)number
{
    NSUInteger pinLength = [self.delegate pinLengthForPinView:self];
    
    if (pinLength == 0) {
        [self.delegate pinViewDidStartEntering:self];
    }
    
    if (self.input.length >= pinLength) {
        return;
    }
    
    [self.input appendString:[NSString stringWithFormat:@"%lu", (unsigned long)number]];
    [self.inputCirclesView fillCircleAtPosition:self.input.length - 1];

    [self.delegate pinView:self didAddNumberToCurrentPin:self.input];

    
    [self updateBottomButton];
    
    if (self.input.length < pinLength) {
        return;
    }
    
    if ([self.delegate pinView:self isPinValid:self.input])
    {
        double delayInSeconds = 0.3f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.delegate correctPinWasEnteredInPinView:self];
        });
        
    } else {
        
        [self.inputCirclesView shakeWithCompletion:^{
            [self resetInput];
            [self.delegate incorrectPinWasEnteredInPinView:self];
        }];
    }
}

#pragma mark - Util

- (void)resetInput
{
    self.input = [NSMutableString string];
    [self.inputCirclesView unfillAllCircles];
    [self updateBottomButton];
}

@end
