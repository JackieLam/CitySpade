//
//  TransportationBuslinesCell.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-20.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "TransportationBuslinesCell.h"
#import "DataModels.h"
#import "CitySpadeModelManager.h"
@interface TransportationBuslinesCell ()
@property (nonatomic, strong) UILabel *busLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation TransportationBuslinesCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 0, 0)];
        _nameLabel.textColor = [UIColor colorWithRed:51 / 255.0
                                              green:51 / 255.0
                                               blue:51 / 255.0
                                              alpha:1.0];
        _nameLabel.text = @"Buslines:";
        _nameLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:13];
        [_nameLabel sizeToFit];
        _nameLabel.hidden = YES;
        [self addSubview:_nameLabel];
        
        self.busLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width, 10, 0, 0)];
        _busLabel.textColor = [UIColor colorWithRed:102 / 255.0
                                              green:102 / 255.0
                                               blue:102 / 255.0
                                              alpha:1.0];
        _busLabel.text = @"";
        _busLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:13];
        _busLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_busLabel];

    }
    return self;
}


- (void)ConfigureCellWithItem:(BaseClass *)list {
    if ( !list ) {
        return;
    }
    NSArray *busArray = list.busLines;
    if ( [busArray count] != 0 ) {
        _nameLabel.hidden = NO;
        BOOL isFirstBus = YES;
        for ( BusLines *bus in busArray ) {
            if ( isFirstBus ) {
                isFirstBus = NO;
                _busLabel.text = [_busLabel.text stringByAppendingString:[NSString stringWithFormat:@" %@", bus.lineName]];
            } else {
                _busLabel.text = [_busLabel.text stringByAppendingString:[NSString stringWithFormat:@", %@", bus.lineName]];
            }
        }
        
        [_busLabel sizeToFit];
    }
}

@end
