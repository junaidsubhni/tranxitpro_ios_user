//
//  PasswordViewController.m
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "PasswordViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "HomeViewController.h"
#import "ForgotPasswordViewController.h"
#import "RegisterViewController.h"
#import "Constants.h"
#import "AFNHelper.h"
#import "AppDelegate.h"
#import "CommenMethods.h"
#import "Utilities.h"
#import "ViewController.h"

@interface PasswordViewController ()
{
    AppDelegate *appDelegate;
}

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    [self setDesignStyles];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
//    [_passwordText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

-(void)setDesignStyles
{
    [CSS_Class APP_labelName:_helpLbl];
    [CSS_Class APP_textfield_Outfocus:_passwordText];
    
    [CSS_Class APP_SocialLabelName:_password_Lbl];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_passwordText)
    {
        [_passwordText resignFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField == _passwordText)
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= PASSWORDLENGTH || returnKey;
    }
    else
    {
        return YES;
    }
    
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [CSS_Class APP_textfield_Infocus:textField];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [CSS_Class APP_textfield_Outfocus:textField];
    return YES;
}

-(IBAction)Nextbtn:(id)sender
{
    [self.view endEditing:YES];
    
    if(_passwordText.text.length==0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:NSLocalizedString(@"PWD_REQ", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if(_passwordText.text.length <= 5)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"The password must be greater than 6 characters" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        if([appDelegate internetConnected])
        {
          NSDictionary * params=@{@"username":appDelegate.strEmail,@"password":_passwordText.text,@"device_token":appDelegate.strDeviceToken,@"grant_type":@"password",@"device_type":@"ios",@"client_id":ClientID,@"client_secret":Client_SECRET};
           
            [appDelegate onStartLoader];
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:MD_LOGIN withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
                [appDelegate onEndLoader];
                if(response)
                {
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    [user setValue:response[@"token_type"] forKey:UD_TOKEN_TYPE];
                    [user setValue:response[@"access_token"] forKey:UD_ACCESS_TOKEN];
                    [user setValue:response[@"refresh_token"] forKey:UD_REFERSH_TOKEN];
                    [user setValue:@"" forKey:UD_SOCIAL];
                    
                    [user setBool:true forKey:@"isLoggedin"];
                    [user synchronize];
                  
//                    HomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
//                    [self.navigationController pushViewController:controller animated:YES];
                    [self onGetProfile];
                }
                else
                {
                    if ([strCode intValue]==1)
                    {
                        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                    }
                    else
                    {
                        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"LOGIN_ERROR", nil)   viewController:self okPop:NO];
                    }
                }
            }];
        }
        else
        {
            [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
        }
        
    }
}


-(void)onGetProfile
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:MD_GETPROFILE withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                NSLog(@"GET PROFILE....%@", response);
                                
                    NSString *strProfile=[Utilities removeNullFromString:response[@"picture"]];
                    NSString *socialIdStr = [Utilities removeNullFromString:[response valueForKey:@"social_unique_id"]];
                    
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    [user setValue:strProfile forKey:UD_PROFILE_IMG];
                    [user setValue:socialIdStr forKey:UD_SOCIAL];
                    [user setValue:[response valueForKey:@"id"] forKey:UD_ID];
                    [user setValue:[response valueForKey:@"sos"] forKey:UD_SOS];
                
                    NSString *nameStr = [NSString stringWithFormat:@"%@ %@", [Utilities removeNullFromString: response[@"first_name"]], [Utilities removeNullFromString: response[@"last_name"]]];
                
                    [user setValue:nameStr forKey:UD_PROFILE_NAME];
                    
                    HomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                if ([errorcode intValue]==1)
                {
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else if ([errorcode intValue]==3)
                {
                    
                    [self logoutMethod];
                    
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_IMG];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_NAME];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_TOKEN_TYPE];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_ACCESS_TOKEN];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_REFERSH_TOKEN];
//                    
//                    ViewController *viewCont = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                    [self.navigationController pushViewController:viewCont animated:YES];
                }
            }
            
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
}

-(void)logoutMethod
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        
        [afn refreshMethod_NoLoader:MD_REFRESH_TOKEN withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            if (response)
            {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setValue:response[@"token_type"] forKey:UD_TOKEN_TYPE];
                [user setValue:response[@"access_token"] forKey:UD_ACCESS_TOKEN];
                [user setValue:response[@"refresh_token"] forKey:UD_REFERSH_TOKEN];
            }
            else
            {
                [CommenMethods alertviewController_title:@"Alert" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
            }
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"Alert" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
}


-(IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)passwordbtn:(id)sender
{
    ForgotPasswordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}


- (IBAction)ShowPass:(UIButton *)sender
{
    if (self.passwordText.secureTextEntry == YES)
    {
        self.passwordText.secureTextEntry = NO;
    }
    else
    {
        self.passwordText.secureTextEntry = YES;
    }
}


@end
