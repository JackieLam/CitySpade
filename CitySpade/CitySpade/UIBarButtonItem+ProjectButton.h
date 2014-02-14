//
//  UIBarButtonItem+ProjectButton.h
//  GoGoPiao
//
//  Created by Cho-Yeung Lam on 20/9/13.
//  Copyright (c) 2013 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ProjectButton)

+(UIBarButtonItem *)createButtonWithImage:(UIImage *)anImage WithTarget:(id)target action:(SEL)action;
+ (NSArray *)createEdgeButtonWithImage:(UIImage *)anImage WithTarget:(id)target action:(SEL)action;

@end
