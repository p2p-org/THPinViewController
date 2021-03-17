//
//  THPinView.h
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 21.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class THPinView;

@protocol THPinViewDelegate <NSObject>

@required
- (NSUInteger)pinLengthForPinView:(THPinView *)pinView;
- (BOOL)pinView:(THPinView *)pinView isPinValid:(NSString *)pin;
- (void)cancelButtonTappedInPinView:(THPinView *)pinView;
- (void)correctPinWasEnteredInPinView:(THPinView *)pinView;
- (void)incorrectPinWasEnteredInPinView:(THPinView *)pinView;
- (void)pinViewDidStartEntering:(THPinView *)pinView;
- (void)pinView:(THPinView *)pinView didAddNumberToCurrentPin:(NSString *)pin;

@end

@interface THPinView : UIView

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, weak, nullable) id<THPinViewDelegate> delegate;
@property (nonatomic, copy, nullable) NSString *promptTitle;
@property (nonatomic, strong, nullable) UIColor *promptColor;
@property (nonatomic, assign) BOOL hideLetters;
@property (nonatomic, assign) BOOL disableCancel;
@property (nonatomic, strong, nullable) UIButton *leftBottomButton;
@property (nonatomic, strong, nullable) UIImage *bottomButtonImage;
@property (nonatomic, strong, nullable) NSString *errorTitle;

- (instancetype)initWithDelegate:(nullable id<THPinViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;
- (void) resetInput;

@end

NS_ASSUME_NONNULL_END
