//
//  RegisterViewController.h
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AccountKit/AccountKit.h>
#import <AccountKit/AKFTheme.h>


@interface RegisterViewController : UIViewController<UIGestureRecognizerDelegate, AKFViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *detailsScrollView;

@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UITextField *firstNameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UITextField *lastNameText;
@property (strong, nonatomic) IBOutlet UITextField *phoneText;


@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *passwordLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;



@end
