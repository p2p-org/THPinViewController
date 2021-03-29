//
//  THPinViewController.m
//  THPinViewController
//
//  Created by Thomas Heß on 11.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinViewController.h"
#import "THPinView.h"
#import "UIImage+ImageEffects.h"

@interface THPinViewController () <THPinViewDelegate>

@property (nonatomic, strong) THPinView *pinView;
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, strong) NSArray *blurViewContraints;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation THPinViewController

- (instancetype)initWithDelegate:(id<THPinViewControllerDelegate>)delegate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _delegate = delegate;
        _backgroundColor = [UIColor whiteColor];
        _translucentBackground = NO;
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"THPinViewController"
                                                                                    ofType:@"bundle"]];
        _promptTitle = NSLocalizedStringFromTableInBundle(@"prompt_title", @"THPinViewController", bundle, nil);
    }
    return self;
}

- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    return [self initWithDelegate:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithDelegate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.translucentBackground) {
        self.view.backgroundColor = [UIColor clearColor];
        [self addBlurView];
    } else {
        self.view.backgroundColor = self.backgroundColor;
    }
    
    // configure prompt label
    _promptLabel = [[UILabel alloc] init];
    _promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.numberOfLines = 0;
    _promptLabel.font = [UIFont systemFontOfSize: 21.0f weight: UIFontWeightSemibold];
    [_promptLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel
                                                  forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.view addSubview:_promptLabel];
    _promptLabel.text = _promptTitle;
    
    self.pinView = [[THPinView alloc] initWithDelegate:self];
    self.pinView.backgroundColor = self.view.backgroundColor;
    self.pinView.hideLetters = self.hideLetters;
    self.pinView.disableCancel = self.disableCancel;
    self.pinView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.pinView];
    CGFloat topToPromptLabel = 0.0f;
    CGFloat promptLabelToPad = 0.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        topToPromptLabel = 108.0f;
        promptLabelToPad = 55.0f;
    } else {
        BOOL isLargeScreen = (CGRectGetHeight([UIScreen mainScreen].bounds) > 812.0f);
        if (isLargeScreen) {
            topToPromptLabel = 108.0f;
            promptLabelToPad = 55.0f;
        } else {
            topToPromptLabel = 70.0f;
            promptLabelToPad = 27.5f;
        }
    }
    
    [self.view addConstraint:[_promptLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant: 20.0f]];
    [self.view addConstraint:[_promptLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant: -20.0f]];
    [self.view addConstraint: [_promptLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:topToPromptLabel]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pinView attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f constant:0.0f]];
    
    [self.view addConstraint:[_pinView.topAnchor constraintEqualToAnchor:_promptLabel.bottomAnchor constant:promptLabelToPad]];
    
    [self.view bringSubviewToFront:_promptLabel];
}

#pragma mark - Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if ([self.backgroundColor isEqual:backgroundColor]) {
        return;
    }
    _backgroundColor = backgroundColor;
    if (! self.translucentBackground) {
        self.view.backgroundColor = self.backgroundColor;
        self.pinView.backgroundColor = self.backgroundColor;
    }
}

- (void)setTranslucentBackground:(BOOL)translucentBackground
{
    if (self.translucentBackground == translucentBackground) {
        return;
    }
    _translucentBackground = translucentBackground;
    if (self.translucentBackground) {
        self.view.backgroundColor = [UIColor clearColor];
        self.pinView.backgroundColor = [UIColor clearColor];
        [self addBlurView];
    } else {
        self.view.backgroundColor = self.backgroundColor;
        self.pinView.backgroundColor = self.backgroundColor;
        [self removeBlurView];
    }
}

- (void)setPromptTitle:(NSString *)promptTitle
{
    if ([self.promptTitle isEqualToString:promptTitle]) {
        return;
    }
    _promptTitle = [promptTitle copy];
    _promptLabel.text = promptTitle;
}

- (void)setErrorTitle:(NSString *)errorTitle
{
    if ([self.errorTitle isEqualToString:errorTitle]) {
        return;
    }
    _errorTitle = [errorTitle copy];
    self.pinView.errorTitle = self.errorTitle;
}

- (void)setPromptColor:(UIColor *)promptColor
{
    if ([self.promptColor isEqual:promptColor]) {
        return;
    }
    _promptColor = promptColor;
    _promptLabel.textColor = promptColor;
    self.pinView.promptColor = self.promptColor;
}

- (void)setHideLetters:(BOOL)hideLetters
{
    if (self.hideLetters == hideLetters) {
        return;
    }
    _hideLetters = hideLetters;
    self.pinView.hideLetters = self.hideLetters;
}

- (void)setDisableCancel:(BOOL)disableCancel
{
    if (self.disableCancel == disableCancel) {
        return;
    }
    _disableCancel = disableCancel;
    self.pinView.disableCancel = self.disableCancel;
}

- (void)setLeftBottomButton:(UIButton *)leftBottomButton
{
    if (self.leftBottomButton == leftBottomButton) {
        return;
    }
    _leftBottomButton = leftBottomButton;
    self.pinView.leftBottomButton = self.leftBottomButton;
}

- (void)setBottomButtonImage:(UIImage *)bottomButtonImage
{
    if (self.bottomButtonImage == bottomButtonImage) {
        return;
    }
    _bottomButtonImage = bottomButtonImage;
    self.pinView.bottomButtonImage = self.bottomButtonImage;
}

#pragma mark - Blur

- (void)addBlurView
{
    self.blurView = [[UIImageView alloc] initWithImage:[self blurredContentImage]];
    self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:self.blurView belowSubview:self.pinView];
    NSDictionary *views = @{ @"blurView" : self.blurView };
    NSMutableArray *constraints =
    [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|"
                                                                           options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurView]|"
                                                                             options:0 metrics:nil views:views]];
    self.blurViewContraints = constraints;
    [self.view addConstraints:self.blurViewContraints];
}

- (void)removeBlurView
{
    [self.blurView removeFromSuperview];
    self.blurView = nil;
    [self.view removeConstraints:self.blurViewContraints];
    self.blurViewContraints = nil;
}

- (UIImage*)blurredContentImage
{
    UIView *contentView = [[UIApplication sharedApplication].keyWindow viewWithTag:THPinViewControllerContentViewTag];
    if (! contentView) {
        return nil;
    }
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [contentView drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image applyBlurWithRadius:20.0f tintColor:[UIColor colorWithWhite:1.0f alpha:0.25f]
                saturationDeltaFactor:1.8f maskImage:nil];
}

#pragma mark - THPinView actions
- (void) clear
{
    [self.pinView resetInput];
}

#pragma mark - THPinViewDelegate

- (NSUInteger)pinLengthForPinView:(THPinView *)pinView
{
    NSUInteger pinLength = [self.delegate pinLengthForPinViewController:self];
    NSAssert(pinLength > 0, @"PIN length must be greater than 0");
    return MAX(pinLength, (NSUInteger)1);
}

- (BOOL)pinView:(THPinView *)pinView isPinValid:(NSString *)pin
{
    return [self.delegate pinViewController:self isPinValid:pin];
}

- (void)cancelButtonTappedInPinView:(THPinView *)pinView
{
    if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasCancelled:)]) {
        [self.delegate pinViewControllerWillDismissAfterPinEntryWasCancelled:self];
    }
    if (!_disableDismissAfterCompletion) {
        [self dismissViewControllerAnimated:!_disableDismissAniamtion completion:^{
            if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasCancelled:)]) {
                [self.delegate pinViewControllerDidDismissAfterPinEntryWasCancelled:self];
            }
        }];
    }
}

- (void)correctPinWasEnteredInPinView:(THPinView *)pinView
{
    if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasSuccessful:)]) {
        [self.delegate pinViewControllerWillDismissAfterPinEntryWasSuccessful:self];
    }
    if (!_disableDismissAfterCompletion) {
        [self dismissViewControllerAnimated:!_disableDismissAniamtion completion:^{
            if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasSuccessful:)]) {
                [self.delegate pinViewControllerDidDismissAfterPinEntryWasSuccessful:self];
            }
        }];
    }
}

- (void)incorrectPinWasEnteredInPinView:(THPinView *)pinView
{
    if ([self.delegate userCanRetryInPinViewController:self]) {
        if ([self.delegate respondsToSelector:@selector(incorrectPinEnteredInPinViewController:)]) {
            [self.delegate incorrectPinEnteredInPinViewController:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:)]) {
            [self.delegate pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:self];
        }
        if (!_disableDismissAfterCompletion) {
            [self dismissViewControllerAnimated:!_disableDismissAniamtion completion:^{
                if ([self.delegate respondsToSelector:@selector(pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:)]) {
                    [self.delegate pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:self];
                }
            }];
        }
    }
}

- (void)pinViewDidStartEntering:(THPinView *)pinView
{
    [self.delegate pinViewControllerDidStartEntering:self];
}

- (void)pinView:(THPinView *)pinView didAddNumberToCurrentPin:(NSString *)pin
{
    if ([self.delegate respondsToSelector:@selector(pinViewController:didAddNumberToCurrentPin:)]) {
        [self.delegate pinViewController:self didAddNumberToCurrentPin:pin];
    }
}

@end
