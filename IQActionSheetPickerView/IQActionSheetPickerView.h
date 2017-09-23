//
// IQActionSheetPickerView.h
// https://github.com/hackiftekhar/IQActionSheetPickerView
// Copyright (c) 2013-14 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "IQActionSheetToolbar.h"

#import <UIKit/UIControl.h>
#import <Foundation/NSArray.h>

@class NSString, NSNumber, NSDate;
@class UIFont, UIColor;

/**
Action Sheet style settings.
 
 `IQActionSheetPickerStyleTextPicker`
 Show pickerView with provided text data.
 
 `IQActionSheetPickerStyleDatePicker`
 Show UIDatePicker.
 */
typedef NS_ENUM(NSUInteger, IQActionSheetPickerStyle) {
    
    IQActionSheetPickerStyleTextPicker,
    
    IQActionSheetPickerStyleDatePicker,
    
    IQActionSheetPickerStyleDateTimePicker,
    
    IQActionSheetPickerStyleTimePicker,
};

@class IQActionSheetPickerView;

/*!
 ActionSheetPickerView delegate.
 */
@protocol IQActionSheetPickerViewDelegate <NSObject>

@optional
- (void)actionSheetPickerView:(nonnull IQActionSheetPickerView *)pickerView didSelectTitles:(nonnull NSArray<NSString*>*)titles;
- (void)actionSheetPickerView:(nonnull IQActionSheetPickerView *)pickerView didSelectDate:(nonnull NSDate*)date;
- (void)actionSheetPickerView:(nonnull IQActionSheetPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)actionSheetPickerViewDidCancel:(nonnull IQActionSheetPickerView *)pickerView;
- (void)actionSheetPickerViewWillCancel:(nonnull IQActionSheetPickerView *)pickerView;
@end

/*!
 ActionSheet style UIPickerView
 */
@interface IQActionSheetPickerView : UIControl

/*!
 Initialization method with a title for toolbar and a callback delegate
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title delegate:(nullable id<IQActionSheetPickerViewDelegate>)delegate;

/*!
 delegate(weak reference) object to inform about the selected values in pickerView. Delegate method will be called on Done click.
 */
@property(nullable, nonatomic, weak) id<IQActionSheetPickerViewDelegate> delegate;

/*!
 actionSheetPickerStyle to show in picker. Default is IQActionSheetPickerStyleTextPicker.
 */
@property(nonatomic, assign) IQActionSheetPickerStyle actionSheetPickerStyle;   //

/*!
 Color for toolBar
 */
@property(nullable, nonatomic, readonly) IQActionSheetToolbar *actionToolbar;

///----------------------
/// @name Show / Hide
///----------------------


/*!
 Show picker view with slide up animation.
 */
-(void)show;

/*!
 Show picker view with slide up animation, completion block will be called on animation completion.
 */
-(void)showWithCompletion:(nullable void (^)(void))completion;

/*!
 Dismiss picker view with slide down animation.
 */
-(void)dismiss;

/*!
 Dismiss picker view with slide down animation, completion block will be called on animation completion.
 */
-(void)dismissWithCompletion:(nullable void (^)(void))completion;

/*!
 Disable dismiss action sheet when touching blank area at the top.
 */
@property(nonatomic, assign) BOOL disableDismissOnTouchOutside;


///-----------------------------------------
/// @name IQActionSheetPickerStyleTextPicker
///-----------------------------------------

/*!
 selected titles for each component. (Not Animated)
 */
@property(nullable, nonatomic, strong) NSArray<NSString*> *selectedTitles;

/*!
 set selected titles for each component.
 */
-(void)setSelectedTitles:(nonnull NSArray<NSString*> *)selectedTitles animated:(BOOL)animated;

/*!
 Titles to show for component. For example. @[ @[ @"1", @"2", @"3", ], @[ @"11", @"12", @"13", ], @[ @"21", @"22", @"23", ]].
 */
@property(nullable, nonatomic, strong) NSArray<NSArray<NSString*> *> *titlesForComponents;

/*!
 Width to adopt for each component. If you don't want to specify a row width then use @(0) to calculate row width automatically.
 */
@property(nullable, nonatomic, strong) NSArray<NSNumber*> *widthsForComponents;

/*!
 Font for the UIPickerView components
 */
@property(nullable, nonatomic, strong) UIFont *pickerComponentsFont UI_APPEARANCE_SELECTOR;
/*!
 Background color for the `UIPickerView`
 */
@property(nullable, nonatomic, strong) UIColor *pickerViewBackgroundColor UI_APPEARANCE_SELECTOR;
/*!
 *  Color for the UIPickerView
 */
@property(nullable, nonatomic, strong) UIColor *pickerComponentsColor UI_APPEARANCE_SELECTOR;

/*!
 Select the provided index row for each component. Ignore if actionSheetPickerStyle is IQActionSheetPickerStyleDatePicker.
 */
-(void)selectIndexes:(nonnull NSArray<NSNumber*> *)indexes animated:(BOOL)animated;

/*!
 If YES then it will force to scroll third picker component to pick equal or larger row then the first.
 */
@property(nonatomic, assign) BOOL isRangePickerView;

/*!
 Reload a component in pickerView.
 */
-(void)reloadComponent:(NSInteger)component;

/*!
 Reload all components in pickerView.
 */
-(void)reloadAllComponents;


///-------------------------------------------------------------------------------------------------------------------
/// @name IQActionSheetPickerStyleDatePicker/IQActionSheetPickerStyleDateTimePicker/IQActionSheetPickerStyleTimePicker
///-------------------------------------------------------------------------------------------------------------------

/*!
 selected date. Can also be use as setter method (not animated).
 */
@property(nullable, nonatomic, assign) NSDate *date; //get/set date.

/*!
 set selected date.
 */
-(void)setDate:(nonnull NSDate *)date animated:(BOOL)animated;

/*!
 Minimum selectable date in UIDatePicker. Default is nil.
 */
@property (nullable, nonatomic, retain) NSDate *minimumDate;

/*!
 Maximum selectable date in UIDatePicker. Default is nil.
 */
@property (nullable, nonatomic, retain) NSDate *maximumDate;

@end

