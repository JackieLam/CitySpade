//
//  CitySpadeBroker_InfoCell.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "CitySpadeBrokerInfoCell.h"
#import "BaseClass.h"
#import "CitySpadeModelManager.h"
@interface CitySpadeBrokerInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactTel;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation CitySpadeBrokerInfoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CitySpadeBrokerInfoCell" owner:self options:nil];
        self = (CitySpadeBrokerInfoCell *)[nib objectAtIndex:0];
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return self;
}

- (void)ConfigureCellWithItem: (BaseClass *)list {
    if ( list ) {
        NSArray *nameArray = [list.contactName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (nameArray.count == 1) {
            _contactName.text = nameArray[0];
        }
        else {
            _contactName.text = [NSString stringWithFormat:@"%@ %@", nameArray[0], nameArray[1]];
        }
        _contactTel.text = list.contactTel;
        NSURL *imagePath = [[CitySpadeModelManager sharedManager] imagePathForImageURL:list.originalIconUrl];
        
        if ( !imagePath ) {
            _indicator.center = _icon.center;
            [_indicator startAnimating];
            [_icon addSubview:_indicator];
            
        } else {
            [_indicator stopAnimating];
            [_indicator removeFromSuperview];
            NSData *imageData = [NSData dataWithContentsOfURL:imagePath];
            _icon.image = [UIImage imageWithData:imageData];

        }
    }
}

- (void) setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}


@end
