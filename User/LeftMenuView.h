//
//  LeftMenuView.h
//  caretaker_user
//
//  Created by apple on 12/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CommenMethods.h"

@protocol LeftMenuViewprotocol;

@interface LeftMenuView : UIView<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UIGestureRecognizerDelegate>
{
    AppDelegate *appDelegate;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property(strong,nonatomic) NSArray *menuImages;
@property(strong,nonatomic) NSArray *menuImagesText;

@property (nonatomic,retain) id <LeftMenuViewprotocol> LeftMenuViewDelegate;
@property (weak, nonatomic) IBOutlet UIButton *proPicImgBtn;

@end
@protocol LeftMenuViewprotocol <NSObject>

-(void)yourTripsView;
-(void)walletView;
-(void)helpView;
-(void)shareView;
-(void)logOut;
-(void)profileView;
-(void)payments;
-(void)coupons;

@end
