
//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import "REVClusterMapView.h"
#import "REVClusterManager.h"
#import "BlockStates.h"

@interface REVClusterMapView (Private)
- (void) setup;
- (BOOL) mapViewDidZoom;
@end

@implementation REVClusterMapView

@synthesize minimumClusterLevel;
@synthesize blocks;
@synthesize delegate;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void) setup
{
#if !__has_feature(objc_arc)
    annotationsCopy = [[[NSMutableArray alloc] init] retain];
#else
    annotationsCopy = [NSMutableArray array];
#endif
    
    self.minimumClusterLevel = 30000;
    self.blocks = 4;
    
    super.delegate = self;
    
    zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [annotationsCopy release];
    [super dealloc];
}
#endif

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if( [delegate respondsToSelector:@selector(mapView:viewForOverlay:)] )
    {
        return [delegate mapView:mapView viewForOverlay:overlay];
    }
    return nil;
}
    
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if( [delegate respondsToSelector:@selector(mapView:viewForAnnotation:)] )
    {
        return [delegate mapView:mapView viewForAnnotation:annotation];
    } 
    return nil;
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if( [delegate respondsToSelector:@selector(mapView:regionWillChangeAnimated:)] )
    {
        [delegate mapView:mapView regionWillChangeAnimated:animated];
    } 
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewWillStartLoadingMap:)] )
    {
        [delegate mapViewWillStartLoadingMap:mapView];
    }
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewDidFinishLoadingMap:)] )
    {
        [delegate mapViewDidFinishLoadingMap:mapView];
    }
}
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    if( [delegate respondsToSelector:@selector(mapViewDidFailLoadingMap:withError:)] )
    {
        [delegate mapViewDidFailLoadingMap:mapView withError:error];
    }
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if( [delegate respondsToSelector:@selector(mapView:didAddAnnotationViews:)] )
    {
        [delegate mapView:mapView didAddAnnotationViews:views];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if( [delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)] )
    {
        [delegate mapView:mapView annotationView:view calloutAccessoryControlTapped:control];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if( [delegate respondsToSelector:@selector(mapView:didSelectAnnotationView:)] )
    {
        [delegate mapView:mapView didSelectAnnotationView:view];
    }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if( [delegate respondsToSelector:@selector(mapView:didDeselectAnnotationView:)] )
    {
        [delegate mapView:mapView didDeselectAnnotationView:view];
    }
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewWillStartLocatingUser:)] )
    {
        [delegate mapViewWillStartLocatingUser:mapView];
    }
}
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewDidStopLocatingUser:)] )
    {
        [delegate mapViewDidStopLocatingUser:mapView];
    }
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if( [delegate respondsToSelector:@selector(mapView:didUpdateUserLocation:)] )
    {
        [delegate mapView:mapView didUpdateUserLocation:userLocation];
    }
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if( [delegate respondsToSelector:@selector(mapView:didFailToLocateUserWithError:)] )
    {
        [delegate mapView:mapView didFailToLocateUserWithError:error];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState 
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if( [delegate respondsToSelector:@selector(mapView:annotationView:didChangeDragState:fromOldState:)] )
    {
        [delegate mapView:mapView annotationView:view didChangeDragState:newState fromOldState:oldState];
    }
}

// Called after the provided overlay views have been added and positioned in the map.
- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    if( [delegate respondsToSelector:@selector(mapView:didAddOverlayViews:)] )
    {
        [delegate mapView:mapView didAddOverlayViews:overlayViews];
    }
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if( [delegate respondsToSelector:@selector(mapView:regionDidChangeAnimated:)] )
    {
        [delegate mapView:mapView regionDidChangeAnimated:animated];
    }
    
    if( [self mapViewDidZoom] )
    {
        [super removeAnnotations:self.annotations];
    }
    
    if ([annotationsCopy count] > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *add = [REVClusterManager clusterAnnotationsForMapView:self forAnnotations:annotationsCopy blocks:self.blocks minClusterLevel:self.minimumClusterLevel];
            dispatch_async(dispatch_get_main_queue(), ^{
                [super addAnnotations:add];
            });
        });
    }
}

- (BOOL) mapViewDidZoom
{
    if( fabs(zoomLevel - self.visibleMapRect.size.width * self.visibleMapRect.size.height) < 5000)
    {
        // 地图奇怪地没有缩放的情况下都会出现visibleMapRect的值出现偏差，因此仅把值放到5000保证，其实5000对于地图来说缩放量很微小
        zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
        return NO;
    }
    zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
    return YES;
}

- (void) setMaximumClusterLevel:(NSUInteger)value
{
    if ( value > 419430 )
        minimumClusterLevel = 419430;
    else
        minimumClusterLevel = round(value);
}

- (void) setBlocks:(NSUInteger)value
{
    if( value > 1024 )
        blocks = 1024;
    else if ( value < 2 )
        blocks = 2;
    else 
        blocks = round(value);
}

#pragma mark -
#pragma mark - Function Modified
//reset the annotationsCopy
- (void)addAnnotations:(NSArray *)annotations
{
    if ([annotations count] > 0) {
        [annotationsCopy addObjectsFromArray:annotations];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *add = [REVClusterManager clusterAnnotationsForMapView:self forAnnotations:annotations blocks:self.blocks minClusterLevel:self.minimumClusterLevel];
            dispatch_async(dispatch_get_main_queue(), ^{
                [super addAnnotations:add];
            });
        });
        
//        [[NSOperationQueue new] addOperationWithBlock:^{
//            
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                
//            }];
//        }];
    }
}

- (void)clearAnnotationsCopy
{
    [annotationsCopy removeAllObjects];
}

@end
