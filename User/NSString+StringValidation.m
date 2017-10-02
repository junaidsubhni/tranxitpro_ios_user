//
//  NSString+StringValidation.m
//  UnitWise
//
//  Created by STS-038 on 19/02/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "NSString+StringValidation.h"

@implementation NSString (StringValidation)

- (NSString *)removeNullFromString:(NSString *)string
{
    
    if (string == (id)[NSNull null] || string.length == 0 || [string isEqualToString:@"<null>"])
    {
        string = @"";
    }
    return string;
}


- (NSString *)removeSpecialCharacterFromString:(NSString *)string
{
   
    string = [string stringByReplacingOccurrencesOfString:@" +" withString:@" "options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
    string = (NSString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\"" options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
    return string;
}


- (NSString *)setMASKPhoneNumberFromString:(NSString *)string
{
    
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
    NSArray *stringComponents = [NSArray arrayWithObjects:[string substringWithRange:NSMakeRange(0, 3)],
                                 [string substringWithRange:NSMakeRange(3, 3)],
                                 [string substringWithRange:NSMakeRange(6, [string length]-6)], nil];
    string = [NSString stringWithFormat:@"(%@) %@-%@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2]];
    return string;
}


-(NSString*)contentsInParenthesis:(NSString *)string
{
    NSString *subString = nil;
    NSRange range1 = [string rangeOfString:@"("];
    NSRange range2 = [string rangeOfString:@")"];
    if ((range1.length == 1) && (range2.length == 1) && (range2.location > range1.location))
    {
        NSRange range3;
        range3.location = range1.location+1;
        range3.length = (range2.location - range1.location)-1;
        subString = [string substringWithRange:range3];
    }
    return subString;
}


-(NSString*)dayCount:(NSString *)string
{
    NSString *start = [NSString stringWithString:string];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:start];
    NSDate *endDate = [NSDate date];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    NSString *result = [NSString stringWithFormat:@"%ld",(long)[components day]];
    return result;
}


//- (NSString *)restrictLengthofString:(NSString *)string toLength:(int)maxLength inRange:(NSRange)range
//{
//    NSUInteger oldLength = [string length];
//    NSUInteger replacementLength = [string length];
//    NSUInteger rangeLength = range.length;
//    
//    NSUInteger newLength = oldLength - rangeLength + replacementLength;
//    
//    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
//    
//    return newLength <= maxLength || returnKey;
//}


//-(NSString*)formatNumber:(NSString*)mobileNumber
//{
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
//    
//    
//    int length = [mobileNumber length];
//    if(length > 10)
//    {
//        mobileNumber = [mobileNumber substringFromIndex: length-10];
//        
//        
//    }
//    
//    
//    return mobileNumber;
//}
//
//
//-(int)getLength:(NSString*)mobileNumber
//{
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
//    
//    int length = [mobileNumber length];
//    
//    return length;
//}

- (NSString *)urlencode
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int) strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' ')
        {
            [output appendString:@"+"];
        }
        else if (thisChar == '@')
        {
            [output appendString:@"@"];
        }
        else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        }
        else
        {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}


- (NSInteger)accountClosedUser:(NSString *)startDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDay = [dateFormat dateFromString:startDate];
    NSDate *endDate = [NSDate date];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDay
                                                          toDate:endDate
                                                         options:0];
    
    
    NSLog(@"%ld", (long)[components day]);
    
    return (long)[components day];
    
}

-(NSString *)convertHTML:(NSString *)html
{
   @try
   {
      NSScanner *myScanner;
      NSString *text = nil;
      myScanner = [NSScanner scannerWithString:html];
      
      while ([myScanner isAtEnd] == NO)
      {
         [myScanner scanUpToString:@"<" intoString:NULL];
         
         [myScanner scanUpToString:@">" intoString:&text];
         
         html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@"\n"];
         //            html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
         //            html = [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"''"];
         //            html = [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"''"];
         //            html = [html stringByReplacingOccurrencesOfString:@"&#39;"  withString:@"'"];
         //            html = [html stringByReplacingOccurrencesOfString:@"&ndash;" withString:@""];
         //            html = [html stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
         //            html = [html stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
         //            html = [html stringByReplacingOccurrencesOfString:@"&copy;" withString:@"\u00A9"];
         //            html = [html stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@""];
      }
      html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      
      return html;
   }
   @catch (NSException *exception)
   {
      
   }
   @finally
   {
      
   }
}


@end
