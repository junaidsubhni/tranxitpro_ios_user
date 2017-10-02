//
//  Utilities.h
//  HealingRadiusPro
//
//  Created by STS-038 on 09/03/15.
//  Copyright (c) 2015 SPAN Technology Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

+ (NSString *)setPhoneNumberMASKFromString:(NSString *)string;

+ (NSString *)setAddressFormatFromString:(NSString *)address1 :(NSString *)address2 :(NSString *)city :(NSString *)state :(NSString *)zipcode;

+ (NSString *)setAddressFormatForLine2:(NSString *)city :(NSString *)state :(NSString *)zipcode;

+ (NSString *) toBase64String:(NSString *) string;

+ (NSString *)removeNullFromString:(NSString *)string;

+ (NSString *)removeNullFromString:(NSString *)string replaceWith:(NSString *)replaceString;

+ (NSString *)removeSpecialCharacterFromString:(NSString *)string;

+ (NSString *)fuelQuantityFormatter:(NSString *) string;

+ (NSString *)convertTimeFormat:(NSString *)string;

+ (NSString *)convertDateTimeToGMT:(NSString *)dateTimeString;

+ (NSString *)convertDateFormatter:(NSString *)dateTimeString;

@end
