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
@property (weak, nonatomic) IBOutlet UILabel *bedBathLabel;

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

- (void)ConfigureCellWithItem:(CitySpadeListsModel *)list {
    CGFloat bargain = [_basicFactsDictionary[@"bargain"] floatValue];
    _bargainLabel.text = [NSString stringWithFormat:@"%.1f/10", bargain];
    
    CGFloat transportation = [_basicFactsDictionary[@"transportation"] floatValue];
    _transportationLabel.text = [NSString stringWithFormat:@"%.1f/10", transportation];
    
    int totalPrice = [_basicFactsDictionary[@"totalPrice"] intValue];
    _totalPriceLabel.text = [NSString stringWithFormat:@"$%d", totalPrice];
    
    int numberOfBed = [_basicFactsDictionary[@"numberOfBed"] intValue];
    int numberOfBath = [_basicFactsDictionary[@"numberOfBath"] intValue];
    _bedBathLabel.text = [NSString stringWithFormat:@"%d Bed | %d Bath", numberOfBed, numberOfBath];
}
@end
