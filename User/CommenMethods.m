//
//  CommenMethods.m
//  Truck
//
//  Created by veena on 1/23/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import "CommenMethods.h"
#import <sys/utsname.h>
#import "Constants.h"
#import "AppDelegate.h"
#import "PaymentsViewController.h"
#import "ViewController.h"

@implementation CommenMethods


+(void)setObject:(NSString*)str1 forKey:(NSString*)str2
{
    
}

+ (void)customSetupuibarBtn:(UIBarButtonItem*)barBtn naviController:(UIViewController*)navi;
{

}

+(NSString*)getUserDefaultsKey:(NSString*)str
{
    NSString*deviceType=[[NSUserDefaults standardUserDefaults ]objectForKey:str];
    return deviceType;
}
+(void)setUserDefaultsObject:( NSString*)str key:(NSString*)str1
{
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:str1];
}
+(UIImage*)getUserDefaultsKeyImage:(UIImage*)str
{
    UIImage*deviceType=[[NSUserDefaults standardUserDefaults ]objectForKey:str];
    return deviceType;
}
+(void)setUserDefaultsObjectImage:( UIImage*)str key:(NSString*)str1
{
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:str1];
}

+(NSString*) deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
    
}
+(void)bottomLine:(UITextField*)txtFld;
{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor=[[UIColor colorWithRed:.176f green:.682f blue:.756f alpha:1] CGColor];
    [txtFld setBorderStyle:UITextBorderStyleNone];
    border.frame = CGRectMake(0, txtFld.frame.size.height - borderWidth, txtFld.frame.size.width, txtFld.frame.size.height);
    border.borderWidth = borderWidth;
    //    [txtFld setFont:[UIFont fontWithName:@"Exo2-Bold" size:17]];
    [txtFld.layer addSublayer:border];
    txtFld.layer.masksToBounds = YES;
}

+(void)bottomLineBtn:(UIButton*)btn;
{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    // border.borderColor = [UIColor darkGrayColor].CGColor;
    border.borderColor=[[UIColor colorWithRed:.176f green:.682f blue:.756f alpha:1] CGColor];
    // [btn setBorderStyle:uite];
    border.frame = CGRectMake(0, btn.frame.size.height - borderWidth, btn.frame.size.width, btn.frame.size.height);
    border.borderWidth = borderWidth;
    [btn.layer addSublayer:border];
    btn.layer.masksToBounds = YES;
    
}

+(void)bottomLineForSegBtn
{
    
    
}
+(void)roundedEdgesTxtFld:(UITextField*)txtfld;
{
    txtfld.layer.cornerRadius=10;
    txtfld.clipsToBounds=YES;
}


+(void)roundedEdgesImgV:(UIImageView*)img;
{
    img.layer.cornerRadius = 10; // this value vary as per your desire
    img.clipsToBounds = YES;
}

+(void)roundedEdgesBtn:(UIButton*)btn;
{
    btn.layer.cornerRadius=3;
    btn.clipsToBounds=YES;
    
}
+(void)cellroundedEdgesImg:(UIImageView*)btn;
{
    btn.layer.cornerRadius=30;
    btn.clipsToBounds=YES;
    
}
+(void)roundBtn:(UIButton*)btn;
{
    btn.layer.cornerRadius=50;
    btn.clipsToBounds=YES;
    
}

+(void)roundImgView:(UIImageView*)btn;
{
    btn.layer.cornerRadius=50;
    btn.clipsToBounds=YES;
    
}
+(void)roundImgViewMed:(UIImageView*)btn;
{
    btn.layer.cornerRadius=30;
    btn.clipsToBounds=YES;
    
}
+(void)blueBackgroundcolorBtn:(UIButton*)btn
{
    //    btn.backgroundColor = Rgb2UIColor(14, 72, 89);
    btn.backgroundColor = Rgb2UIColor(0, 0, 0);
    
    
}
+(void)ornageBackgroundcolorBtn:(UIButton*)btn
{
    //    btn.backgroundColor = Rgb2UIColor(245, 151, 51);
    btn.backgroundColor = Rgb2UIColor(33, 159, 181);
    
    
}
+(void)themeBackgroundcolorBtn:(UIButton*)btn
{
    btn.backgroundColor = Rgb2UIColor(45 , 174, 193);
    
}
+(void)storyboard:(UIStoryboard*)storyboard viewcontroller: (UIViewController*)VC identifier:(NSString*)strObj cviewcontroller:(UIViewController*)cvobj
{
    
    VC=[storyboard instantiateViewControllerWithIdentifier:strObj];
    [[cvobj navigationController]pushViewController:VC animated:YES];
    
}
+(void)nslogcheck:(NSString *)str
{
    BOOL check=YES;
    if (check) {
        NSLog(@"%@",str);
    }
    
}
+(void)textview:(UITextView*)txtview
{
    
    // [[txtview layer] setBorderColor:[[UIColor colorWithRed:.176f green:.682f blue:.756f alpha:1]CGColor]];
    [[txtview layer] setBorderColor:[[UIColor colorWithRed:17.6f green:68.2f blue:75.6f alpha:1]CGColor]];
    
    // [[txtview layer] setBorderColor:CFBridgingRetain([UIColor whiteColor])];
    
    [[txtview layer] setBorderWidth:2];
    //  [[txtview layer] setBorderStyle:UITextBorderStyleNone];
    
    
    txtview.textContainer.maximumNumberOfLines = 2;
    txtview.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
}
+(void)alertviewController_title:(NSString*)title MessageAlert:(NSString*)msg viewController:(UIViewController*)view okPop:(BOOL)pop
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    if (pop) {
                                        
                                        //Handle your yes please button action here
                                }
                                }];
    
    [alert addAction:yesButton];
    //    [alert addAction:noButton];
    
    [view presentViewController:alert animated:YES completion:nil];
    
}

+(void)Msglog:(NSString *)mesg nslog:(NSString*)log
{
    BOOL check=YES;
    if (check) {
        NSLog(@"%@>>>>>>>>>>>%@",mesg,log);
    }
}

+(void) onRefreshToken
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate internetConnected])
    {
//        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//        NSDictionary * params=@{@"grant_type":@"refresh_token",@"client_id":ClientID,@"client_secret":Client_SECRET,@"refresh_token":[user valueForKey:UD_REFERSH_TOKEN],@"scope":@""};
//        
//        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
//        
//        [afn getDataFromPath:MD_LOGIN withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
//            if (response)
//            {
//                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//                [user setValue:response[@"token_type"] forKey:UD_TOKEN_TYPE];
//                [user setValue:response[@"access_token"] forKey:UD_ACCESS_TOKEN];
//                [user setValue:response[@"refresh_token"] forKey:UD_REFERSH_TOKEN];
//                [user synchronize];
//            }
//            else
//            {
//                
//            }
//            
//        }];

    }    
}
@end
