//
//  SocailMediaViewController.m
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "SocailMediaViewController.h"
#import "config.h"
#import "CSS_Class.h"
#import "AFNHelper.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "Utilities.h"
#import "ViewController.h"
#import "Colors.h"


@interface SocailMediaViewController ()
{
    NSString *UDID_Identifier;
}
@end

@implementation SocailMediaViewController
{
    AKFAccountKit *_accountKit;
    UIViewController<AKFViewController> *_pendingLoginViewController;
    NSString *_authorizationCode;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    phoneNumberStr =@"";
    [self setDesignStyles];
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    UDID_Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    // Do any additional setup after loading the view.
    
    // initialize Account Kit
    if (_accountKit == nil) {
        // may also specify AKFResponseTypeAccessToken
        _accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
    }
    
    // view controller for resuming login
    _pendingLoginViewController = [_accountKit viewControllerForLoginResume];
    
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
            phoneNumberStr =[[account phoneNumber] stringRepresentation];
        }
        
        if([loginByStr isEqualToString:@"FB"])
        {
            [appDelegate onEndLoader];
            [self checkFacebook];
        }
        else if([loginByStr isEqualToString:@"GOOGLE"])
        {
            [appDelegate onEndLoader];
            [self checkGmail];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backBtn:(id)sender
{
    ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)setDesignStyles
{
    [CSS_Class App_subHeader:_headerLbl];
    [CSS_Class App_subHeader:_fbLbl];
    [CSS_Class App_subHeader:_googleLbl];
}


- (IBAction)fbLogin:(id)sender {
    
    if ([appDelegate internetConnected])
    {
        /*********  logout the current session ************/
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
        /*********  logout the current session ************/
        
        /*********  start the new session for login ************/
        
        // FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorWeb;
        [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                // Process error
            } else if (result.isCancelled) {
                // Handle cancellations
            }
            else {
                
                if ([result.grantedPermissions containsObject:@"email"]) {
                    
                    if ([FBSDKAccessToken currentAccessToken]) {
                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"first_name, last_name, picture.type(normal), accounts{username},email, gender, locale, timezone, about"}]
                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                             if (!error) {
                                 NSLog(@"fetched user:%@", result);
                                 
                                 fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                                 NSLog(@"fbAccessToken=>%@", fbAccessToken);
                                 
                                 NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                                 [user setValue:fbAccessToken forKey:@"FB_ACCESSTOKEN"];
                                 loginByStr = @"FB";
                                 [self loginWithPhone:self];

                             }
                         }];
                    }
                }
            }
        }];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT", nil) message:NSLocalizedString(@"CONNECTION", nil)preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)googleLogin:(id)sender {
     [[GIDSignIn sharedInstance] signIn];
}
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    if(!error)
    {
        NSString *userId = user.userID;
        googleAccessToken = user.authentication.accessToken;
        NSLog(@"%@",userId);
        NSLog(@"%@",googleAccessToken);
        loginByStr = @"GOOGLE";
        [self loginWithPhone:self];
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    NSLog(@"Google Error...%@", error);
}

- (void)checkGmail
{
    if ([appDelegate internetConnected])
    {
        [appDelegate onStartLoader];
        
        NSDictionary *params=@{@"accessToken":googleAccessToken, @"device_token":appDelegate.strDeviceToken,@"device_id":UDID_Identifier ,@"device_type":@"ios",@"login_by":@"google",@"mobile":phoneNumberStr};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        
        [afn getDataFromPath:MD_GOOGLE withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            if (response)
        {
            [appDelegate onEndLoader];
            
            NSLog(@"RESPONSE ...%@", response);
            NSString *statusResponse = [response[@"status"]stringValue];
            if ([statusResponse isEqualToString:@"0"])
            {
                
            }
            if ([statusResponse isEqualToString:@"1"])
            {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setValue:response[@"token_type"] forKey:UD_TOKEN_TYPE];
                [user setValue:response[@"access_token"] forKey:UD_ACCESS_TOKEN];
                [user setValue:response[@"currency"] forKey:@"currency"];
                [user setBool:true forKey:@"isLoggedin"];
                [self onGetProfile];
            }
        }
        else{
            NSLog(@"RESPONSE ERROR");
        }
            
        }];
        
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT", nil) message:NSLocalizedString(@"CONNECTION", nil)preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)checkFacebook
{
    if ([appDelegate internetConnected])
    {
        [appDelegate onStartLoader];
        
        NSDictionary *params=@{@"accessToken":fbAccessToken, @"device_token":appDelegate.strDeviceToken,@"device_id":UDID_Identifier , @"device_type":@"ios",@"login_by":@"facebook", @"mobile":phoneNumberStr};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        
        [afn getDataFromPath:MD_FACEBOOK withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            
            NSLog(@"FB CHECK response:%@", response);
            
            NSLog(@"FB CHECK ERROR:%@", error);
            
//            NSString *statusError = [error[@"status"]stringValue];
            
            NSString *statusResponse = [response[@"status"]stringValue];
            
            if ([statusResponse isEqualToString:@"0"])
            {
                
            }
            
            if ([statusResponse isEqualToString:@"1"])
            {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setValue:response[@"token_type"] forKey:UD_TOKEN_TYPE];
                [user setValue:response[@"access_token"] forKey:UD_ACCESS_TOKEN];
                [user setValue:response[@"currency"] forKey:@"currency"];
                [user setBool:true forKey:@"isLoggedin"];
                [self onGetProfile];
            }
        }];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT", nil) message:NSLocalizedString(@"CONNECTION", nil)preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
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
                    
                    //                    [CommenMethods onRefreshToken];
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

@end
