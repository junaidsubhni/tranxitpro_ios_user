//
//  SocailMediaViewController.h
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import "AppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AccountKit/AccountKit.h>
#import <AccountKit/AKFTheme.h>


@interface SocailMediaViewController : UIViewController<GIDSignInDelegate, GIDSignInUIDelegate, AKFViewControllerDelegate>
{
    NSString *googleAccessToken, *phoneNumberStr;
    AppDelegate *appDelegate;
    NSString *fbAccessToken, *loginByStr;
}

@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UILabel *googleLbl;
@property (weak, nonatomic) IBOutlet UILabel *fbLbl;

@end
