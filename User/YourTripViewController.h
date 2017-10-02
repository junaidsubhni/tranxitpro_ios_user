//
//  YourTripViewController.h
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourTripViewController : UIViewController
{
    NSMutableArray *dateArray, *timeArray, *amountArray, *imageArray, *idArray, *bookingArray;
    NSString *identifierStr, *requestIdStr;
}
@property (weak, nonatomic) IBOutlet UILabel *headerLb;
@property (weak, nonatomic) IBOutlet UITableView *tripTableView;
@property (weak, nonatomic) IBOutlet UIButton *pastBtn;
@property (weak, nonatomic) IBOutlet UIButton *upcomingBtn;
@property (weak, nonatomic) IBOutlet UILabel *upcomingLbl;
@property (weak, nonatomic) IBOutlet UILabel *pastLbl;
@property (weak, nonatomic) IBOutlet UILabel *noDataLbl;

@property (weak, nonatomic) NSString *navigateStr;

@end
