//
//  IQActionSheetPickerView.h
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


#import <UIKit/UIKit.h>

#if !(__has_feature(objc_instancetype))
#define instancetype id
#endif

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
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray*)titles;
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate*)date;
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)actionSheetPickerViewDidCancel:(IQActionSheetPickerView *)pickerView;
- (void)actionSheetPickerViewWillCancel:(IQActionSheetPickerView *)pickerView;
@end

/*!
 ActionSheet style UIPickerView
 */
@interface IQActionSheetPickerView : UIControl

/*!
 Initialization method with a title for toolbar and a callback delegate
 */
- (instancetype)initWithTitle:(NSString *)title delegate:(id<IQActionSheetPickerViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/*!
 delegate(weak reference) object to inform about the selected values in pickerView. Delegate method will be called on Done click.
 */
@property(nonatomic, weak) id<IQActionSheetPickerViewDelegate> delegate;

/*!
 actionSheetPickerStyle to show in picker. Default is IQActionSheetPickerStyleTextPicker.
 */
@property(nonatomic, assign) IQActionSheetPickerStyle actionSheetPickerStyle;   //

/*!
 Color for toolBar
 */
@property(nonatomic, strong) UIColor *barColor;
/*!
 Color for buttons
 */
@property(nonatomic, strong) UIColor *buttonColor;

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
-(void)showWithCompletion:(void (^)(void))completion;

/*!
 Dismiss picker view with slide down animation.
 */
-(void)dismiss;

/*!
 Dismiss picker view with slide down animation, completion block will be called on animation completion.
 */
-(void)dismissWithCompletion:(void (^)(void))completion;


///-----------------------------------------
/// @name IQActionSheetPickerStyleTextPicker
///-----------------------------------------

/*!
 selected titles for each component. Please use [ NSArray of NSString ] format. (Not Animated)
 */
@property(nonatomic, strong) NSArray *selectedTitles;

/*!
 set selected titles for each component. Please use [ NSArray of NSString ] format.
 */
-(void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated;

/*!
 Titles to show for component. Please use [ NSArray(numberOfComponents) of [ NSArray of NSString ](RowValueForEachComponent)] format, even there is single row to show, For example.
                @[ @[ @"1", @"2", @"3", ], @[ @"11", @"12", @"13", ], @[ @"21", @"22", @"23", ]].
 */
@property(nonatomic, strong) NSArray *titlesForComponenets;

/*!
 Width to adopt for each component. Please use [NSArray of NSNumber/NSNull] format. If you don't want to specify a row width then use NSNull to calculate row width automatically.
 */
@property(nonatomic, strong) NSArray *widthsForComponents;

/*!
 Select the provided index row for each component. Please use [ NSArray of NSNumber ] format for indexes. Ignore if actionSheetPickerStyle is IQActionSheetPickerStyleDatePicker.
 */
-(void)selectIndexes:(NSArray *)indexes animated:(BOOL)animated;

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
@property(nonatomic, assign) NSDate *date; //get/set date.

/*!
 set selected date.
 */
-(void)setDate:(NSDate *)date animated:(BOOL)animated;

/*!
 Minimum selectable date in UIDatePicker. Default is nil.
 */
@property (nonatomic, retain) NSDate *minimumDate;

/*!
 Maximum selectable date in UIDatePicker. Default is nil.
 */
@property (nonatomic, retain) NSDate *maximumDate;

@end

