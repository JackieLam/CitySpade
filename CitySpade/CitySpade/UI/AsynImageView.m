//
//  AsynImageView.m
//  AsynImage
//
//  Created by administrator on 13-3-5.
//  Copyright (c) 2013年 enuola. All rights reserved.
//

#import "AsynImageView.h"
#import <QuartzCore/QuartzCore.h>

#define kActivityIndicatorTag 6

@implementation AsynImageView

@synthesize imageURL = _imageURL;
@synthesize placeholderImage = _placeholderImage;
@synthesize fileName = _fileName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.borderWidth = 0.0;
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

-(void)setPlaceholderImage:(UIImage *)placeholderImage
{
    if(placeholderImage != _placeholderImage)
    {
        _placeholderImage = placeholderImage;
        self.image = _placeholderImage;
    }
}

-(void)setImageURL:(NSString *)imageURL
{
    if(imageURL != _imageURL)
    {
        self.image = _placeholderImage;
        _imageURL = imageURL;
    }
    
    if(self.imageURL)
    {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = self.frame;
        activityIndicator.tag = kActivityIndicatorTag;
        [activityIndicator startAnimating];
        [self addSubview:activityIndicator];
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString *docDir=[path objectAtIndex:0];
        NSDate *date = [NSDate date];
        NSString *dateStr = [NSString stringWithFormat:@"%@",date];
        NSString *tmpPath = [docDir stringByAppendingPathComponent:@"AsynImage"];
        NSString *tmpPath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"AsynImage/%@",[dateStr substringToIndex:7]]];
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:tmpPath2])
        {
            [fm removeItemAtPath:tmpPath error:nil];
            [fm createDirectoryAtPath:tmpPath2 withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSArray *lineArray = [self.imageURL componentsSeparatedByString:@"/"];
        if (lineArray.count > 5) {
            self.fileName = [NSString stringWithFormat:@"%@/%@%@", tmpPath2, [lineArray objectAtIndex:[lineArray count] - 3],[lineArray objectAtIndex:[lineArray count] - 2]];
            if(![[NSFileManager defaultManager] fileExistsAtPath:_fileName])
            {
                [self loadImage];
            }
            else
            {
                self.image = [UIImage imageWithContentsOfFile:_fileName];
                if (!self.image) {
                    self.image = _placeholderImage;
                    [[NSFileManager defaultManager] removeItemAtPath:_fileName error:nil];
                }

                [activityIndicator removeFromSuperview];
                [activityIndicator stopAnimating];
            }
        }
        else{
            [activityIndicator removeFromSuperview];
            [activityIndicator stopAnimating];
        }
    }
}

-(void)loadImage
{
    @try {
        NSURLCache *urlCache = [NSURLCache sharedURLCache];
        [urlCache setMemoryCapacity:10*1024*1024];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.imageURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
        if(response != nil)
        {
            [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
        }
        if(!connection)
            connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    @catch (NSException *exception) {
        [self removeActivityIndicatorView];
    }
    @finally {
        ;
    }
}

#pragma mark - NSURLConnection Delegate Methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(loadData==nil)
    {
        loadData=[[NSMutableData alloc]initWithCapacity:2048];
    }
    [loadData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return request;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    if([loadData writeToFile:_fileName atomically:YES])
    {
        self.image = [UIImage imageWithContentsOfFile:_fileName];
        if (!self.image) {
            self.image = _placeholderImage;
            [[NSFileManager defaultManager] removeItemAtPath:_fileName error:nil];
        }
        [self removeActivityIndicatorView];
    }
    connection = nil;
    loadData = nil;
}

-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    connection = nil;
    loadData = nil;
    [self loadImage];
}

- (void)cancelConnection
{
    [connection cancel];
    [self removeActivityIndicatorView];
}

- (void)removeActivityIndicatorView
{
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self viewWithTag:kActivityIndicatorTag];
    while (activityIndicator) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        activityIndicator = (UIActivityIndicatorView *)[self viewWithTag:kActivityIndicatorTag];
    }
}
@end
