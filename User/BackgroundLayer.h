//
//  BackgroundLayer.h
//  SPANPLAN
//
//  Created by SPAN TECHNOLOGY on 24/12/12.
//  Copyright (c) 2012 SPAN TECHNOLOGY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface BackgroundLayer : NSObject

+(CAGradientLayer*) greyGradient;
+(CAGradientLayer*) blueGradient;
+(CAGradientLayer*) titleBarGradient;
+(CAGradientLayer*) BtnGradient;
+(CAGradientLayer*) navigationBtnGradient;
+(CAGradientLayer*) backBtnGradient;
+(CAGradientLayer*) backgroundGradient;
+(CAGradientLayer*) TableSectionHeader;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(CAGradientLayer*) TableSelectionColor;

+ (CAGradientLayer*) skuView1Gradient;
+ (CAGradientLayer*) skuView2Gradient;
+ (CAGradientLayer*) skuView3Gradient;
+ (CAGradientLayer*) buttonGradient;
@end
