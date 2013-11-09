//
//  ViewController.h
//  ActionSheetPickerView
//
//  Created by hp on 09/11/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UIButton *buttonSingle;
    IBOutlet UIButton *buttonDouble;
    IBOutlet UIButton *buttonTriple;
    IBOutlet UIButton *buttonTripleSize;
    IBOutlet UIButton *buttonRange;
    IBOutlet UIButton *buttonDate;

}

- (IBAction)onePickerViewClicked:(UIButton *)sender;
- (IBAction)twoPickerViewClicked:(UIButton *)sender;
- (IBAction)threePickerViewClicked:(UIButton *)sender;
- (IBAction)threePickerViewWithWidths:(UIButton *)sender;
- (IBAction)datePickerViewClicked:(UIButton *)sender;
- (IBAction)rangeSelectClicked:(UIButton *)sender;

@end
