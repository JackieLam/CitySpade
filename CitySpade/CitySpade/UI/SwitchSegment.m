//
//  SwitchSegment.m
//  CitySpade
//
//  Created by Alaysh on 4/19/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "SwitchSegment.h"



#define kDefaultCornerRadius   5.0f
#define kSelectedItemBackGroundColor [UIColor colorWithRed:0/255.0 green:130/255.0 blue:123/255.0 alpha:1.0]
#define kUnSelectedItemBackGroundColor [UIColor colorWithRed:196/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define kSelectedItemColor [UIColor whiteColor]
#define kUnSelectedItemColor [UIColor colorWithRed:0/2555.0 green:194/255.0 blue:186/255.0 alpha:1.0]


@interface SwitchSegment () {
    
@private
    
    NSArray *_unSelectedItemBackgroundGradientCGColors;
    
}

@property (nonatomic, retain, readwrite) NSMutableArray *items;

- (BOOL)_mustCustomize;

@end



@implementation SwitchSegment


#pragma mark - Object life cycle


- (void)initialize

{
    self.cornerRadius = kDefaultCornerRadius;
    self.selectedItemShadowColor = [UIColor clearColor];
    self.unselectedItemShadowColor = [UIColor clearColor];
    self.tintColor = kSelectedItemBackGroundColor;
    self.unSelectedItemBackgroundGradientColors = [NSArray arrayWithObjects:
                                                   kUnSelectedItemBackGroundColor,
                                                   kUnSelectedItemBackGroundColor,
                                                   nil];
    self.selectedItemColor = kSelectedItemColor;
    self.unselectedItemColor = kUnSelectedItemColor;
    [self setSelectedSegmentIndex:0];
}


- (void)awakeFromNib

{
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:self.numberOfSegments];
    for (int i = 0; i < self.numberOfSegments; i++) {
        NSString *aTitle = [self titleForSegmentAtIndex:i];
        if (aTitle) {
            [ar addObject:aTitle];
        } else {
            UIImage *anImage = [self imageForSegmentAtIndex:i];
            if (anImage) {
                [ar addObject:anImage];
            }
        }
        
    }
    self.items = ar;
    [self initialize];
    [self setNeedsDisplay];
    
}


- (id)initWithItems:(NSArray *)array

{
    
    self = [super initWithItems:array];
    
    if (self) {
        if (array) {
            NSMutableArray *mutableArray = [array mutableCopy];
            self.items = mutableArray;
        } else {
            self.items = [NSMutableArray array];
        }
        [self initialize];
    }
    return self;
}

- (BOOL)_mustCustomize

{
    return 1;
}


#pragma mark - Custom accessors

- (void)setUnSelectedItemBackgroundGradientColors:(NSArray *)array

{
    
    if (array && [array count] != 2) {
        
        NSLog(@"MCSegmentedControl WARNING: unSelectedItemBackgroundGradientColors must contain 2 colors");
        
    }
    
    else if (array != _unSelectedItemBackgroundGradientColors) {
        
        
        _unSelectedItemBackgroundGradientColors = array;
        
        
        if (_unSelectedItemBackgroundGradientColors) {
            
            _unSelectedItemBackgroundGradientCGColors = [[NSArray alloc] initWithObjects:
                                                         
                                                         (id)((UIColor *)[_unSelectedItemBackgroundGradientColors objectAtIndex:0]).CGColor,
                                                         
                                                         (id)((UIColor *)[_unSelectedItemBackgroundGradientColors objectAtIndex:0]).CGColor,
                                                         
                                                         nil];
            
            
            [self setNeedsDisplay];
            
        }
        
        else {
            
            _unSelectedItemBackgroundGradientCGColors = nil;
            
        }
        
    }
    
}


#pragma mark - Overridden UISegmentedControl methods

- (void)layoutSubviews

{
    
    for (UIView *subView in self.subviews) {
        
        [subView removeFromSuperview];
        
    }
    
}

- (NSUInteger)numberOfSegments

{
    
    if (!self.items || ![self _mustCustomize]) {
        
        return [super numberOfSegments];
        
    } else {
        
        return self.items.count;
        
    }
    
}

- (void)drawRect:(CGRect)rect

{
    
    
    // Only the bordered and plain style are customized
    
    
    // TODO: support for segment custom width
    
    CGSize itemSize = CGSizeMake(round(rect.size.width / self.numberOfSegments), rect.size.height);
    
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    CGContextSaveGState(c);
    
    
    
    // Rect with radius, will be used to clip the entire view
    
    CGFloat minx = CGRectGetMinX(rect) + 1, midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
    
    CGFloat miny = CGRectGetMinY(rect) + 1, midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
    
    
    
    // Path are drawn starting from the middle of a pixel, in order to avoid an antialiased line
    
    CGContextMoveToPoint(c, minx - .5, midy - .5);
    
    CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, _cornerRadius);
    
    CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, _cornerRadius);
    
    CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, _cornerRadius);
    
    CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, _cornerRadius);
    
    CGContextClosePath(c);
    
    
    CGContextClip(c);
    
    
    
    // Background gradient for non selected items
    
    
    if (_unSelectedItemBackgroundGradientCGColors) {
        
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)_unSelectedItemBackgroundGradientCGColors, NULL);
        
        CGContextDrawLinearGradient(c, gradient, CGPointZero, CGPointMake(0, rect.size.height), kCGGradientDrawsBeforeStartLocation);
        
        CFRelease(gradient);
        
    }
    
    
    for (int i = 0; i < self.numberOfSegments; i++) {
        
        id item = [self.items objectAtIndex:i];
        
        
        BOOL isSegmentEnabled = [self isEnabledForSegmentAtIndex:i];
        
        
        CGRect itemBgRect = CGRectMake(i * itemSize.width,
                                       
                                       0.0f,
                                       
                                       itemSize.width,
                                       
                                       rect.size.height);
        
        
        if (i == self.selectedSegmentIndex) {
            
            
            // -- Selected item --
            
            
            // Background gradient is composed of two gradients, one on the top, another rounded on the bottom
            
            
            CGContextSaveGState(c);
            
            CGContextClipToRect(c, itemBgRect);
            int red = 55, green = 111, blue = 214; // default blue color
            
            if (self.tintColor != nil) {
                
                const CGFloat *components = CGColorGetComponents(self.tintColor.CGColor);
                
                size_t numberOfComponents = CGColorGetNumberOfComponents(self.tintColor.CGColor);
                
                
                if (numberOfComponents == 2) {
                    
                    red = green = blue = components[0] * 255;
                    
                } else if (numberOfComponents == 4) {
                    red   = components[0] * 255;
                    green = components[1] * 255;
                    blue  = components[2] * 255;
                }
                
            }
            
            // Bottom gradient
            
            // It's clipped in a rect with the left corners rounded if segment is the first,
            
            // right corners rounded if segment is the last, no rounded corners for the segments inbetween
            
            
            CGRect bottomGradientRect = CGRectMake(itemBgRect.origin.x,
                                                   
                                                   itemBgRect.origin.y + round(itemBgRect.size.height / 2),
                                                   
                                                   itemBgRect.size.width,
                                                   
                                                   round(itemBgRect.size.height / 2));
            
            
            CGFloat bottom_components[16] = {
                
                (red)/255.0f, (green)/255.0f, (blue)/255.0f, 1.0f,
                
                (red)/255.0f, (green)/255.0f, (blue)/255.0f, 1.0f
                
            };
            
            
            CGFloat bottom_locations[2] = {
                0.0f, 1.0f
            };
            
            
            CGGradientRef bottom_gradient = CGGradientCreateWithColorComponents(colorSpace, bottom_components, bottom_locations, 2);
            
            CGContextDrawLinearGradient(c,
                                        bottom_gradient,
                                        bottomGradientRect.origin,
                                        CGPointMake(bottomGradientRect.origin.x,
                                                    bottomGradientRect.origin.y + bottomGradientRect.size.height),
                                        kCGGradientDrawsBeforeStartLocation);
            CFRelease(bottom_gradient);
            CGContextRestoreGState(c);
            
        }
        
        
        if ([item isKindOfClass:[UIImage class]]) {
            
            CGImageRef imageRef = [(UIImage *)item CGImage];
            
            CGFloat imageScale  = [(UIImage *)item scale];
            
            CGFloat imageWidth  = CGImageGetWidth(imageRef)  / imageScale;
            
            CGFloat imageHeight = CGImageGetHeight(imageRef) / imageScale;
            
            
            CGRect imageRect = CGRectMake(round(i * itemSize.width + (itemSize.width - imageWidth) / 2),
                                          
                                          round((itemSize.height - imageHeight) / 2),
                                          
                                          imageWidth,
                                          
                                          imageHeight);
            
            
            if (i == self.selectedSegmentIndex) {
                
                
                // 1px shadow
                
                CGContextSaveGState(c);
                
                CGContextTranslateCTM(c, 0, itemBgRect.size.height);
                
                CGContextScaleCTM(c, 1.0, -1.0);
                
                
                CGContextClipToMask(c, CGRectOffset(imageRect, 0, 1), imageRef);
                
                CGContextSetFillColorWithColor(c, self.selectedItemShadowColor.CGColor);
                
                CGContextFillRect(c, CGRectOffset(imageRect, 0, -1));
                
                CGContextRestoreGState(c);
                
                
                // Image drawn as a mask
                
                CGContextSaveGState(c);
                
                CGContextTranslateCTM(c, 0, rect.size.height);
                
                CGContextScaleCTM(c, 1.0, -1.0);
                
                
                CGContextClipToMask(c, imageRect, imageRef);
                
                CGContextSetFillColorWithColor(c, self.selectedItemColor.CGColor);
                
                CGContextFillRect(c, imageRect);
                
                CGContextRestoreGState(c);
                
            }
            
            else {
                
                if (isSegmentEnabled) {
                    
                    // 1px shadow
                    
                    CGContextSaveGState(c);
                    
                    CGContextTranslateCTM(c, 0, itemBgRect.size.height);
                    
                    CGContextScaleCTM(c, 1.0, -1.0);
                    
                    
                    CGContextClipToMask(c, CGRectOffset(imageRect, 0, -1), imageRef);
                    
                    CGContextSetFillColorWithColor(c, self.unselectedItemShadowColor.CGColor);
                    
                    CGContextFillRect(c, CGRectOffset(imageRect, 0, -1));
                    
                    CGContextRestoreGState(c);
                    
                }
                
                
                // Image drawn as a mask
                
                CGContextSaveGState(c);
                
                CGContextTranslateCTM(c, 0, itemBgRect.size.height);
                
                CGContextScaleCTM(c, 1.0, -1.0);
                
                
                CGContextClipToMask(c, imageRect, imageRef);
                
                CGContextSetFillColorWithColor(c, [self.unselectedItemColor CGColor]);
                
                CGContextSetAlpha(c, isSegmentEnabled ? 1.0 : 0.5);
                
                CGContextFillRect(c, imageRect);
                
                CGContextRestoreGState(c);
                
            }
            
            
        }
        
        
        
    }
    
    
    
    CFRelease(colorSpace);
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    if (![self _mustCustomize]) {
        
        [super touchesBegan:touches withEvent:event];
        
    } else {
        
        CGPoint point = [[touches anyObject] locationInView:self];
        
        int itemIndex = floor(self.numberOfSegments * point.x / self.bounds.size.width);
        
        if ([self isEnabledForSegmentAtIndex:itemIndex]) {
            
            self.selectedSegmentIndex = itemIndex;
            
            
            [self setNeedsDisplay];
            
        }
        
    }
    
}


- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex

{
    
    if (selectedSegmentIndex == self.selectedSegmentIndex) return;
    
    
    [super setSelectedSegmentIndex:selectedSegmentIndex];
    
    
#ifdef __IPHONE_5_0
    
    if ([self respondsToSelector:@selector(apportionsSegmentWidthsByContent)]
        
        && [self _mustCustomize])
        
    {
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        
    }
    
#endif
    
}


- (void)setSegmentedControlStyle:(UISegmentedControlStyle)aStyle

{
    
    [super setSegmentedControlStyle:aStyle];
    
    if ([self _mustCustomize]) {
        
        [self setNeedsDisplay];
        
    }
    
}


- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment

{
    
    if (![self _mustCustomize]) {
        
        [super setTitle:title forSegmentAtIndex:segment];
        
    } else {
        
        [self.items replaceObjectAtIndex:segment withObject:title];
        
        [self setNeedsDisplay];
        
    }
    
}


- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment

{
    
    if (![self _mustCustomize]) {
        
        [super setImage:image forSegmentAtIndex:segment];
        
    } else {
        
        [self.items replaceObjectAtIndex:segment withObject:image];
        
        [self setNeedsDisplay];
        
    }
    
}


- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated

{
    
    if (![self _mustCustomize]) {
        
        [super insertSegmentWithTitle:title atIndex:segment animated:animated];
        
    } else {
        
        if (segment >= self.numberOfSegments && segment != 0) return;
        
        [super insertSegmentWithTitle:title atIndex:segment animated:animated];
        
        [self.items insertObject:title atIndex:segment];
        
        [self setNeedsDisplay];
        
    }
    
}


- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)segment animated:(BOOL)animated

{
    
    if (![self _mustCustomize]) {
        
        [super insertSegmentWithImage:image atIndex:segment animated:animated];
        
    } else {
        
        if (segment >= self.numberOfSegments) return;
        
        [super insertSegmentWithImage:image atIndex:segment animated:animated];
        
        [self.items insertObject:image atIndex:segment];
        
        [self setNeedsDisplay];
        
    }
    
}


- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated

{
    
    if (![self _mustCustomize]) {
        
        [super removeSegmentAtIndex:segment animated:animated];
        
    } else {
        
        if (segment >= self.numberOfSegments) return;
        
        [self.items removeObjectAtIndex:segment];
        
        [self setNeedsDisplay];
        
    }
    
}



@end


