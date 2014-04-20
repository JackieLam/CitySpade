//
//  NSString+RegEx.m
//  MapNetworkTest
//
//  Created by Cho-Yeung Lam on 20/4/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "NSString+RegEx.h"

@implementation NSString (RegEx)

- (NSString *)firstNumberInString
{
    NSString *result;
    const char *str = [self UTF8String];
    char resultCStr[100];
    int j = 0;
    bool didfind = NO;
    
    for (int i = 0; i < strlen(str); i++) {
        bool isDigit = str[i] >= '0' && str[i] <= '9';
        if (isDigit) {
            resultCStr[j++] = str[i];
            didfind = YES;
        }
        else if (didfind && str[i] == '.')
            resultCStr[j++] = str[i];
        else if (didfind)
            break;
    }
    resultCStr[j] = '\0';
    result = [NSString stringWithCString:resultCStr encoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)emailUserNameInString
{
    NSString *result;
    const char *str = [self UTF8String];
    char resultCStr[100];
    int j = 0;
    bool didfind = NO;
    
    for (int i = 0; i < strlen(str); i++) {
        if (str[i] != '@')
            resultCStr[j++] = str[i];
        else
            break;
    }
    resultCStr[j] = '\0';
    result = [NSString stringWithCString:resultCStr encoding:NSUTF8StringEncoding];
    return result;
}


@end
