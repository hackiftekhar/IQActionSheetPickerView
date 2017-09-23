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

#import <UIKit/UIAccessibility.h>

NSString * const kIQActionSheetAttributesForNormalStateKey = @"kIQActionSheetAttributesForNormalStateKey";
/// Identifies an attributed string of the toolbar title for highlighted state.
NSString * const kIQActionSheetAttributesForHighlightedStateKey = @"kIQActionSheetAttributesForHighlightedStateKey";


@implementation IQActionSheetToolbar

+(void)initialize
{
    [super initialize];
    
    //Tint Color
    [[self appearance] setTintColor:nil];
    
    [[self appearance] setBarTintColor:nil];
    
    //Background image
    [[self appearance] setBackgroundImage:nil forToolbarPosition:UIBarPositionAny           barMetrics:UIBarMetricsDefault];
    [[self appearance] setBackgroundImage:nil forToolbarPosition:UIBarPositionBottom        barMetrics:UIBarMetricsDefault];
    [[self appearance] setBackgroundImage:nil forToolbarPosition:UIBarPositionTop           barMetrics:UIBarMetricsDefault];
    [[self appearance] setBackgroundImage:nil forToolbarPosition:UIBarPositionTopAttached   barMetrics:UIBarMetricsDefault];
    
    //Shadow image
    [[self appearance] setShadowImage:nil forToolbarPosition:UIBarPositionAny];
    [[self appearance] setShadowImage:nil forToolbarPosition:UIBarPositionBottom];
    [[self appearance] setShadowImage:nil forToolbarPosition:UIBarPositionTop];
    [[self appearance] setShadowImage:nil forToolbarPosition:UIBarPositionTopAttached];
    
    //Background color
    [[self appearance] setBackgroundColor:nil];
}

-(void)initialize
{
    [self sizeToFit];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;// | UIViewAutoresizingFlexibleHeight;
    self.translucent = YES;
    [self setTintColor:[UIColor blackColor]];
    
    //  Create a fake button to maintain flexibleSpace between cancelButton and titleLabel.(Otherwise the titleLabel will lean to the left）
    
    //  Create a cancel button to show on keyboard to resign it. Adding a selector to resign it.
    _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
    
    //  Create a title button to show on toolBar for the title you need.
    _titleButton =[[IQActionSheetTitleBarButtonItem alloc] initWithTitle:nil];

    //  Create a done button to show on keyboard to resign it. Adding a selector to resign it.
    _doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    
    [self refreshToolbarItems];
}

-(void)refreshToolbarItems
{
    UIBarButtonItem *nilButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    NSMutableArray<UIBarButtonItem*> *items = [[NSMutableArray alloc] init];
    
    if (self.cancelButton)
    {
        [items addObject:self.cancelButton];
    }

    if (self.titleButton)
    {
        [items addObject:nilButton];
        [items addObject:self.titleButton];
    }
    
    if (self.doneButton)
    {
        [items addObject:nilButton];
        [items addObject:self.doneButton];
    }
    
    if ([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion < 11)
    {
        _titleButton.customView.frame = CGRectZero;
    }
    
    //  Adding button to toolBar.
    [self setItems:items];
}

-(void)setCancelButton:(UIBarButtonItem *)cancelButton
{
    _cancelButton = cancelButton;
    _cancelButton.accessibilityLabel = @"Action Sheet Cancel Button";

    [self refreshToolbarItems];
}

-(void)setTitleButton:(IQActionSheetTitleBarButtonItem *)titleButton
{
    _titleButton = titleButton;
    _titleButton.accessibilityLabel = @"Action Sheet Title Button";

    [self refreshToolbarItems];
}

-(void)setDoneButton:(UIBarButtonItem *)doneButton
{
    _doneButton = doneButton;
    _doneButton.accessibilityLabel = @"Action Sheet Done Button";

    [self refreshToolbarItems];
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

-(CGSize)intrinsicContentSize
{
    CGSize intrinsicContentSize = [super intrinsicContentSize];
    
    intrinsicContentSize.height = 44;
    
    return intrinsicContentSize;
}
    
-(void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    
    for (UIBarButtonItem *item in self.items)
    {
        [item setTintColor:tintColor];
    }
}

// Allows you to perform layout before the drawing cycle happens. -layoutIfNeeded forces layout early
- (void)setNeedsLayout
{
    [super setNeedsLayout];

    if ([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion < 11)
    {
        self.titleButton.customView.frame = CGRectMake(0, CGRectGetMidY(self.bounds), 0, self.frame.size.height);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion < 11)
    {
        CGRect leftRect = CGRectNull;
        CGRect rightRect = CGRectNull;
        
        BOOL isTitleBarButtonFound = NO;
        
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
        
        for (UIView *barButtonItemView in subviews)
        {
            if (isTitleBarButtonFound == YES)
            {
                rightRect = barButtonItemView.frame;
                break;
            }
            else if ([barButtonItemView isMemberOfClass:[UIView class]])
            {
                isTitleBarButtonFound = YES;
            }
            //If it's UIToolbarButton or UIToolbarTextButton (which actually UIBarButtonItem)
            else if ([barButtonItemView isKindOfClass:[UIControl class]])
            {
                leftRect = barButtonItemView.frame;
            }
        }
        
        CGFloat minX = 0;
        
        if (CGRectIsNull(leftRect) == false)
        {
            minX = CGRectGetMaxX(leftRect) + 20;
        }
        else
        {
            minX = 20;
        }
        
        CGFloat maxX = 0;
        
        if (CGRectIsNull(rightRect) == false)
        {
            maxX = CGRectGetMinX(rightRect) - 20;
        }
        else
        {
            maxX = CGRectGetWidth(self.frame) - 20;
        }
        
        CGFloat width = maxX - minX;
        
        self.titleButton.customView.frame = CGRectMake(minX, 0, width, self.frame.size.height);
    }
}

/**
 *  Set Cancel Button Title Attributes
 *
 *  @param cancelButtonAttributes Cancel Button Title Attributes
 */
-(void)setCancelButtonAttributes:(NSDictionary *)cancelButtonAttributes{
    id attributesForCancelButtonNormalState = [cancelButtonAttributes objectForKey:kIQActionSheetAttributesForNormalStateKey];
    if (attributesForCancelButtonNormalState != nil && [attributesForCancelButtonNormalState isKindOfClass:[NSDictionary class]]) {
        [self.cancelButton setTitleTextAttributes:(NSDictionary *)attributesForCancelButtonNormalState forState:UIControlStateNormal];
    }
    
    id attributesForCancelButtonnHighlightedState = [cancelButtonAttributes objectForKey:  kIQActionSheetAttributesForHighlightedStateKey];
    if (attributesForCancelButtonnHighlightedState != nil && [attributesForCancelButtonnHighlightedState isKindOfClass:[NSDictionary class]]) {
        [self.cancelButton setTitleTextAttributes:(NSDictionary *)attributesForCancelButtonnHighlightedState forState:UIControlStateHighlighted];
    }
}

/**
 *  Set Done Button Title Attributes
 *
 *  @param doneButtonAttributes Done Button Title Attributes
 */
-(void)setDoneButtonAttributes:(NSDictionary *)doneButtonAttributes{
    id attributesForDoneButtonNormalState = [doneButtonAttributes objectForKey:kIQActionSheetAttributesForNormalStateKey];
    if (attributesForDoneButtonNormalState != nil && [attributesForDoneButtonNormalState isKindOfClass:[NSDictionary class]]) {
        [self.doneButton setTitleTextAttributes:(NSDictionary *)attributesForDoneButtonNormalState forState:UIControlStateNormal];
    }
    
    id attributesForDoneButtonnHighlightedState = [doneButtonAttributes objectForKey:  kIQActionSheetAttributesForHighlightedStateKey];
    if (attributesForDoneButtonnHighlightedState != nil && [attributesForDoneButtonnHighlightedState isKindOfClass:[NSDictionary class]]) {
        [self.doneButton setTitleTextAttributes:(NSDictionary *)attributesForDoneButtonnHighlightedState forState:UIControlStateHighlighted];
    }
}

@end
