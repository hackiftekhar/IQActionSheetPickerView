//
// IQActionSheetViewController.m
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

@interface IQActionSheetViewController ()<UIApplicationDelegate, UIGestureRecognizerDelegate>

@end

@implementation IQActionSheetViewController 

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        //Code to handle the gesture
        [self dismissWithCompletion:nil];
    }
}

// MAKR: <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if (CGRectContainsPoint([self.pickerView bounds], [touch locationInView:self.pickerView]))
      return NO;
  
    return YES;
}


-(void)showPickerView:(IQActionSheetPickerView*)pickerView completion:(void (^)(void))completion
{
    _pickerView = pickerView;
    
    //  Getting topMost ViewController
    UIViewController *topController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while ([topController presentedViewController])	topController = [topController presentedViewController];
    
    [topController.view endEditing:YES];
    
    //Sending pickerView to bottom of the View.
    __block CGRect pickerViewFrame = pickerView.frame;
    {
        pickerViewFrame.origin.y = self.view.bounds.size.height;
        pickerView.frame = pickerViewFrame;
        [self.view addSubview:pickerView];
    }
    
    //Adding self.view to topMostController.view and adding self as childViewController to topMostController
    {
        self.view.frame = CGRectMake(0, 0, topController.view.bounds.size.width, topController.view.bounds.size.height);
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [topController addChildViewController: self];
        [topController.view addSubview: self.view];
    }

    //Sliding up the pickerView with animation
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|7<<16 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        pickerViewFrame.origin.y = self.view.bounds.size.height-pickerViewFrame.size.height;
        pickerView.frame = pickerViewFrame;

    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

-(void)dismissWithCompletion:(void (^)(void))completion
{
    //Sliding down the pickerView with animation.
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|7<<16 animations:^{
        
        self.view.backgroundColor = [UIColor clearColor];
        CGRect pickerViewFrame = _pickerView.frame;
        pickerViewFrame.origin.y = self.view.bounds.size.height;
        _pickerView.frame = pickerViewFrame;
        
    } completion:^(BOOL finished) {

        //Removing pickerView from self.view
        [_pickerView removeFromSuperview];
        
        //Removing self.view from topMostController.view and removing self as childViewController from topMostController
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];

        if (completion) completion();
    }];
}

@end
