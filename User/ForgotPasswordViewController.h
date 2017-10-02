//
//  ForgotPasswordViewController.h
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController<UIGestureRecognizerDelegate, UITextFieldDelegate>
{
    NSString *strOtp;
}

@property (weak, nonatomic) IBOutlet UILabel *helpLbl;
@property (weak, nonatomic) IBOutlet UILabel *passLbl;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UILabel *confirmPassLbl;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassText;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *OtpText;


@property (weak, nonatomic) IBOutlet UIButton *changePasswordBtn;
@end
