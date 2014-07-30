//
//  CitySpadeBasicFactsCell.m
//  CitySpadeDemo
//
//  Created by izhuxin on 14-3-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "CitySpadeBasicFactsCell.h"

@interface CitySpadeBasicFactsCell ()

@property (weak, nonatomic) IBOutlet UILabel *bargainLabel;
@property (weak, nonatomic) IBOutlet UILabel *transportationLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *bedLabel;
@property (strong, nonatomic) IBOutlet UILabel *bathLabel;

@end

@implementation CitySpadeBasicFactsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CitySpadeBasicFactsCell" owner:self options:nil];
        self = (CitySpadeBasicFactsCell *)[nib objectAtIndex:0];
        
    }
    return self;
}

- (void) setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)ConfigureCellWithItem:(BaseClass *)list {
    _bargainLabel.text = _basicFactsDictionary[@"bargain"];
    _transportationLabel.text = _basicFactsDictionary[@"transportation"];
    /*
    CGFloat bargain = [_basicFactsDictionary[@"bargain"] floatValue];
    if (bargain > 0) {
        _bargainLabel.text = [NSString stringWithFormat:@"%.2f/10", bargain];
    }
    else {
        _bargainLabel.text = @"---";
    }
    
    CGFloat transportation = [_basicFactsDictionary[@"transportation"] floatValue];
    if (transportation > 0) {
        _transportationLabel.text = [NSString stringWithFormat:@"%.2f/10", transportation];
    }
    else {
        _transportationLabel.text = @"---";
    }*/
    int totalPrice = [_basicFactsDictionary[@"totalPrice"] intValue];
    _totalPriceLabel.text = [NSString stringWithFormat:@"$%d", totalPrice];
    
    int numberOfBed = [_basicFactsDictionary[@"numberOfBed"] intValue];
    int numberOfBath = [_basicFactsDictionary[@"numberOfBath"] intValue];
    NSString *isBedPlural = numberOfBed > 1 ? @"s":@"";
    NSString *isBathPlural = numberOfBath > 1 ? @"s":@"";
    _bedLabel.text = [NSString stringWithFormat:@"%dBed%@", numberOfBed,isBedPlural];
    _bathLabel.text = [NSString stringWithFormat:@"%dBath%@", numberOfBath,isBathPlural];
}

@end
