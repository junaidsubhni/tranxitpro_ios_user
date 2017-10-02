//
//  LeftMenuView.m
//  caretaker_user
//
//  Created by apple on 12/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "LeftMenuView.h"
#import "LeftMenuTableViewCell.h"
#import "config.h"
#import "CSS_Class.h"
#import "Colors.h"
#import "ProfileViewController.h"
#import "Constants.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "CommenMethods.h"
#import "AppDelegate.h"

@implementation LeftMenuView
@synthesize menuImages,menuImagesText,menuTableView;

@synthesize nameLbl,proPicImgBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self setDesign];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setDesign];
}

- (void)setDesign
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    nameLbl.text = [defaults valueForKey:UD_PROFILE_NAME];
    
    if (![[defaults valueForKey:UD_PROFILE_IMG] isKindOfClass:[NSNull class]])
    {
        NSString *strProfile = [defaults valueForKey:UD_PROFILE_IMG];
        NSURL *imgUrl;
        if ([strProfile length]!=0)
        {
            if ([strProfile containsString:@"http"])
            {
                imgUrl = [NSURL URLWithString:strProfile];
            }
            else
            {
                imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/storage/%@", SERVICE_URL, strProfile]];
            }
        }
        [_imgUser sd_setImageWithURL:imgUrl  placeholderImage:[UIImage imageNamed:@"userProfile"]];
    }
    //
        self.imgUser.layer.cornerRadius=self.imgUser.frame.size.height/2;
        self.imgUser.clipsToBounds=YES;
    //
    menuImagesText=[[NSArray alloc]initWithObjects:@"Payments",@"Your Trips",@"Coupon",@"Wallet",@"Help",@"Share",@"Logout",nil];
    [menuTableView reloadData];
    
}


#pragma mark -- Table View Delegates Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   return [menuImagesText count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuTableViewCell *cell = (LeftMenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"LeftMenuTableViewCellID"];
    
    if (cell == nil)
    {
        cell = (LeftMenuTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"LeftMenuTableViewCell" owner:self options:nil] lastObject];
    }
//    cell.menuImg.image=[UIImage imageNamed:[menuImages objectAtIndex:indexPath.row]];
    cell.menuLbl.text=[menuImagesText objectAtIndex:indexPath.row];
    //[CSS_Class App_Header:cell.menuLbl];
    //[cell.menuLbl setTextColor:RGB(18, 18, 18)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *viewRedirectionString = [menuImagesText objectAtIndex:indexPath.row];
    
    if ([viewRedirectionString isEqualToString:@"Your Trips"])
    {
        [self.LeftMenuViewDelegate yourTripsView];
    }
    else if ([viewRedirectionString isEqualToString:@"Wallet"])
    {
        [self.LeftMenuViewDelegate walletView];
    }
    else if ([viewRedirectionString isEqualToString:@"Help"])
    {
        [self.LeftMenuViewDelegate helpView];
    }
    else if ([viewRedirectionString isEqualToString:@"Share"])
    {
        [self.LeftMenuViewDelegate shareView];
    }
    else if ([viewRedirectionString isEqualToString:@"Logout"])
    {
        [self.LeftMenuViewDelegate logOut];
    }
    else if ([viewRedirectionString isEqualToString:@"Coupon"])
    {
        [self.LeftMenuViewDelegate coupons];
    }
    else if ([viewRedirectionString isEqualToString:@"Payments"])
    {
        [self.LeftMenuViewDelegate payments];
    }
}

- (IBAction)proPicImgBtnAction:(id)sender
{
    [self.LeftMenuViewDelegate profileView];
}
@end
