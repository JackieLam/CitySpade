//
//  UIBarButtonItem+ProjectButton.h
//  GoGoPiao
//
//  Created by Cho-Yeung Lam on 20/9/13.
//  Copyright (c) 2013 Cho-Yeung Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ProjectButton)

+ (NSArray *)createEdgeButtonWithImage:(UIImage *)anImage WithTarget:(id)target action:(SEL)action;
+ (NSArray *)createEdgeButtonWithText:(NSString *)aString WithTarget:(id)target action:(SEL)action;
+(UIBarButtonItem *)createButtonWithText:(NSString *)aString WithTarget:(id)target action:(SEL)action;

@end
