//
//  ViewController.m
//  ActionSheetPickerView
//  Copyright (c) 2013 Iftekhar. All rights reserved.

#import "ViewController.h"
#import "IQActionSheetPickerView.h"


@interface ViewController ()<IQActionSheetPickerView>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    switch (pickerView.tag)
    {
        case 1: [buttonSingle setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 2: [buttonDouble setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 3: [buttonTriple setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 4: [buttonRange setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 5: [buttonTripleSize setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 6: [buttonDate setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
            
        default:
            break;
    }
}

- (IBAction)onePickerViewClicked:(UIButton *)sender {
     IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Single Picker" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:1];
    [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                     [NSArray arrayWithObjects:@"First", @"Second", @"Third", @"Four", @"Five", nil],
                                     nil]];
    [picker showInView:self.view];
}

- (IBAction)twoPickerViewClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Double Picker" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:2];
    [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                     [NSArray arrayWithObjects:@"First 1", @"Second 1", @"Third 1", @"Four 1", @"Five 1", nil],
                                     [NSArray arrayWithObjects:@"First 2", @"Second 2", @"Third 2", @"Four 2", @"Five 2", nil],
                                     nil]];
    [picker showInView:self.view];
}

- (IBAction)threePickerViewClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Three Picker" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:3];
    [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                     [NSArray arrayWithObjects:@"First 1", @"Second 1", @"Third 1", @"Four 1", @"Five 1", nil],
                                     [NSArray arrayWithObjects:@"First 2", @"Second 2", @"Third 2", @"Four 2", @"Five 2", nil],
                                     [NSArray arrayWithObjects:@"First 3", @"Second 3", @"Third 3", @"Four 3", @"Five 3", nil],
                                     nil]];
    [picker showInView:self.view];
}

- (IBAction)rangeSelectClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Range Selector" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:4];
    [picker setIsRangePickerView:YES];
    [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                     [NSArray arrayWithObjects:@"100", @"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900", nil],
                                     [NSArray arrayWithObjects:@"To", nil],
                                     [NSArray arrayWithObjects:@"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900",@"1000", nil],
                                     nil]];
    [picker showInView:self.view];
}

- (IBAction)threePickerViewWithWidths:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Range Selector With Size" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:5];
    [picker setIsRangePickerView:YES];
    [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                     [NSArray arrayWithObjects:@"100", @"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900", nil],
                                     [NSArray arrayWithObjects:@"To", nil],
                                     [NSArray arrayWithObjects:@"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900",@"1000", nil],
                                     nil]];
    [picker setWidthsForComponents:[NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:120],
                                    [NSNumber numberWithFloat:60],
                                    [NSNumber numberWithFloat:120],
                                    nil]];
    [picker showInView:self.view];
}

- (IBAction)datePickerViewClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date Picker" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:6];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker showInView:self.view];
}
@end
