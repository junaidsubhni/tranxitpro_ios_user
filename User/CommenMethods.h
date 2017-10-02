//
//  CommenMethods.h
//  Truck
//
//  Created by veena on 1/23/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoadingViewClass.h"
#import "AFNHelper.h"

@class LoadingViewClass;
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]


@interface CommenMethods : NSObject

+(void)roundedEdgesImgV:(UIImageView*)img;

+(void)bottomLine:(UITextField*)txtFld;
+(void)roundedEdgesTxtFld:(UITextField*)txtfld;

+(void)roundBtn:(UIButton*)btn;

+(void)roundedEdgesBtn:(UIButton*)btn;
+(void)blueBackgroundcolorBtn:(UIButton*)btn;
+(void)ornageBackgroundcolorBtn:(UIButton*)btn;
+(void)themeBackgroundcolorBtn:(UIButton*)btn;
+(void)bottomLineBtn:(UIButton*)btn;
+(void)roundImgView:(UIImageView*)btn;

+(void)cellroundedEdgesImg:(UIImageView*)btn;


+(void)textview:(UITextView*)txtview;


+(void)storyboard:(UIStoryboard*)storyboard viewcontroller: (UIViewController*)VC identifier:(NSString*)strObj cviewcontroller:(UIViewController*)cvobj;

+(void)nslogcheck:(NSString *)str;
+(NSString*) deviceName;

+(NSString*)strurl:(NSString*)url fullUrlTokenId:(NSString *)tokenName :(NSString *)identifier;
+(void)alertviewController_title:(NSString*)title MessageAlert:(NSString*)msg viewController:(UIViewController*)view okPop:(BOOL)pop;
+ (void)customSetupuibarBtn:(UIBarButtonItem*)barBtn naviController:(UIViewController*)navi;

+(NSString*)getUserDefaultsKey:(NSString*)str;
+(void)setUserDefaultsObject:( NSString*)str key:(NSString*)str1;
//+(void)starRatingView:(UIView*)cview Value:(CGFloat*)fvalue view:(HCSStarRatingView*)starRatingView;
+(void)ratingView:(UIView*)rView currentView:(UIViewController*)cView value:(NSString*)val edit:(BOOL*)edit;
+(void)Msglog:(NSString *)mesg nslog:(NSString*)log;
+(void)roundImgViewMed:(UIImageView*)btn;




+(void) onRefreshToken;


@end
