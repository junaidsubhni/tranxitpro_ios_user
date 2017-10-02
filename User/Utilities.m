//
//  Utilities.m
//  HealingRadiusPro
//
//  Created by STS-038 on 09/03/15.
//  Copyright (c) 2015 SPAN Technology Services. All rights reserved.
//

#import "Utilities.h"
#import <UIKit/UIKit.h>

@implementation Utilities


+ (NSString *)setPhoneNumberMASKFromString:(NSString *)string
{
    
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
    NSArray *stringComponents = [NSArray arrayWithObjects:[string substringWithRange:NSMakeRange(0, 3)],
                                 [string substringWithRange:NSMakeRange(3, 3)],
                                 [string substringWithRange:NSMakeRange(6, [string length]-6)], nil];
    string = [NSString stringWithFormat:@"(%@) %@-%@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2]];
    return string;
}

+ (NSString *)setAddressFormatFromString:(NSString *)address1 :(NSString *)address2 :(NSString *)city :(NSString *)state :(NSString *)zipcode
{
    address1 = [self removeNullFromString:address1];
    address2 = [self removeNullFromString:address2];
    city = [self removeNullFromString:city];
    state = [self removeNullFromString:state];
    zipcode = [self removeNullFromString:zipcode];

    address1 = [self removeSpecialCharacterFromString:address1];
    address2 = [self removeSpecialCharacterFromString:address2];
    city = [self removeSpecialCharacterFromString:city];
    state = [self removeSpecialCharacterFromString:state];
    zipcode = [self removeSpecialCharacterFromString:zipcode];
    
    NSString *addressFormatString;
    
    if ([address1 isEqualToString:@""])
    {
        addressFormatString = [NSString stringWithFormat:@"%@, %@, %@ %@", address2, city, state, zipcode];
    }
    else if ([address2 isEqualToString:@""])
    {
        addressFormatString = [NSString stringWithFormat:@"%@, %@, %@ %@",address1, city, state, zipcode];
    }
    else if ([address1 isEqualToString:@""] && [address2 isEqualToString:@""])
    {
        addressFormatString = [NSString stringWithFormat:@"%@, %@ %@", city, state, zipcode];
    }
    else if ([address1 isEqualToString:@""] && [address2 isEqualToString:@""] && [city isEqualToString:@""])
    {
        addressFormatString = [NSString stringWithFormat:@"%@ %@", state, zipcode];
    }
    else
    {
        addressFormatString = [NSString stringWithFormat:@"%@ %@, %@, %@ %@",address1, address2, city, state, zipcode];
    }
    
    addressFormatString = [addressFormatString stringByReplacingOccurrencesOfString:@",," withString:@","];
    addressFormatString = [addressFormatString stringByReplacingOccurrencesOfString:@"<null>," withString:@""];
    addressFormatString = [addressFormatString stringByReplacingOccurrencesOfString:@" ," withString:@","];
    
    return addressFormatString;
}

+ (NSString *)setAddressFormatForLine2:(NSString *)city :(NSString *)state :(NSString *)zipcode
{
    city = [self removeNullFromString:city];
    state = [self removeNullFromString:state];
    zipcode = [self removeNullFromString:zipcode];
    
    city = [self removeSpecialCharacterFromString:city];
    state = [self removeSpecialCharacterFromString:state];
    zipcode = [self removeSpecialCharacterFromString:zipcode];
    
    NSString *addressFormatString = [NSString stringWithFormat:@"%@, %@ %@",city, state, zipcode];
    
    addressFormatString = [addressFormatString stringByReplacingOccurrencesOfString:@",," withString:@","];
    addressFormatString = [addressFormatString stringByReplacingOccurrencesOfString:@"<null>," withString:@""];
    addressFormatString = [addressFormatString stringByReplacingOccurrencesOfString:@" ," withString:@","];
    
    if ([addressFormatString hasPrefix:@","])
    {
        addressFormatString = [addressFormatString substringFromIndex:1];
    }
    return addressFormatString;
}

+ (NSString *)removeNullFromString:(NSString *)string
{
    if (string == (id)[NSNull null] || string.length == 0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"] || [string isEqualToString:@" "] || [string isEqualToString:@"01/01/0001"] || [string isEqualToString:@"1/1/0001"] || [string isEqualToString:@"0001-01-01T00:00:00"])
    {
        string = @"";
    }
    return string;
}

+ (NSString *)removeNullFromString:(NSString *)string replaceWith:(NSString *)replaceString
{    
    if (string == (id)[NSNull null] || string.length == 0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"] || [string isEqualToString:@" "] || [string isEqualToString:@"01/01/0001"] || [string isEqualToString:@"1/1/0001"] || [string isEqualToString:@"0001-01-01T00:00:00"])
    {
        string = replaceString;
    }
    return string;
}

+ (NSString *)removeSpecialCharacterFromString:(NSString *)string
{
    
    string = [string stringByReplacingOccurrencesOfString:@" +" withString:@" "options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
    string = (NSString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\"" options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
    return string;
}


+ (NSString *)toBase64String:(NSString *)string
{
    NSData *plainData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return base64String;
}


+ (NSString *) fuelQuantityFormatter:(NSString *) string
{
    double fuelQuantity = [string doubleValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:3];
    [formatter setMinimumFractionDigits:3];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithDouble:fuelQuantity]];
    
    return numberString;
}

+ (NSString *)convertTimeFormat:(NSString *)string
{
    NSArray *startTimeSplitArray= [string componentsSeparatedByString:@" "];
    
    NSString *startTimeVal=[startTimeSplitArray objectAtIndex:1];
    
//    if (![startTimeSplitArray isKindOfClass:[NSNull class]] && [startTimeSplitArray count]>1)
//    {
//        startTimeVal = [startTimeSplitArray objectAtIndex:1];
//        
//        NSArray *secondsArray = [startTimeVal componentsSeparatedByString:@"."];
//        
//        if (![secondsArray isKindOfClass:[NSNull class]]  && [secondsArray count]>1)
//        {
//            startTimeVal = [secondsArray objectAtIndex:0];
//        }
//    }
    
    NSDateFormatter *startTimeFormatter1 = [[NSDateFormatter alloc] init];
    startTimeFormatter1.dateFormat = @"HH:mm:ss";
    
    NSDate *dateStartTime = [startTimeFormatter1 dateFromString:startTimeVal];
    startTimeFormatter1.dateFormat = @"hh:mm a";
    
    NSString *startTimeString = [startTimeFormatter1 stringFromDate:dateStartTime];

    return startTimeString;
}

+ (NSString *)convertDateFormatter:(NSString *)dateTimeString
{
    NSArray *dateSplitArray= [dateTimeString componentsSeparatedByString:@"T"];
    NSString *startDate;
    if (![dateSplitArray isKindOfClass:[NSNull class]])
    {
        startDate = [dateSplitArray objectAtIndex:0];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",startDate]];
    
   // [dateFormatter setDateFormat:@"EEE, MMM dd, yyyy"];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *dateString = [dateFormatter stringFromDate:date1];
    
    return dateString;
}

+ (NSString *)convertDateTimeToGMT:(NSString *)dateTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMM yyyy";
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSTimeZone *gmtZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    NSDate *newDate = [dateFormatter1 dateFromString:dateTimeString];
    [dateFormatter1 setTimeZone:gmtZone];
    NSString *gmtDateTimeStr = [dateFormatter stringFromDate:newDate];
    
    if (newDate == nil)
    {
        NSDate *newDate = [dateFormatter dateFromString:dateTimeString];
        [dateFormatter setTimeZone:gmtZone];
        gmtDateTimeStr = [dateFormatter stringFromDate:newDate];
    }
    
    return gmtDateTimeStr;
}

@end
