//
//  IQActionSheetViewController.m
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


#import "IQActionSheetViewController.h"
#import "IQActionSheetPickerView.h"

@interface IQActionSheetViewController ()<UIApplicationDelegate>

@end

@implementation IQActionSheetViewController
{
    IQActionSheetPickerView *_contentPickerView;
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)showPickerView:(IQActionSheetPickerView*)pickerView inViewController:(UIViewController*)controller
{
    _contentPickerView = pickerView;
    
    __block CGRect pickerViewFrame = pickerView.frame;
    pickerViewFrame.origin.y = self.view.bounds.size.height;
    pickerView.frame = pickerViewFrame;
    [self.view addSubview:pickerView];
    
    {
        self.view.frame = CGRectMake(0, 0, controller.view.bounds.size.width, controller.view.bounds.size.height);
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [controller addChildViewController: self];
        [controller.view addSubview: self.view];
    }

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|7<<16 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        pickerViewFrame.origin.y = self.view.bounds.size.height-pickerViewFrame.size.height;
        pickerView.frame = pickerViewFrame;

    } completion:NULL];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|7<<16 animations:^{
        
        self.view.backgroundColor = [UIColor clearColor];
        CGRect pickerViewFrame = _contentPickerView.frame;
        pickerViewFrame.origin.y = self.view.bounds.size.height;
        _contentPickerView.frame = pickerViewFrame;
        
    } completion:^(BOOL finished) {

        [_contentPickerView removeFromSuperview];
        
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

@end
