//
//  RegisterViewController.m
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "RegisterViewController.h"
#import "CSS_Class.h"
#import "EmailViewController.h"
#import "config.h"
#import "UIScrollView+EKKeyboardAvoiding.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "CommenMethods.h"
#import "ViewController.h"
#import "Utilities.h"
#import "Colors.h"

@interface RegisterViewController ()
{
    AppDelegate *appDelegate;
    NSString *strLoginType;
}

@end

@implementation RegisterViewController
{
    AKFAccountKit *_accountKit;
    UIViewController<AKFViewController> *_pendingLoginViewController;
    NSString *_authorizationCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    // initialize Account Kit
    if (_accountKit == nil) {
        // may also specify AKFResponseTypeAccessToken
        _accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
    }
    
    // view controller for resuming login
    _pendingLoginViewController = [_accountKit viewControllerForLoginResume];
    
    
    strLoginType=@"manual";
    
    _emailText.text=appDelegate.strEmail;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [_detailsScrollView setContentSize:[_detailsScrollView frame].size];
    [_detailsScrollView setKeyboardAvoidingEnabled:YES];
    
    [self setDesignStyles];
}

- (void)_prepareLoginViewController:(UIViewController<AKFViewController> *)loginViewController
{
    loginViewController.delegate = self;
    // Optionally, you may use the Advanced UI Manager or set a theme to customize the UI.
    loginViewController.uiManager = [[AKFSkinManager alloc]
                                     initWithSkinType:AKFSkinTypeTranslucent
                                     primaryColor:BLACKCOLOR
                                     backgroundImage:[UIImage imageNamed:@"bg-1536"]
                                     backgroundTint:AKFBackgroundTintBlack
                                     tintIntensity:0.32];
    loginViewController.uiManager.theme.buttonTextColor = [UIColor whiteColor];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loginWithPhone:(id)sender
{
    NSString *inputState = [[NSUUID UUID] UUIDString];
    UIViewController<AKFViewController> *viewController = [_accountKit viewControllerForPhoneLoginWithPhoneNumber:nil state:inputState];
    viewController.enableSendToFacebook = YES; // defaults to NO
    [self _prepareLoginViewController:viewController]; // see below
    [self presentViewController:viewController animated:YES completion:NULL];
}

- (void) viewController:(UIViewController<AKFViewController> *)viewController
            didCompleteLoginWithAccessToken:(id<AKFAccessToken>)accessToken state:(NSString *)state
{
//    [self proceedToMainScreen];
    
    AKFAccountKit *accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
    [accountKit requestAccount:^(id<AKFAccount> account, NSError *error) {
        // account ID
        
        [appDelegate onStartLoader];
        
        NSLog(@"accountID ... %@",account.accountID);
        if ([account.emailAddress length] > 0) {
            NSLog(@"accountID ... %@",account.emailAddress);
        }
        else if ([account phoneNumber] != nil) {
            NSLog(@"accountID ... %@",[[account phoneNumber] stringRepresentation]);
            _phoneText.text =[[account phoneNumber] stringRepresentation];
        }
        
        if([appDelegate internetConnected])
        {
            NSString* UDID_Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
            NSLog(@"output is : %@", UDID_Identifier);
            
            NSDictionary*params;
            if([strLoginType isEqualToString:@"manual"])
            {
                params=@{@"email":_emailText.text,@"password":_passwordText.text,@"first_name":_firstNameText.text,@"last_name":_lastNameText.text,@"mobile":_phoneText.text,@"device_token":appDelegate.strDeviceToken,@"login_by":strLoginType,@"device_type":@"ios", @"device_id":UDID_Identifier};
            }
            //        else
            //        {
            //            params=@{@"email":_txtEmail.text,@"password":_txtPassword.text,@"first_name":_txtFirstName.text,@"last_name":_txtLastName.text,@"mobile":_txtPhnNo.text,@"device_token":appDelegate.strDeviceToken,@"login_by":strLoginType,@"device_type":@"ios",@"social_unique_id":strSocialUniqueID};
            //        }
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:MD_REGISTER withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
                [appDelegate onEndLoader];
                if(response)
                {
                    [self onLogin];
                }
                else
                {
                    if ([strCode intValue]==1)
                    {
                        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                    }
                    else
                    {
                        if ([Error objectForKey:@"email"]) {
                            [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                        }
                        else if ([Error objectForKey:@"first_name"]) {
                            [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"first_name"] objectAtIndex:0]  viewController:self okPop:NO];
                        }
                        else if ([Error objectForKey:@"last_name"]) {
                            [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"last_name"] objectAtIndex:0]  viewController:self okPop:NO];
                        }
                        else if ([Error objectForKey:@"mobile"]) {
                            [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"mobile"] objectAtIndex:0]  viewController:self okPop:NO];
                        }
                        else if ([Error objectForKey:@"password"]) {
                            [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                        }
                    }
                    
                }
            }];
        }
        else
        {
            
            [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
        }
    }];
    [accountKit logOut];
}

- (void)                 viewController:(UIViewController<AKFViewController> *)viewController
  didCompleteLoginWithAuthorizationCode:(NSString *)code
                                  state:(NSString *)state
{
    
}

- (void)viewController:(UIViewController<AKFViewController> *)viewController didFailWithError:(NSError *)error
{
    // ... implement appropriate error handling ...
    NSLog(@"%@ did fail with error: %@", viewController, error);
}

- (void)viewControllerDidCancel:(UIViewController<AKFViewController> *)viewController
{
    // ... handle user cancellation of the login process ...
}

-(void)setDesignStyles
{
    [CSS_Class APP_labelName:_headerLbl];
    [CSS_Class APP_textfield_Outfocus:_emailText];
    [CSS_Class APP_textfield_Outfocus:_firstNameText];
    
    [CSS_Class APP_textfield_Outfocus:_lastNameText];
    [CSS_Class APP_textfield_Outfocus:_passwordText];
    [CSS_Class APP_textfield_Outfocus:_phoneText];
    
    [CSS_Class APP_labelName_Small:_emailLbl];
    [CSS_Class APP_labelName_Small:_firstNameLbl];
    [CSS_Class APP_labelName_Small:_lastNameLbl];
    [CSS_Class APP_labelName_Small:_passwordLbl];
    [CSS_Class APP_labelName_Small:_phoneLbl];
    
}

-(IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //    EmailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailViewController"];
    //    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_emailText)
    {
        [self emailValidateMethod];
        
    }
    else if(textField==_firstNameText)
    {
        [_lastNameText becomeFirstResponder];
    }
    else if(textField==_lastNameText)
    {
        [_passwordText becomeFirstResponder];
    }
    else if(textField==_passwordText)
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
    
    if(textField == _emailText)
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= INPUTLENGTH || returnKey;
    }
    else if ((textField == _firstNameText) || (textField == _lastNameText))
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if (textField == _phoneText)
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= PHONELENGTH || returnKey;
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
    if(textField==_emailText)
    {
        [self emailValidateMethod];
    }
    [CSS_Class APP_textfield_Outfocus:textField];
    return YES;
}

-(IBAction)Nextbtn:(id)sender
{
    [self.view endEditing:YES];
    
    if((_emailText.text.length==0) || (_firstNameText.text.length==0) ||(_passwordText.text.length==0) || (_lastNameText.text.length==0))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT", nil) message:NSLocalizedString(@"VALIDATE", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        [self loginWithPhone:self];
    }
}

-(void)emailValidateMethod
{
    if([appDelegate internetConnected])
    {
        NSDictionary * params=@{@"email":_emailText.text};
        
        [appDelegate onStartLoader];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:MD_EMAILVERIFY withParamData:params withBlock:^(id response, NSDictionary *Error,NSString *strCode) {
            [appDelegate onEndLoader];
            if(response)
            {
                NSLog(@"EmailVAlid ..%@", response);
                [_firstNameText becomeFirstResponder];
            }
            else
            {
                if ([strCode intValue]==1)
                {
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else
                {
                    if ([Error objectForKey:@"email"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else if ([Error objectForKey:@"password"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                }
                
            }
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
}


-(void)onLogin
{
    if([appDelegate internetConnected])
    {
        NSDictionary * params=@{@"username":_emailText.text,@"password":_passwordText.text,@"device_token":appDelegate.strDeviceToken,@"grant_type":@"password",@"device_type":@"ios",@"client_id":ClientID,@"client_secret":Client_SECRET};
        
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
                
//                HomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
//                [self.navigationController pushViewController:controller animated:YES];
                
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
                    if ([Error objectForKey:@"email"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else if ([Error objectForKey:@"password"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[Error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                }
                
            }
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
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
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_IMG];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_NAME];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_TOKEN_TYPE];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_ACCESS_TOKEN];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_REFERSH_TOKEN];
//                    
//                    ViewController *viewCont = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                    [self.navigationController pushViewController:viewCont animated:YES];
                    
                    [self logoutMethod];
                    
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




@end
