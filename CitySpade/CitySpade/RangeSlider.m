//
//  RangeSlider.m
//  RangeSlider
//
//  Created by Mal Curtis on 5/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RangeSlider.h"
#import "JLPopupView.h"

@interface RangeSlider (PrivateMethods)
-(float)xForValue:(float)value;
-(float)valueForX:(float)x;
-(void)updateTrackHighlight;
@end

@implementation RangeSlider

@synthesize minimumValue, maximumValue, minimumRange, selectedMinimumValue, selectedMaximumValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minThumbOn = false;
        _maxThumbOn = false;
        _padding = 20;
        
        _trackBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar-background.png"]];
        _trackBackground.center = self.center;
        [self addSubview:_trackBackground];
        
        _track = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar-highlight.png"]];
        _track.center = self.center;
        [self addSubview:_track];
        
        _minThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handle.png"] highlightedImage:[UIImage imageNamed:@"handle-hover.png"]];
        _minThumb.frame = CGRectMake(0,0, self.frame.size.height,self.frame.size.height);
        _minThumb.contentMode = UIViewContentModeCenter;
        [self addSubview:_minThumb];
        
        _maxThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handle.png"] highlightedImage:[UIImage imageNamed:@"handle-hover.png"]];
        _maxThumb.frame = CGRectMake(0,0, self.frame.size.height,self.frame.size.height);
        _maxThumb.contentMode = UIViewContentModeCenter;
        [self addSubview:_maxThumb];
        
        [self constructSlider];
    }
    
    return self;
}


-(void)layoutSubviews
{
    // Set the initial state
    _minThumb.center = CGPointMake([self xForValue:selectedMinimumValue], self.center.y);
    
    _maxThumb.center = CGPointMake([self xForValue:selectedMaximumValue], self.center.y);
    
    NSLog(@"Tapable size %f", _minThumb.bounds.size.width); 
    [self updateTrackHighlight];
}

-(float)xForValue:(float)value
{
    return (self.frame.size.width-(_padding*2))*((value - minimumValue) / (maximumValue - minimumValue))+_padding;
}

-(float)valueForX:(float)x
{
    return minimumValue + (x-_padding) / (self.frame.size.width-(_padding*2)) * (maximumValue - minimumValue);
}

#pragma mark - UIControl touch event tracking

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!_minThumbOn && !_maxThumbOn){
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    if(_minThumbOn){
        _minThumb.center = CGPointMake(MAX([self xForValue:minimumValue],MIN(touchPoint.x - distanceFromCenter, [self xForValue:selectedMaximumValue - minimumRange])), _minThumb.center.y);
        selectedMinimumValue = [self valueForX:_minThumb.center.x];
        
    }
    if(_maxThumbOn){
        _maxThumb.center = CGPointMake(MIN([self xForValue:maximumValue], MAX(touchPoint.x - distanceFromCenter, [self xForValue:selectedMinimumValue + minimumRange])), _maxThumb.center.y);
        selectedMaximumValue = [self valueForX:_maxThumb.center.x];
    }
    [self updateTrackHighlight];
    [self setNeedsLayout];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self positionAndUpdatePopupView];
    return [super continueTrackingWithTouch:touch withEvent:event];
}

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    
    if(CGRectContainsPoint(_minThumb.frame, touchPoint)){
        _minThumbOn = true;
        distanceFromCenter = touchPoint.x - _minThumb.center.x;
        [self positionAndUpdatePopupView];
        [self fadePopupViewInAndOut:YES];
    }
    else if(CGRectContainsPoint(_maxThumb.frame, touchPoint)){
        _maxThumbOn = true;
        distanceFromCenter = touchPoint.x - _maxThumb.center.x;
        [self positionAndUpdatePopupView];
        [self fadePopupViewInAndOut:YES];
    }
    return [super beginTrackingWithTouch:touch withEvent:event];
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    _minThumbOn = false;
    _maxThumbOn = false;
    [self fadePopupViewInAndOut:NO];
    [super endTrackingWithTouch:touch withEvent:event];
}

-(void)updateTrackHighlight{
	_track.frame = CGRectMake(
                              _minThumb.center.x,
                              _track.center.y - (_track.frame.size.height/2),
                              _maxThumb.center.x - _minThumb.center.x,
                              _track.frame.size.height
                              );
}

-(void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
}

#pragma mark - Helper methods
-(void)constructSlider {
    self.minimumPopupView = [[JLPopupView alloc] initWithFrame:CGRectZero];
    self.maximumPopupView = [[JLPopupView alloc] initWithFrame:CGRectZero];
    self.minimumPopupView.backgroundColor = [UIColor clearColor];
    self.maximumPopupView.backgroundColor = [UIColor clearColor];
    self.minimumPopupView.alpha = 0.0;
    self.maximumPopupView.alpha = 0.0;
    [self addSubview:self.minimumPopupView];
    [self addSubview:self.maximumPopupView];
}

- (void)fadePopupViewInAndOut:(BOOL)aFadeIn
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if (aFadeIn) {
        self.minimumPopupView.alpha = 1.0;
        self.maximumPopupView.alpha = 1.0;
    } else {
        self.minimumPopupView.alpha = 0.0;
        self.maximumPopupView.alpha = 0.0;
    }
    [UIView commitAnimations];
}

- (void)positionAndUpdatePopupView {
    CGRect minThumbR = self.minThumbRect;
    CGRect maxThumbR = self.maxThumbRect;
    CGRect minpopupRect = CGRectOffset(minThumbR, 0, -floor(minThumbR.size.height * 1.5));
    CGRect maxpopupRect = CGRectOffset(maxThumbR, 0, -floor(maxThumbR.size.height * 1.5));
    self.minimumPopupView.frame = CGRectInset(minpopupRect, -20, -10);
    self.maximumPopupView.frame = CGRectInset(maxpopupRect, -20, -10);
    self.minimumPopupView.value = self.selectedMinimumValue;
    self.maximumPopupView.value = self.selectedMaximumValue;
}


#pragma mark - Property accessors
- (CGRect)minThumbRect
{
    float x = [self xForValue:selectedMinimumValue];
    float y = _minThumb.center.y;
    CGRect thumbR = CGRectMake(x-self.frame.size.height*0.5, y-self.frame.size.height*0.5, self.frame.size.height*0.5, self.frame.size.height*0.5);
    return thumbR;
}

- (CGRect)maxThumbRect
{
    float x = [self xForValue:selectedMaximumValue];
    float y = _maxThumb.center.y;
    CGRect thumbR = CGRectMake(x-self.frame.size.height*0.5, y-self.frame.size.height*0.5, self.frame.size.height*0.5, self.frame.size.height*0.5);
    return thumbR;
}


@end
