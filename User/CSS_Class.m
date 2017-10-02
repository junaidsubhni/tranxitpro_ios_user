//
//  CSS_Class.m
//  TruckLogics
//
//  Created by STS-Manoj on 8/18/15.
//  Copyright (c) 2015 SPAN Technology Services. All rights reserved.
//

#import "CSS_Class.h"
#import "config.h"
#import "BackgroundLayer.h"
#import "Colors.h"

@implementation CSS_Class
{
    
}

#pragma mark - Labels - methods

+ (void)App_Header:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGB(255, 255, 255);
    [label setFont:[UIFont fontWithName:@"ClanPro-NarrNews" size:30]];
}
+ (void)App_subHeader:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:22]];
}
+ (void)APP_labelName:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:16]];
}

+ (void)APP_SocialLabelName:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = BLUECOLOR_TEXT;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:16]];
}

+ (void)APP_labelName_Small:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:12]];
}

+ (void)APP_fieldValue:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:16]];
}
+ (void)APP_fieldValue_Small:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:12]];
}

+ (void)APP_SmallText:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXTCOLOR_LIGHT;
    [label setFont:[UIFont fontWithName:@"ClanPro-Book" size:10]];
}

#pragma mark - Buttons - methods

+ (void)APP_Blackbutton:(UIButton *)button
{
    button.titleLabel.font = [UIFont fontWithName:@"ClanPro-NarrMedium" size:16];
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, 40);
    button.layer.cornerRadius = 5.0f;
    
    [button setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
    [button setTitleColor:RGB(255,255,255) forState:UIControlStateSelected];
    [button.titleLabel.text uppercaseString];
    button.clipsToBounds = NO;
    button.backgroundColor = BLACKCOLOR;
}

#pragma mark - TextField - methods


+ (void)APP_textfield_Infocus:(UITextField *)textField
{
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.font=[UIFont fontWithName:@"ClanPro-Book" size:16];
    
    textField.textColor = TEXTCOLOR_LIGHT;
    textField.backgroundColor = [UIColor clearColor];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = BLACKCOLOR.CGColor;
    [textField.layer addSublayer:bottomBorder];
}


+ (void)APP_textfield_Outfocus:(UITextField *)textField
{
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.font=[UIFont fontWithName:@"ClanPro-Book" size:16];
    
    textField.textColor = TEXTCOLOR_LIGHT;
    textField.backgroundColor = [UIColor clearColor];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = RGB(200, 200, 200).CGColor;
    [textField.layer addSublayer:bottomBorder];
}


+ (void)APP_textView_Outfocus:(UITextView *)textView
{
    textView.textColor = TEXTCOLOR_LIGHT;
    textView.font=[UIFont fontWithName:@"ClanPro-Book" size:16];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 2.5;
    
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = BLACKCOLOR.CGColor;
}


+ (void)APP_textView_Infocus:(UITextView *)textView
{
    textView.textColor = TEXTCOLOR_LIGHT;
    
    textView.font=[UIFont fontWithName:@"ClanPro-Book" size:16];
    
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 2.5;
    
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = TEXTCOLOR_LIGHT.CGColor;
}


@end
