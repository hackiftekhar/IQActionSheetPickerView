//
// IQActionSheetToolbar.m
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
#import "IQActionSheetTitleBarButtonItem.h"

@implementation IQActionSheetToolbar

-(void)initialize
{
    [self sizeToFit];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;// | UIViewAutoresizingFlexibleHeight;
    self.translucent = YES;
    [self setTintColor:[UIColor blackColor]];
    
    //  Create a fake button to maintain flexibleSpace between cancelButton and titleLabel.(Otherwise the titleLabel will lean to the left）
    UIBarButtonItem *nilButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //  Create a cancel button to show on keyboard to resign it. Adding a selector to resign it.
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
    
    //  Create a title button to show on toolBar for the title you need.
    self.titleButton =[[IQActionSheetTitleBarButtonItem alloc] initWithTitle:nil];
    
    //  Create a done button to show on keyboard to resign it. Adding a selector to resign it.
    self.doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    
    //  Adding button to toolBar.
    [self setItems:@[self.cancelButton,nilButton,self.titleButton,nilButton,self.doneButton]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGSize sizeThatFit = [super sizeThatFits:size];
    
    sizeThatFit.height = 44;
    
    return sizeThatFit;
}

-(void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    
    for (UIBarButtonItem *item in self.items)
    {
        [item setTintColor:tintColor];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    static Class IQUIToolbarTextButtonClass;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IQUIToolbarTextButtonClass = NSClassFromString(@"UIToolbarTextButton");
    });
    
    NSArray *subviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        
        CGFloat x1 = CGRectGetMinX(view1.frame);
        CGFloat y1 = CGRectGetMinY(view1.frame);
        CGFloat x2 = CGRectGetMinX(view2.frame);
        CGFloat y2 = CGRectGetMinY(view2.frame);
        
        if (x1 < x2)  return NSOrderedAscending;
        
        else if (x1 > x2) return NSOrderedDescending;
        
        //Else both y are same so checking for x positions
        else if (y1 < y2)  return NSOrderedAscending;
        
        else if (y1 > y2) return NSOrderedDescending;
        
        else    return NSOrderedSame;
    }];
    
    UIView *leftBarButtonView = nil;
    UIView *titleBarButtonView = nil;
    UIView *rightBarButtonView = nil;

    for (UIView *barButtonItemView in subviews)
    {
        if (titleBarButtonView != nil && [barButtonItemView isKindOfClass:IQUIToolbarTextButtonClass])
        {
            rightBarButtonView = barButtonItemView;
        }
        else if (titleBarButtonView == nil && [barButtonItemView isMemberOfClass:[UIView class]])
        {
            titleBarButtonView = barButtonItemView;
        }
        else if (leftBarButtonView == nil && [barButtonItemView isKindOfClass:IQUIToolbarTextButtonClass])
        {
            leftBarButtonView = barButtonItemView;
        }
    }
    
    /*Left Bar Button Item*/
    CGRect rect = leftBarButtonView.frame;
    rect.origin.x = 8;
    leftBarButtonView.frame = rect;
    
    /*Right Bar Button Item*/
    rect = rightBarButtonView.frame;
    rect.origin.x = self.frame.size.width-rect.size.width-8;
    rightBarButtonView.frame = rect;
    
    /*Title Bar Button Item*/
    CGFloat x = CGRectGetMaxX(leftBarButtonView.frame) + 16;
    
    CGFloat width = (CGRectGetMinX(rightBarButtonView.frame)-16)-x;
    
    rect = titleBarButtonView.frame;
    rect.origin.x = x;
    rect.origin.y = 0;
    rect.size.width = width;
    rect.size.height = self.frame.size.height;
    titleBarButtonView.frame = rect;
}

@end
