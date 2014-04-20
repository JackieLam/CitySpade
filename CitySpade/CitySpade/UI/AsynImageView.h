//
//  AsynImageView.h
//  AsynImage
//
//  Created by administrator on 13-3-5.
//  Copyright (c) 2013年 enuola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsynImageView : UIImageView
{
    NSURLConnection *connection;
    NSMutableData *loadData;
}

@property (nonatomic, strong) NSString *fileName;


@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) NSString *imageURL;


- (void)cancelConnection;
@end
