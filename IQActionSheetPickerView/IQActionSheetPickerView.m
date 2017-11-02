//
// IQActionSheetPickerView.m
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

#import "IQActionSheetPickerView.h"
#import "IQActionSheetViewController.h"
#import "IQActionSheetToolbar.h"

#import <UIKit/UIPickerView.h>
#import <UIKit/UIDatePicker.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIScreen.h>
#import <UIKit/UILabel.h>

@interface IQActionSheetPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic, strong) IQActionSheetViewController *actionSheetController;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation IQActionSheetPickerView

@synthesize actionSheetPickerStyle  = _actionSheetPickerStyle;
@synthesize titlesForComponents     = _titlesForComponents;
@synthesize widthsForComponents     = _widthsForComponents;
@synthesize isRangePickerView       = _isRangePickerView;
@synthesize delegate                = _delegate;
@synthesize date                    = _date;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<IQActionSheetPickerViewDelegate>)delegate
{
    self = [super init];

    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        //UIToolbar
        {
            _actionToolbar = [[IQActionSheetToolbar alloc] init];
            [_actionToolbar sizeToFit];
            _actionToolbar.barStyle = UIBarStyleDefault;
            _actionToolbar.cancelButton.target = self;
            _actionToolbar.cancelButton.action = @selector(pickerCancelClicked:);
            _actionToolbar.doneButton.target = self;
            _actionToolbar.doneButton.action = @selector(pickerDoneClicked:);
            _actionToolbar.titleButton.title = title;
        }

        //UIPickerView
        {
            _pickerView = [[UIPickerView alloc] init];
            [_pickerView sizeToFit];
            _pickerView.backgroundColor = [UIColor whiteColor];
            [_pickerView setShowsSelectionIndicator:YES];
            [_pickerView setDelegate:self];
            [_pickerView setDataSource:self];
            [self addSubview:_pickerView];
        }
        
        //UIDatePicker
        {
            _datePicker = [[UIDatePicker alloc] init];
            [_datePicker sizeToFit];
            [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            [self addSubview:_datePicker];
        }
        
        NSDictionary *viewDict = NSDictionaryOfVariableBindings(_pickerView, _datePicker);
        _pickerView.translatesAutoresizingMaskIntoConstraints = NO;
        _datePicker.translatesAutoresizingMaskIntoConstraints = NO;

        NSArray<NSLayoutConstraint*>*horizontalPickerConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_pickerView]|" options:0 metrics:nil views:viewDict];
        NSArray<NSLayoutConstraint*>*verticalPickerConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_pickerView]-|" options:NSLayoutFormatAlignAllLeading|NSLayoutFormatAlignAllTrailing metrics:nil views:viewDict];

        NSArray<NSLayoutConstraint*>*horizontalDateConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_datePicker]|" options:0 metrics:nil views:viewDict];
        NSArray<NSLayoutConstraint*>*verticalDateConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_datePicker]-|" options:0 metrics:nil views:viewDict];

        [self addConstraints:horizontalPickerConstraints];
        [self addConstraints:verticalPickerConstraints];
        [self addConstraints:horizontalDateConstraints];
        [self addConstraints:verticalDateConstraints];

        //Initial settings
        {
            self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
            [self setActionSheetPickerStyle:IQActionSheetPickerStyleTextPicker];
        }
    }
    
    _delegate = delegate;
    
    return self;
}

-(void)setActionSheetPickerStyle:(IQActionSheetPickerStyle)actionSheetPickerStyle
{
    _actionSheetPickerStyle = actionSheetPickerStyle;
    
    switch (actionSheetPickerStyle) {
        case IQActionSheetPickerStyleTextPicker:
            [_pickerView setHidden:NO];
            [_datePicker setHidden:YES];
            break;
        case IQActionSheetPickerStyleDatePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            break;
        case IQActionSheetPickerStyleDateTimePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            break;
        case IQActionSheetPickerStyleTimePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeTime];
            break;
            
        default:
            break;
    }
}

/**
 *  Set Picker View Background Color
 *
 *  @param pickerViewBackgroundColor Picker view custom background color
 */
-(void)setPickerViewBackgroundColor:(UIColor *)pickerViewBackgroundColor{
  _pickerView.backgroundColor = pickerViewBackgroundColor;
}

#pragma mark - Done/Cancel

-(void)pickerCancelClicked:(UIBarButtonItem*)barButton
{
    if ([self.delegate respondsToSelector:@selector(actionSheetPickerViewWillCancel:)])
    {
        [self.delegate actionSheetPickerViewWillCancel:self];
    }
    
    [self dismissWithCompletion:^{
        
        if ([self.delegate respondsToSelector:@selector(actionSheetPickerViewDidCancel:)])
        {
            [self.delegate actionSheetPickerViewDidCancel:self];
        }
    }];
}

-(void)pickerDoneClicked:(UIBarButtonItem*)barButton
{
    switch (_actionSheetPickerStyle)
    {
        case IQActionSheetPickerStyleTextPicker:
        {
            NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];

            for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
            {
                NSInteger row = [_pickerView selectedRowInComponent:component];
                
                if (row!= -1)
                {
                    [selectedTitles addObject:_titlesForComponents[component][row]];
                }
                else
                {
                    [selectedTitles addObject:[NSNull null]];
                }
            }
            
            [self setSelectedTitles:selectedTitles];
            
            if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didSelectTitles:)])
            {
                [self.delegate actionSheetPickerView:self didSelectTitles:selectedTitles];
            }
            
        }
            break;
        case IQActionSheetPickerStyleDatePicker:
        case IQActionSheetPickerStyleDateTimePicker:
        case IQActionSheetPickerStyleTimePicker:
        {
            [self setDate:_datePicker.date];
            
            if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didSelectDate:)])
            {
                [self.delegate actionSheetPickerView:self didSelectDate:_datePicker.date];
            }
        }
            
        default:
            break;
    }
    
    [self dismiss];
}

#pragma mark - IQActionSheetPickerStyleDatePicker / IQActionSheetPickerStyleDateTimePicker / IQActionSheetPickerStyleTimePicker

-(void)dateChanged:(UIDatePicker*)datePicker
{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void) setDate:(NSDate *)date
{
    [self setDate:date animated:NO];
}

-(void)setDate:(NSDate *)date animated:(BOOL)animated
{
    _date = date;
    if (_date != nil)   [_datePicker setDate:_date animated:animated];
}

-(void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    
    _datePicker.minimumDate = minimumDate;
}

-(void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    
    _datePicker.maximumDate = maximumDate;
}

#pragma mark - IQActionSheetPickerStyleTextPicker

-(void)reloadComponent:(NSInteger)component
{
    [_pickerView reloadComponent:component];
}

-(void)reloadAllComponents
{
    [_pickerView reloadAllComponents];
}

-(void)setSelectedTitles:(NSArray *)selectedTitles
{
    [self setSelectedTitles:selectedTitles animated:NO];
}

-(NSArray *)selectedTitles
{
    if (_actionSheetPickerStyle == IQActionSheetPickerStyleTextPicker)
    {
        NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
        
        NSUInteger totalComponent = _pickerView.numberOfComponents;
        
        for (NSInteger component = 0; component<totalComponent; component++)
        {
            NSInteger selectedRow = [_pickerView selectedRowInComponent:component];
            
            if (selectedRow == -1)
            {
                [selectedTitles addObject:[NSNull null]];
            }
            else
            {
                NSArray *items = _titlesForComponents[component];
                
                if ([items count] > selectedRow)
                {
                    id selectTitle = items[selectedRow];
                    [selectedTitles addObject:selectTitle];
                }
                else
                {
                    [selectedTitles addObject:[NSNull null]];
                }
            }
        }
        
        return selectedTitles;
    }
    else
    {
        return nil;
    }
}

-(void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated
{
    if (_actionSheetPickerStyle == IQActionSheetPickerStyleTextPicker)
    {
        NSUInteger totalComponent = MIN(selectedTitles.count, _pickerView.numberOfComponents);
        
        for (NSInteger component = 0; component<totalComponent; component++)
        {
            NSArray *items = _titlesForComponents[component];
            id selectTitle = selectedTitles[component];
            
            if ([items containsObject:selectTitle])
            {
                NSUInteger rowIndex = [items indexOfObject:selectTitle];
                [_pickerView selectRow:rowIndex inComponent:component animated:animated];
            }
        }
    }
}

-(void)selectIndexes:(NSArray *)indexes animated:(BOOL)animated
{
    if (_actionSheetPickerStyle == IQActionSheetPickerStyleTextPicker)
    {
        NSUInteger totalComponent = MIN(indexes.count, _pickerView.numberOfComponents);
        
        for (NSInteger component = 0; component<totalComponent; component++)
        {
            NSArray *items = _titlesForComponents[component];
            NSUInteger selectIndex = [indexes[component] unsignedIntegerValue];
            
            if (selectIndex < items.count)
            {
                [_pickerView selectRow:selectIndex inComponent:component animated:animated];
            }
        }
    }
}

#pragma mark - UIPickerView delegate/dataSource

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    //If having widths
    if (_widthsForComponents)
    {
        CGFloat width = [_widthsForComponents[component] floatValue];
        
        //If width is 0, then calculating it's size.
        if (width <= 0)
            return ((pickerView.bounds.size.width-20)-2*(_titlesForComponents.count-1))/_titlesForComponents.count;
        //Else returning it's width.
        else
            return width;
    }
    //Else calculating it's size.
    else
    {
        return ((pickerView.bounds.size.width-20)-2*(_titlesForComponents.count-1))/_titlesForComponents.count;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_titlesForComponents count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_titlesForComponents[component] count];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelText = [[UILabel alloc] init];
    if(self.pickerComponentsColor != nil) {
      labelText.textColor = self.pickerComponentsColor;
    }
    if(self.pickerComponentsFont == nil){
        labelText.font = [UIFont boldSystemFontOfSize:20.0];
    }else{
        labelText.font = self.pickerComponentsFont;
    }
    labelText.backgroundColor = [UIColor clearColor];
    [labelText setTextAlignment:NSTextAlignmentCenter];
    [labelText setText:_titlesForComponents[component][row]];
    return labelText;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isRangePickerView && pickerView.numberOfComponents == 3)
    {
        if (component == 0)
        {
            [pickerView selectRow:MAX([pickerView selectedRowInComponent:2], row) inComponent:2 animated:YES];
        }
        else if (component == 2)
        {
            [pickerView selectRow:MIN([pickerView selectedRowInComponent:0], row) inComponent:0 animated:YES];
        }
    }

    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didChangeRow:inComponent:)]) {
        [self.delegate actionSheetPickerView:self didChangeRow:row inComponent:component];
    }
}

#pragma mark - show/Hide

-(void)dismiss
{
    [_actionSheetController dismissWithCompletion:nil];
    _actionSheetController = nil;
}

-(void)dismissWithCompletion:(void (^)(void))completion
{
    [_actionSheetController dismissWithCompletion:completion];
    _actionSheetController = nil;
}

-(void)setDisableDismissOnTouchOutside:(BOOL)disableDismissOnTouchOutside
{
    _disableDismissOnTouchOutside = disableDismissOnTouchOutside;
    _actionSheetController.disableDismissOnTouchOutside = _disableDismissOnTouchOutside;
}

-(void)show
{
    [self showWithCompletion:nil];
}

-(void)showWithCompletion:(void (^)(void))completion
{
    [_pickerView reloadAllComponents];
    
    if (_actionSheetController == nil)
    {
        _actionSheetController = [[IQActionSheetViewController alloc] init];
        _actionSheetController.disableDismissOnTouchOutside = self.disableDismissOnTouchOutside;
        [_actionSheetController showPickerView:self completion:completion];
        
    }
}


@end

