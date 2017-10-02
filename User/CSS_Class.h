//
//  CSS_Class.h
//  TruckLogics
//
//  Created by STS-Manoj on 8/18/15.
//  Copyright (c) 2015 SPAN Technology Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CSS_Class : NSObject
{
    
}

+ (void)App_Header:(UILabel *)label;
+ (void)App_subHeader:(UILabel *)label;
+ (void)APP_labelName:(UILabel *)label;
+ (void)APP_labelName_Small:(UILabel *)label;
+ (void)APP_fieldValue:(UILabel *)label;
+ (void)APP_fieldValue_Small:(UILabel *)label;
+ (void)APP_Blackbutton:(UIButton *)button;
+ (void)APP_textfield_Infocus:(UITextField *)textField;
+ (void)APP_textfield_Outfocus:(UITextField *)textField;
+ (void)APP_textView_Outfocus:(UITextView *)textView;
+ (void)APP_textView_Infocus:(UITextView *)textView;
+ (void)APP_SocialLabelName:(UILabel *)label;
+ (void)APP_SmallText:(UILabel *)label;



@end
