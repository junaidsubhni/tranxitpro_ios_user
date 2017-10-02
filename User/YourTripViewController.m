//
//  YourTripViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "YourTripViewController.h"
#import "config.h"
#import "Colors.h"
#import "CSS_Class.h"
#import "TripsTableViewCell.h"
#import "HistoryViewController.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "CommenMethods.h"
#import "Utilities.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "ViewController.h"


@interface YourTripViewController ()
{
    AppDelegate *appDelegate;
}

@end

@implementation YourTripViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([_navigateStr isEqualToString:@"Home"])
    {
        [self upcomingBtn:self];
    }
    else
    {
        [self pastBtn:self];
    }
}

-(void)onGetHistory
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [appDelegate onStartLoader];
        
        NSString *serviceStr;
        if([identifierStr isEqualToString:@"PAST"])
        {
            serviceStr = MD_GET_HISTORY;
        }
        else
        {
            serviceStr = MD_UPCOMING;
        }
        
        [afn getDataFromPath:serviceStr withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                NSArray *arrLocal=response;
                if (arrLocal.count!=0)
                {
                    NSLog(@"history ...%@", arrLocal);
                    
                    dateArray = [[NSMutableArray alloc]init];
                    timeArray = [[NSMutableArray alloc]init];
                    amountArray = [[NSMutableArray alloc]init];
                    imageArray = [[NSMutableArray alloc]init];
                    idArray = [[NSMutableArray alloc]init];
                    bookingArray = [[NSMutableArray alloc]init];
                    
                    [_noDataLbl setHidden:YES];
                    [_tripTableView setHidden:NO];
                    
                    for (NSDictionary *dictVal in arrLocal)
                    {
                        if([identifierStr isEqualToString:@"PAST"])
                        {
                            NSString *strDate=[Utilities convertDateTimeToGMT:[dictVal valueForKey:@"assigned_at"]];
                            NSString *strTime=[Utilities  convertTimeFormat:[dictVal valueForKey:@"assigned_at"]];
                            [dateArray addObject:strDate];
                            [timeArray addObject:strTime];
                        }
                        else
                        {
                            NSString *strDate=[Utilities convertDateTimeToGMT:[dictVal valueForKey:@"schedule_at"]];
                            NSString *strTime=[Utilities  convertTimeFormat:[dictVal valueForKey:@"schedule_at"]];
                            [dateArray addObject:strDate];
                            [timeArray addObject:strTime];
                        }
                        
                        [imageArray addObject:[dictVal valueForKey:@"static_map"]];
                        [idArray addObject:[dictVal valueForKey:@"id"]];
                        [bookingArray addObject:[Utilities removeNullFromString:[dictVal valueForKey:@"booking_id"]]];

                        if (![[dictVal valueForKey:@"payment"] isKindOfClass:[NSNull class]]) {
                            
                            if([identifierStr isEqualToString:@"PAST"])
                            {
                                [amountArray addObject:[[dictVal valueForKey:@"payment"] valueForKey:@"total"]];
                            }
                            else
                            {
                                ///
                            }
                        }
                        else
                        {
                            [amountArray addObject:@"0"];
                        }
                    }
                    [_tripTableView reloadData];
                }
                else
                {
                    [_noDataLbl setHidden:NO];
                    [_tripTableView setHidden:YES];
                }
                
              }
            else
            {
                if ([errorcode intValue]==1)
                {
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else if ([errorcode intValue]==3)
                {
//                    [CommenMethods onRefreshToken];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_IMG];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_NAME];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_TOKEN_TYPE];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_ACCESS_TOKEN];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_REFERSH_TOKEN];
//                    
//                    ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                    [self.navigationController pushViewController:wallet animated:YES];
                    
                    [self logoutMethod];
                }
            }
            
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
    
}

-(void)logoutMethod
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        
        [afn refreshMethod_NoLoader:MD_REFRESH_TOKEN withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            if (response)
            {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setValue:response[@"token_type"] forKey:UD_TOKEN_TYPE];
                [user setValue:response[@"access_token"] forKey:UD_ACCESS_TOKEN];
                [user setValue:response[@"refresh_token"] forKey:UD_REFERSH_TOKEN];
            }
            else
            {
                [CommenMethods alertviewController_title:@"Alert" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
            }
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"Alert" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setDesignStyles
{

}

#pragma mark -- Table View Delegates Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dateArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripsTableViewCell *cell = (TripsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TripsTableViewCell"];
    
    if (cell == nil)
    {
        cell = (TripsTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"TripsTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *currencyStr=[user valueForKey:@"currency"];
    
    cell.dateLbl.text = [NSString stringWithFormat:@"%@", [bookingArray objectAtIndex:indexPath.row]];
    cell.timeLbl.text = [NSString stringWithFormat:@"%@-%@",[dateArray objectAtIndex:indexPath.row], [timeArray objectAtIndex:indexPath.row]];
    
    [CSS_Class APP_fieldValue:cell.dateLbl];
    [CSS_Class APP_fieldValue_Small:cell.timeLbl];
    [CSS_Class APP_fieldValue:cell.amountLbl];
    cell.timeLbl.textColor = TEXTCOLOR_LIGHT;
    
    NSString *strVal=imageArray [indexPath.row];
    NSString *escapedString =[strVal stringByReplacingOccurrencesOfString:@"%7C" withString:@"|"];
     NSURL *mapUrl = [NSURL URLWithString:[escapedString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
    
    [cell.mapImg sd_setImageWithURL:mapUrl  placeholderImage:[UIImage imageNamed:@"rd-map"]];
   
    
    cell.cancelBtn.layer.cornerRadius = 5.0f;
    cell.cancelBtn.layer.borderWidth = 1.0f;
    cell.cancelBtn.layer.borderColor = TEXTCOLOR_LIGHT.CGColor;
    
    if (![identifierStr isEqualToString:@"PAST"])
    {
        [cell.amountLbl setHidden:YES];
        [cell.cancelBtn setHidden:NO];
    }
    else
    {
        [cell.amountLbl setHidden:NO];
        [cell.cancelBtn setHidden:YES];
        cell.amountLbl.text = [NSString stringWithFormat:@"%@%@", currencyStr, [amountArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    requestIdStr =[NSString stringWithFormat:@"%@",[idArray objectAtIndex:indexPath.row]];
    NSLog(@"orderIdString ...%@", requestIdStr);
    
    HistoryViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    wallet.historyHintStr = identifierStr;
    wallet.strID=requestIdStr;
    [self presentViewController:wallet animated:YES completion:nil];
}


-(IBAction)backBtn:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)upcomingBtn:(id)sender
{
    identifierStr = @"UPCOMING";
    [_upcomingLbl setHidden:NO];
    [_pastLbl setHidden:YES];
    
     [self onGetHistory];
}
-(IBAction)pastBtn:(id)sender
{
    identifierStr = @"PAST";
    [_upcomingLbl setHidden:YES];
    [_pastLbl setHidden:NO];
    
    [self onGetHistory];
}


-(IBAction)cancelActionBtn:(id)sender
{
    if ([appDelegate internetConnected])
    {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tripTableView];
        NSIndexPath *indexPath = [_tripTableView indexPathForRowAtPoint:buttonPosition];
        NSLog(@"INDEXPATH...%ld", (long)indexPath.row);
        
        NSString *req_Id = [NSString stringWithFormat:@"%@", [idArray objectAtIndex:indexPath.row]];
        
        NSDictionary *params=@{@"request_id":req_Id};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:MD_CANCEL_REQUEST withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                [self onGetHistory];
            }
            else
            {
                if ([errorcode intValue]==1)
                {
                    [CommenMethods alertviewController_title:@"Error!" MessageAlert:[error objectForKey:@"error"] viewController:self okPop:NO];
                }
                else if ([errorcode intValue]==3)
                {
                    [self logoutMethod];
                    
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLoggedin"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_IMG];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_NAME];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_TOKEN_TYPE];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_ACCESS_TOKEN];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_REFERSH_TOKEN];
//                    
//                    ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                    [self.navigationController pushViewController:wallet animated:YES];
                }
                else
                {
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
            }
            
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
}


@end
