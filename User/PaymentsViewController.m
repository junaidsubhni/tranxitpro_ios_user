//
//  PaymentsViewController.m
//  User
//
//  Created by iCOMPUTERS on 18/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "PaymentsViewController.h"
#import "CreditCardViewController.h"
#import "PayTableViewCell.h"
#import "CSS_Class.h"
#import "config.h"
#import "Colors.h"
#import "Constants.h"
#import "AFNHelper.h"
#import "AppDelegate.h"
#import "CommenMethods.h"
#import "ViewController.h"

@interface PaymentsViewController ()
{
    AppDelegate *appDelegate;
    NSMutableArray *arrPaymentCardList;
    NSDictionary *dictSend;
}

@end

@implementation PaymentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    
    selectedIndex = -1;
    [_addCardBtn setHidden:NO];
    
//    if ([_fromWhereStr isEqualToString:@"LEFT MENU"]||[_fromWhereStr isEqualToString:@"WALLET"] )
//    {
//        [_addCardBtn setHidden:NO];
//    }
//    else
//    {
//        [_addCardBtn setHidden:YES];
//    }
}
-(void)viewWillAppear:(BOOL)animated
{
     [self getAllCards];
}
-(void)getAllCards
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:MD_LIST_CARD withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                arrPaymentCardList=[[NSMutableArray alloc] init];
                
                if ([_fromWhereStr isEqualToString:@"WALLET"])
                {
                    //No need to show cash to add money in wallet.
                }
                else
                {
                    NSDictionary *dictCash=@{@"brand":@"CASH",@"card_id":@"",@"id":@"0"};
                    [arrPaymentCardList addObject:dictCash];
                }
                
                
                [arrPaymentCardList addObjectsFromArray:response];
                if(arrPaymentCardList.count)
                  {
                     NSLog(@"%@",arrPaymentCardList);
                     [_payTableView reloadData];
                  }
                else {
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"No Cards Added!!"
                                                  message:@"Please add you card details."
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* cancelButton = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
                    
                    [alert addAction:cancelButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
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
                    [self logoutMethod];
                    
//                    [CommenMethods onRefreshToken];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_IMG];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_NAME];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_TOKEN_TYPE];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_ACCESS_TOKEN];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_REFERSH_TOKEN];
//                    
//                    ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                    [self.navigationController pushViewController:wallet animated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onGetPayment
{
    
}
#pragma mark -- Table View Delegates Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrPaymentCardList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayTableViewCell *cell = (PayTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PayTableViewCell"];
    
    if (cell == nil)
    {
        cell = (PayTableViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dictVal=[arrPaymentCardList objectAtIndex:indexPath.row];
    
    if ([_fromWhereStr isEqualToString:@"WALLET"])
    {
        cell.payLbl.text=[NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@",[dictVal valueForKey:@"last_four"]];
        cell.payImg.image = [UIImage imageNamed:@"visa"];
    }
    else
    {
        if (indexPath.row==0)
        {
            cell.payLbl.text=@"CASH";
            cell.payImg.image = [UIImage imageNamed:@"money_icon"];
            
        }
        else
        {
            cell.payLbl.text=[NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@",[dictVal valueForKey:@"last_four"]];
            cell.payImg.image = [UIImage imageNamed:@"visa"];
        }
    }
    
//    cell.payLbl.text=[NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@",[dictVal valueForKey:@"last_four"]];
//    cell.payImg.image = [UIImage imageNamed:@"visa"];
    
    [CSS_Class APP_fieldValue_Small:cell.payLbl];
    
    [cell.tickImg setHidden:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_fromWhereStr isEqualToString:@"LEFT MENU"])
    {
        selectedIndex = -1;
    }
    else if ([_fromWhereStr isEqualToString:@"WALLET"])
    {
        [_delegate onChangePaymentMode:[arrPaymentCardList objectAtIndex:indexPath.row]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        selectedIndex = indexPath.row;
        [_delegate onChangePaymentMode:[arrPaymentCardList objectAtIndex:indexPath.row]];
         [self dismissViewControllerAnimated:YES completion:nil];
    }
    
//    selectedIndex = indexPath.row;
//    [_payTableView reloadData];
}
-(BOOL)tableView:(UITableView* )tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_fromWhereStr isEqualToString:@"LEFT MENU"])
    {
        if (indexPath.row!=0)
          return YES;
    }
    else
        return NO;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=0)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            NSDictionary *dictLocal=[arrPaymentCardList objectAtIndex:indexPath.row];
            
            NSDictionary *params=@{@"_method":@"DELETE",@"card_id":[dictLocal valueForKey:@"card_id"]};
           
            if ([appDelegate internetConnected])
            {
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [appDelegate onStartLoader];
                [afn getDataFromPath:MD_CARD_DELETE withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
                    [appDelegate onEndLoader];
                    if (response)
                    {
                        [arrPaymentCardList removeObjectAtIndex:indexPath.row];
                        NSLog(@"%@",arrPaymentCardList);
                        [_payTableView reloadData];
                        
                    }
                    else
                    {
                        if ([errorcode intValue]==1)
                        {
                            [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                        }
                        else if ([errorcode intValue]==3)
                        {
                            [self logoutMethod];
                            
//                            [CommenMethods onRefreshToken];
//                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_IMG];
//                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_NAME];
//                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_TOKEN_TYPE];
//                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_ACCESS_TOKEN];
//                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_REFERSH_TOKEN];
//                            
//                            ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                            [self.navigationController pushViewController:wallet animated:YES];
                        }
                    }
                    
                }];
            }
            else
            {
                [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
            }
            
            
        }
        else
        {
            //Do Nothing
        }
    }
}

- (IBAction)backBtnAction:(id)sender
{
    if ([_fromWhereStr isEqualToString:@"LEFT MENU"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil]; 
    }
    
}

- (IBAction)addBtnAction:(id)sender
{
    CreditCardViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardViewController"];
    [self presentViewController:wallet animated:YES completion:nil];
}

@end
