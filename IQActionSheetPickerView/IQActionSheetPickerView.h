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


#import <Foundation/Foundation.h>

typedef enum IQActionSheetPickerStyle
{
    IQActionSheetPickerStyleTextPicker,
    IQActionSheetPickerStyleDatePicker
}IQActionSheetPickerStyle;

@class IQActionSheetPickerView;

@protocol IQActionSheetPickerViewDelegate <NSObject>

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray*)titles;

@optional
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component;
@end

@interface IQActionSheetPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
{
@private
    UIPickerView    *_pickerView;
    UIDatePicker    *_datePicker;
    UIToolbar       *_actionToolbar;
}

- (id)initWithTitle:(NSString *)title delegate:(id<IQActionSheetPickerViewDelegate>)delegate;

-(void)showInViewController:(UIViewController*)controller;
-(void)dismiss;

@property(nonatomic, weak) id<IQActionSheetPickerViewDelegate> delegate; // weak reference
@property(nonatomic, assign) IQActionSheetPickerStyle actionSheetPickerStyle;   //Default is IQActionSheetPickerStyleTextPicker;

/*for IQActionSheetPickerStyleTextPicker*/
@property(nonatomic, assign) BOOL isRangePickerView;
@property(nonatomic, strong) NSArray *titlesForComponenets;
@property(nonatomic, strong) NSArray *widthsForComponents;
@property(nonatomic, strong) NSArray *selectedTitles;
-(void)selectIndexes:(NSArray *)indexes animated:(BOOL)animated;
-(void)reloadComponent:(NSInteger)component;
-(void)reloadAllComponents;
/*for IQActionSheetPickerStyleDatePicker*/
@property(nonatomic, assign) NSDateFormatterStyle dateStyle;    //returning date string style.
@property(nonatomic, assign) NSDate *date; //get/set date.
-(void)setDate:(NSDate *)date animated:(BOOL)animated;

/*for Both picker styles*/
-(void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated;

@end