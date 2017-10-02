//
//  NSString+StringValidation.h
//  UnitWise
//
//  Created by STS-038 on 19/02/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringValidation)

- (NSString *)removeNullFromString:(NSString *)string;
- (NSString *)removeSpecialCharacterFromString:(NSString *)string;
- (NSString *)setMASKPhoneNumberFromString:(NSString *)string;
- (NSString*)contentsInParenthesis:(NSString *)str;
- (NSString *)urlencode;
-(NSString*)dayCount:(NSString *)string;
- (NSInteger)accountClosedUser:(NSString *)startDate;
-(NSString *)convertHTML:(NSString *)html;
@end
