//
//  Images.h
//
//  Created by Lam Cho-Yeung on 19/2/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Images : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *sizes;
@property (nonatomic, strong) NSString *url;

+ (Images *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
