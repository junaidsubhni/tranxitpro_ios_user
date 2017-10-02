//
//  CreditCardViewController.h
//  User
//
//  Created by iCOMPUTERS on 18/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditCardViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UITextField *cardText;
@property (weak, nonatomic) IBOutlet UITextField *dateText;
@property (weak, nonatomic) IBOutlet UITextField *cvvText;
@property (weak, nonatomic) IBOutlet UITextField *countryText;

@property (weak, nonatomic) IBOutlet UILabel *cardLbl;
@property (weak, nonatomic) IBOutlet UILabel *countryLbl;


@end
