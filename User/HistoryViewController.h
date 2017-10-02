//
//  HistoryViewController.h
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface HistoryViewController : UIViewController<UIGestureRecognizerDelegate>
{
    NSString *id_Str, *strProviderCell;
}

@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *pickLb;
@property (weak, nonatomic) IBOutlet UILabel *dropLb;
@property (weak, nonatomic) IBOutlet UILabel *paymentLb;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *cashLb;
@property (weak, nonatomic) IBOutlet UILabel *commentTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *commentsLb;

@property (weak, nonatomic) IBOutlet UIImageView *mapImg;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UIImageView *payImg;

@property (weak, nonatomic) IBOutlet UILabel *bookingIdLbl;

@property (weak, nonatomic) IBOutlet UIView *commentsView;


//Bottom View
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *receiptBtn;


//Invoice View
@property (weak, nonatomic) IBOutlet UIView *invoiceView;

@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblBacePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTaxPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmt;
@property (weak, nonatomic) IBOutlet UILabel *invoiceIdLbl;

@property (weak, nonatomic) IBOutlet UILabel *invoice_WalletAmt;
@property (weak, nonatomic) IBOutlet UILabel *invoice_discountAmt;

@property (weak, nonatomic) NSString *historyHintStr,*strID;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *userRating;
@end
