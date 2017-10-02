//
//  ChangePasswordViewController.h
//  Provider
//
//  Created by iCOMPUTERS on 01/02/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LoadingViewClass.h"

@class AppDelegate;
@interface ChangePasswordViewController : UIViewController<UIGestureRecognizerDelegate>
{
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UILabel *helpLbl;
@property (weak, nonatomic) IBOutlet UILabel *passLbl;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UILabel *confirmPassLbl;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassText;

@property (weak, nonatomic) IBOutlet UILabel *oldPassLbl;
@property (weak, nonatomic) IBOutlet UITextField *oldPassText;

@property (weak, nonatomic) IBOutlet UIButton *changePasswordBtn;
@end
