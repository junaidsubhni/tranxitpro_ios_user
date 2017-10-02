//
//  HistoryViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "HistoryViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "Colors.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "CommenMethods.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Utilities.h"
#import "ViewController.h"


@interface HistoryViewController ()
{
    AppDelegate *appDelegate;
}

@end

@implementation HistoryViewController
@synthesize strID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setDesignStyles];
    [self getHistory];
    
    if ([_historyHintStr isEqualToString:@"UPCOMING"])
    {
        [_commentsView setHidden:YES];
        [_cashLb setHidden:YES];
    }
    
    self.userImg.layer.cornerRadius=self.userImg.frame.size.height/2;
    self.userImg.clipsToBounds=YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [UIView animateWithDuration:0.45 animations:^{
        
        _invoiceView.frame = CGRectMake(0, self.view.frame.size.height +30, self.view.frame.size.width,  300);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setDesignStyles
{
    [CSS_Class APP_fieldValue_Small:_dateLb];
    [CSS_Class APP_SmallText:_timeLb];
    [CSS_Class APP_fieldValue_Small:_nameLb];
    [CSS_Class APP_labelName:_paymentLb];
    [CSS_Class APP_labelName:_commentTitleLb];
    [CSS_Class APP_fieldValue_Small:_payTypeLb];
    [CSS_Class APP_fieldValue:_cashLb];
    [_timeLb setTextColor:TEXTCOLOR_LIGHT];
    
    [CSS_Class APP_Blackbutton:_callBtn];
    [CSS_Class APP_Blackbutton:_cancelBtn];
    [CSS_Class APP_Blackbutton:_receiptBtn];

    [CSS_Class APP_labelName:_lblBacePrice];
    [CSS_Class APP_labelName:_lblTaxPrice];
    [CSS_Class APP_labelName:_lblDistance];
    [CSS_Class APP_labelName:_invoice_discountAmt];
    [CSS_Class APP_labelName:_invoice_WalletAmt];
    [CSS_Class APP_fieldValue:_lblTotalAmt];
    
    [CSS_Class APP_SmallText:_pickLb];
    [CSS_Class APP_SmallText:_dropLb];
    [CSS_Class APP_SmallText:_commentsLb];
    
    _userImg.layer.cornerRadius=_userImg.frame.size.height/2;
    _userImg.clipsToBounds=YES;
}

-(void)getHistory
{
    if ([appDelegate internetConnected])
    {
        NSDictionary *param=@{@"request_id":strID};
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [appDelegate onStartLoader];
        
        NSString *serviceStr;
        
        if([_historyHintStr isEqualToString:@"PAST"])
        {
            serviceStr = MD_GET_SINGLE_HISTORY;
        }
        else
        {
            serviceStr = MD_UPCOMING_HISTORYDETAILS;
        }
        
        [afn getDataFromPath:serviceStr withParamData:param withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                NSLog(@"History details....%@", response);
                if ([response count]!=0)
                {
                    NSDictionary *dictLocal=[response objectAtIndex:0];
                    
                    _invoiceIdLbl.text=[NSString stringWithFormat:@"INVOICE ID - %@",[Utilities removeNullFromString:[dictLocal valueForKey:@"booking_id"]]];
                    
                    NSString *strVal=[dictLocal valueForKey:@"static_map"];
                    id_Str=[dictLocal valueForKey:@"id"];
                    NSString *escapedString =[strVal stringByReplacingOccurrencesOfString:@"%7C" withString:@"|"];
                    NSURL *mapUrl = [NSURL URLWithString:[escapedString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
                    [ _mapImg sd_setImageWithURL:mapUrl placeholderImage:[UIImage imageNamed:@"rd-map"]];
                    
                    if (![dictLocal[@"provider"] isKindOfClass:[NSNull class]]) {
                        
                        strProviderCell =[dictLocal[@"provider"] valueForKey:@"mobile"];
                        
                        if (![[dictLocal[@"provider"] valueForKey:@"avatar"] isKindOfClass:[NSNull class]])
                        {
                            NSString *imageUrl =[dictLocal[@"provider"] valueForKey:@"avatar"];
                            
                            if ([imageUrl containsString:@"http"])
                            {
                                imageUrl = [NSString stringWithFormat:@"%@",[dictLocal[@"provider"] valueForKey:@"avatar"]];
                            }
                            else
                            {
                                imageUrl = [NSString stringWithFormat:@"%@/storage/%@",SERVICE_URL, [dictLocal[@"provider"] valueForKey:@"avatar"]];
                            }
                            
                            [ _userImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                                         placeholderImage:[UIImage imageNamed:@"userProfile"]];
                        }
                        else
                        {
                            _userImg.image=[UIImage imageNamed:@"userProfile"];
                        }
                        
                        _nameLb.text=[NSString stringWithFormat:@"%@" @"%@",[dictLocal[@"provider"] valueForKey:@"first_name"],[dictLocal[@"provider"] valueForKey:@"last_name"]] ;
                        
                    }
                    
                    if (![dictLocal[@"rating"] isKindOfClass:[NSNull class]])
                    {
                        if (![[dictLocal[@"rating"] valueForKey:@"user_rating"] isKindOfClass:[NSNull class]])
                            _userRating.value=[[dictLocal[@"rating"] valueForKey:@"user_rating"] intValue];
                        else
                            _userRating.value=0;
                        
                        if (![[dictLocal[@"rating"] valueForKey:@"user_comment"] isKindOfClass:[NSNull class]])
                        {
                            if ([[dictLocal[@"rating"] valueForKey:@"user_comment"] isEqualToString:@""])
                            {
                                _commentsLb.text=@"no comments";
                            }
                            else
                            {
                                _commentsLb.text=[dictLocal[@"rating"] valueForKey:@"user_comment"];

                            }
                        }
                    }
                    
                    if (![dictLocal[@"s_address"] isKindOfClass:[NSNull class]])
                        _pickLb.text=dictLocal[@"s_address"];
                    
                    if (![dictLocal[@"d_address"] isKindOfClass:[NSNull class]])
                        _dropLb.text=dictLocal[@"d_address"];
                    
                    if (![dictLocal[@"payment"] isKindOfClass:[NSNull class]])
                    {
                        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                        NSString *currencyStr=[user valueForKey:@"currency"];
                        
                        if([_historyHintStr isEqualToString:@"PAST"])
                        {
                            _cashLb.text= [NSString stringWithFormat:@"%@%@", currencyStr, [dictLocal[@"payment"] valueForKey:@"total"]];
                            _lblTotalAmt.text= [NSString stringWithFormat:@"%@%@", currencyStr, [dictLocal[@"payment"] valueForKey:@"total"]];
                            
                             _lblBacePrice.text= [NSString stringWithFormat:@"%@%@", currencyStr, [dictLocal[@"payment"] valueForKey:@"fixed"]];
                             _lblDistance.text= [NSString stringWithFormat:@"%@%@", currencyStr, [dictLocal[@"payment"] valueForKey:@"distance"]];
                             _lblTaxPrice.text= [NSString stringWithFormat:@"%@%@", currencyStr, [dictLocal[@"payment"] valueForKey:@"tax"]];
                            _invoice_WalletAmt.text= [NSString stringWithFormat:@"%@%@", currencyStr, [dictLocal[@"payment"] valueForKey:@"wallet"]];
                            _invoice_discountAmt.text= [NSString stringWithFormat:@"%@%@", currencyStr, [dictLocal[@"payment"] valueForKey:@"discount"]];
                            
                            [self.receiptBtn setHidden:NO];
                            [self.bottomView setHidden:YES];
                        }
                        else
                        {
                            _cashLb.text= [NSString stringWithFormat:@"%@0.00", currencyStr];
                            
                            [self.bottomView setHidden:NO];
                            [self.receiptBtn setHidden:YES];


                        }
                    }
                    
                    if (![dictLocal[@"payment_mode"] isKindOfClass:[NSNull class]])
                        _payTypeLb.text=dictLocal[@"payment_mode"];
                    
                    _dateLb.text=[Utilities convertDateTimeToGMT:dictLocal[@"assigned_at"]];
                    _timeLb.text=[Utilities convertTimeFormat:dictLocal[@"assigned_at"]];
                    _bookingIdLbl.text =[Utilities  removeNullFromString:[dictLocal valueForKey:@"booking_id"]];

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

-(IBAction)callBtn:(id)sender
{
    if ([strProviderCell isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Driver was not provided the number to call." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:strProviderCell]];
        NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:strProviderCell]];
        
        if ([UIApplication.sharedApplication canOpenURL:phoneUrl])
        {
            [UIApplication.sharedApplication openURL:phoneUrl options:@{} completionHandler:nil];
        }
        else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl])
        {
            [UIApplication.sharedApplication openURL:phoneFallbackUrl options:@{} completionHandler:nil];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Your device does not support calling" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];    }
    }
}


-(IBAction)cancelActionBtn:(id)sender
{
    if ([appDelegate internetConnected])
    {
        NSDictionary *params=@{@"request_id":id_Str};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:MD_CANCEL_REQUEST withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
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

-(IBAction)receiptBtn:(id)sender
{
    [UIView animateWithDuration:0.45 animations:^{
        
        _invoiceView.frame = CGRectMake(0, self.view.frame.size.height -300, self.view.frame.size.width,  300);
    }];
}


-(IBAction)backBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
