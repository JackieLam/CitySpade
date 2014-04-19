//
//  UIBarButtonItem+ProjectButton.m
//  GoGoPiao
//
//  Created by Cho-Yeung Lam on 20/9/13.
//  Copyright (c) 2013 Cho-Yeung Lam. All rights reserved.
//

#import "UIBarButtonItem+ProjectButton.h"

@implementation UIBarButtonItem (ProjectButton)

#pragma mark -
#pragma mark - UIImage

+(UIBarButtonItem *)createButtonWithImage:(UIImage *)anImage WithTarget:(id)target action:(SEL)action
{
    UIImage *buttonImage = anImage;
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];//or you can set bgImage
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return customBarItem;
}

+ (NSArray *)createEdgeButtonWithImage:(UIImage *)anImage WithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-5];
    return [NSArray arrayWithObjects:negativeSpacer, [UIBarButtonItem createButtonWithImage:anImage WithTarget:target action:action], nil];
}

#pragma mark - 
#pragma mark - NSString

+(UIBarButtonItem *)createButtonWithText:(NSString *)aString WithTarget:(id)target action:(SEL)action
{
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 30, 50, 30);
    button.contentEdgeInsets = UIEdgeInsetsMake(5.0, 0, 0, 0);
    button.backgroundColor = [UIColor clearColor];
    
    
    [button setTitle:aString forState:UIControlStateNormal];
    [button setTitle:aString forState:UIControlStateHighlighted];
    [button setTitle:aString forState:UIControlStateSelected];
    
    button.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0f];
    UIColor *buttonTextColor = [UIColor colorWithRed:151.0/255.0 green:149.0/255.0 blue:150.0/255.0 alpha:1.0f];
    [button setTitleColor:buttonTextColor forState:UIControlStateNormal];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return customBarItem;
}

+ (NSArray *)createEdgeButtonWithText:(NSString *)aString WithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-5];
    return [NSArray arrayWithObjects:negativeSpacer, [UIBarButtonItem createButtonWithText:aString WithTarget:target action:action], nil];
}

@end
