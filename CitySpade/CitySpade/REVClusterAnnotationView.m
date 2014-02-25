//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import "REVClusterAnnotationView.h"


@implementation REVClusterAnnotationView

@synthesize coordinate;
@synthesize annotations;

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        //(0, 0, 26, 26)刚好覆盖整个圆圈
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"Verdana-Bold" size:11.0f];
    }
    return self;
}

- (void)setClusterText:(NSString *)text
{
    label.text = text;
}

- (void)setLabelFrame:(CGRect)aFrame
{
    label.frame = aFrame;
}

- (void)setAnnotations:(NSArray *)annotationlist
{
    if (!self.annotations)
        self.annotations = [NSArray array];
    self.annotations = annotationlist;
}

- (void) dealloc
{
    [label release], label = nil;
    [annotations release], annotations = nil;
    [super dealloc];
}

@end
