//
//  NSString+Encryption.m
//  GoGoPiao
//
//  Created by Cho-Yeung Lam on 20/9/13.
//  Copyright (c) 2013 Cho-Yeung Lam. All rights reserved.
//

#import "NSString+Encryption.h"
#import "RegExCategories.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Encryption)

+ (NSString *)sha1EncryptWithUnsortedStrings:(NSDictionary *)paramDict
{
    NSMutableArray *paramArray = [NSMutableArray array];
    for (NSString *key in paramDict.allKeys) {
        [paramArray addObject:paramDict[key]];
    }
    //    NSArray *paramArray = [NSArray arrayWithObjects:paramDict[@"platform"], paramDict[@"application"], paramDict[@"client_uuid"], nil];
    NSArray *sortedArray = [paramArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString*)obj1 compare:obj2 options:NSDiacriticInsensitiveSearch|NSCaseInsensitiveSearch];
    }];
    
    NSString *wholeString = [NSString stringWithFormat:@"%@%@%@%@", sortedArray[0], sortedArray[1], sortedArray[2], sortedArray[3]];
    return [wholeString sha1];
}

- (NSString *)sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+ (NSString *)getCFUUID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id uuid = [defaults objectForKey:@"UUID"];
    
    if (uuid)
        return [NSString stringWithString:(NSString *)uuid];
    else {
        CFUUIDRef temp = CFUUIDCreate(NULL);
        CFStringRef cfUuid = CFUUIDCreateString(NULL, temp);
        NSString *uuidString = [NSString stringWithString:(__bridge NSString*) cfUuid];
        CFRelease(cfUuid);
        CFRelease(temp);
        
        [defaults setObject:uuidString forKey:@"UUID"];
        return uuidString;
    }
}

+ (BOOL)isEmailAddress:(NSString*)email {
    
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+ (NSString *)usernameWithEmail:(NSString *)email
{
    NSArray *pieces = [email split:RX(@"[@]")];
    return pieces[0];
}

@end
