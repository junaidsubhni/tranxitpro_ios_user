//
//  ProfileViewController.h
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *detailsScrollView;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLb;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *carNameLb;
@property (weak, nonatomic) IBOutlet UILabel *carNumLb;
@property (weak, nonatomic) IBOutlet UILabel *emailtLb;
@property (weak, nonatomic) IBOutlet UILabel *emailValueLb;
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;

@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *carNumText;
@property (weak, nonatomic) IBOutlet UITextField *carNameText;
@property (weak, nonatomic) IBOutlet UIButton *btnProfilePic;
- (IBAction)onChangePwd:(id)sender;

-(IBAction)onProfilePic:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *changePassBtn;
@end
