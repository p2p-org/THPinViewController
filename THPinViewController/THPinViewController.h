//
//  THPinViewController.h
//  THPinViewController
//
//  Created by Thomas Heß on 11.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;
#import "THPinView.h"

NS_ASSUME_NONNULL_BEGIN

@class THPinViewController;

// when using translucentBackground assign this tag to the view that should be blurred
static const NSInteger THPinViewControllerContentViewTag = 14742;

@protocol THPinViewControllerDelegate <NSObject>

@required
- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController;
- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin;
- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController;

@optional
- (void)incorrectPinEnteredInPinViewController:(THPinViewController *)pinViewController;
- (void)pinViewControllerWillDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController;
- (void)pinViewControllerDidDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController;
- (void)pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController;
- (void)pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController;
- (void)pinViewControllerWillDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController;
- (void)pinViewControllerDidDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController;
- (void)pinViewControllerDidStartEntering:(THPinViewController *)pinViewController;
- (void)pinViewController:(THPinViewController *)pinViewController didAddNumberToCurrentPin:(NSString *)pin;

@end

@interface THPinViewController : UIViewController

@property (nonatomic, weak, nullable) id<THPinViewControllerDelegate> delegate;
@property (nonatomic, strong, nullable) UIColor *backgroundColor; // is only used if translucentBackground == NO
@property (nonatomic, strong, nullable) UIButton *leftBottomButton;
@property (nonatomic, strong, nullable) UIImage *bottomButtonImage;
@property (nonatomic, assign) BOOL translucentBackground;
@property (nonatomic, copy, nullable) NSString *promptTitle;
@property (nonatomic, copy, nullable) NSString *errorTitle;
@property (nonatomic, strong, nullable) UIColor *promptColor;
@property (nonatomic, assign) BOOL hideLetters; // hides the letters on the number buttons
@property (nonatomic, assign) BOOL disableCancel; // hides the cancel button
@property (nonatomic, assign) BOOL disableDismissAniamtion;
@property (nonatomic, assign) BOOL disableDismissAfterCompletion;
@property (nonatomic, strong) THPinView *pinView;

- (instancetype)initWithDelegate:(nullable id<THPinViewControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;
- (void) clear;

@end

NS_ASSUME_NONNULL_END
