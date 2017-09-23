//
//  ViewController.m
//  ActionSheetPickerView
//  Copyright (c) 2013 Iftekhar. All rights reserved.


#import "ViewController.h"
#import "IQActionSheetPickerView.h"


@interface ViewController ()<IQActionSheetPickerViewDelegate>

@end

@implementation ViewController

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    switch (pickerView.tag)
    {
        case 1: [buttonSingle setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 2: [buttonDouble setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 3: [buttonTriple setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 4: [buttonRange setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 5: [buttonTripleSize setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
            
        default:
            break;
    }
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    switch (pickerView.tag)
    {
        case 6:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterNoStyle];
            [buttonDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        }
            break;
        case 7:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [buttonDateTime setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        }
            break;
        case 8:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterNoStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [buttonTime setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)onePickerViewClicked:(UIButton *)sender
{
    IQActionSheetPickerView *pickerView = [[IQActionSheetPickerView alloc] initWithTitle:@"Reminder" delegate:self];

    pickerView.actionSheetPickerStyle = IQActionSheetPickerStyleTextPicker;
    pickerView.titlesForComponents = @[@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"],@[@"AM",@"PM"]];
//    pickerView.actionToolbar.tintColor = [UIColor blueAppColor];
    
    pickerView.selectedTitles = @[@"5", @"PM"];
    [pickerView show];

    
//     IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Single Picker" delegate:self];
//    picker.actionToolbar.titleButton.titleFont = [UIFont systemFontOfSize:12];
//    picker.actionToolbar.titleButton.titleColor = [UIColor redColor];
//    [picker setTag:1];
//    [picker setTitlesForComponents:@[@[@"First", @"Second", @"Third", @"Four", @"Five"]]];
//    [picker show];
}

- (IBAction)twoPickerViewClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Double Picker" delegate:self];
    [picker setTag:2];
    [picker setTitlesForComponents:@[@[@"First 1", @"Second 1", @"Third 1", @"Four 1", @"Five 1"],
                                     @[@"First 2", @"Second 2", @"Third 2", @"Four 2", @"Five 2"]]];
    [picker show];
}

- (IBAction)threePickerViewClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Three Picker" delegate:self];
    [picker setTag:3];
    [picker setTitlesForComponents:@[@[@"First 1", @"Second 1", @"Third 1", @"Four 1", @"Five 1"],
                                     @[@"First 2", @"Second 2", @"Third 2", @"Four 2", @"Five 2"],
                                     @[@"First 3", @"Second 3", @"Third 3", @"Four 3", @"Five 3"]]];
    [picker show];
}

- (IBAction)rangeSelectClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Range Selector" delegate:self];
    [picker setTag:4];
    [picker setIsRangePickerView:YES];
    [picker setTitlesForComponents:@[@[@"100", @"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900"],
                                     @[@"To"],
                                     @[@"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900",@"1000"]]];
    [picker show];
}

- (IBAction)threePickerViewWithWidths:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Range Selector With Size and this is a pretty long title used to test title display in action sheet picker view" delegate:self];
    [picker setTag:5];
    [picker setIsRangePickerView:YES];
    [picker setTitlesForComponents:@[@[@"100", @"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900"],
                                     @[@"To"],
                                     @[@"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900",@"1000"]]];
    [picker setWidthsForComponents:@[@120.0f,
                                    @60.0f,
                                    @120.0f]];
    [picker show];
}

- (IBAction)datePickerViewClicked:(UIButton *)sender
{
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date Picker" delegate:self];
    [picker setTag:6];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}

- (IBAction)dateTimePickerViewClicked:(UIButton *)sender
{
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date/Time Picker" delegate:self];
    [picker setTag:7];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDateTimePicker];
    [picker show];
}

- (IBAction)timePickerViewClicked:(UIButton *)sender
{
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Time Picker" delegate:self];
    [picker setTag:8];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleTimePicker];
    [picker show];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
