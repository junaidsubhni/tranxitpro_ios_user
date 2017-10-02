//
//  BackgroundLayer.h
//  SPANPLAN
//
//  Created by SPAN TECHNOLOGY on 24/12/12.
//  Copyright (c) 2012 SPAN TECHNOLOGY. All rights reserved.
//

#import "BackgroundLayer.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation BackgroundLayer

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
	
	UIColor *colorOne		= [UIColor colorWithWhite:0.9 alpha:1.0];
	UIColor *colorTwo		= [UIColor colorWithHue:0.625 saturation:3.0 brightness:0.85 alpha:1.0];
	UIColor *colorThree	    = [UIColor colorWithHue:0.625 saturation:6.0 brightness:0.7 alpha:1.0];
	UIColor *colorFour		= [UIColor colorWithHue:0.625 saturation:9.0 brightness:0.4 alpha:1.0];
    
	NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
	
	NSNumber *stopOne		= [NSNumber numberWithFloat:0.0];
	NSNumber *stopTwo		= [NSNumber numberWithFloat:0.02];
	NSNumber *stopThree	    = [NSNumber numberWithFloat:0.99];
	NSNumber *stopFour		= [NSNumber numberWithFloat:1.0];
	
	NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
	
	CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
}

//Blue gradient background
+ (CAGradientLayer*) blueGradient
{
    UIColor *colorOne = [UIColor colorWithRed:1 green:0.753 blue:0.004 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:1  green:0.424  blue:0  alpha:1.0];

    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
    
    	
	return headerLayer;
                       
}
+ (CAGradientLayer*) titleBarGradient
{
    UIColor *colorOne = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:243.0/255.0 green:249.0/255.0 blue:254.0/255.0 alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
    
}

+ (CAGradientLayer*) BtnGradient
{
    UIColor *colorOne = [UIColor colorWithRed:64.0/255 green:197.0/255 blue:56.0/255 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:31.0/255.0 green:171.0/255.0 blue:29.0/255.0 alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
}

+ (CAGradientLayer*) navigationBtnGradient
{
    UIColor *colorOne = [UIColor colorWithRed:253.0/255 green:119.0/255 blue:7.0/255 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:210.0/255.0 green:110.0/255.0 blue:23.0/255.0 alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
    
}

+ (CAGradientLayer*) backBtnGradient
{
    UIColor *colorOne = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:123.0/255.0 green:123.0/255.0 blue:123.0/255.0 alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
    
}

+ (CAGradientLayer*) TableSelectionColor
{
    UIColor *colorOne = RGB(210, 210, 210);
    UIColor *colorTwo =  RGB(80, 80, 80);
    
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
    
    [headerLayer setStartPoint:CGPointMake(0, 0)];
    [headerLayer setEndPoint:CGPointMake(1, 0)];
    
	return headerLayer;
    
}


+ (CAGradientLayer*) backgroundGradient
{
    UIColor *colorOne = [UIColor colorWithRed:7.0f/255.0f green:44.0f/255.0f blue:109.0f/255.0f alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:41.0f/255.0f  green:88.0f/255.0f  blue:166.0f/255.0f alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
}

+ (CAGradientLayer*) TableSectionHeader
{
    UIColor *colorOne = RGB(49, 49, 49);
    UIColor *colorTwo = RGB(19, 19, 19);
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
    
}


+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
    
}


+ (CAGradientLayer*) skuView1Gradient
{
    UIColor *colorOne = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:251.0/255.0 green:242.0/255.0 blue:200.0/255.0 alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
    
}
+ (CAGradientLayer*) skuView2Gradient
{
    UIColor *colorOne = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:210.0/255.0 green:232.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
    
}
+ (CAGradientLayer*) skuView3Gradient
{
    UIColor *colorOne = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:210.0/255.0 alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
    
}
+ (CAGradientLayer*) buttonGradient
{
    UIColor *colorOne = [UIColor colorWithRed:240.0/255.0 green:213.0/255.0 blue:126.0/255.0 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:215.0/255.0 green:121.0/255.0 blue:32.0/255.0 alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
}
@end
