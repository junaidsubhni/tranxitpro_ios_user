//
//  WalletViewController.h
//  Provider
//
//  Created by iCOMPUTERS on 14/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PaymentsViewController.h"

@interface WalletViewController : UIViewController<UIGestureRecognizerDelegate, CardDetailsSend>
{
    UIView *waitingBGView;
    AppDelegate *appDelegate;
    NSString *strCardID, *strCardLastNo;
}

@property (weak, nonatomic) IBOutlet UILabel *walletLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *enterAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *cardLbl;
@property (weak, nonatomic) IBOutlet UIButton *addMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *walletBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UIView *commonRateView;
@property (strong, nonatomic) IBOutlet UITextField *amountText;

@end
