//
//  CouponsViewController.h
//  User
//
//  Created by iCOMPUTERS on 18/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponsViewController : UIViewController
{
    NSMutableArray *promoArray;
}

@property (weak, nonatomic) IBOutlet UITextField *couponText;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
