//
//  PaymentsViewController.h
//  User
//
//  Created by iCOMPUTERS on 18/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardDetailsSend;

@protocol CardDetailsSend <NSObject>
-(void)onChangePaymentMode :(NSDictionary *) choosedPayment;
@end

@interface PaymentsViewController : UIViewController
{
  //  NSMutableArray *nameArray, *imageArray, *idArray;
    NSInteger selectedIndex;
}
@property(nonatomic,retain) id<CardDetailsSend> delegate;

@property (weak, nonatomic) IBOutlet UITableView *payTableView;
@property (weak, nonatomic) IBOutlet UIButton *addCardBtn;

@property (weak, nonatomic)  NSString *fromWhereStr;

@end
