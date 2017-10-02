//
//  WalletViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 14/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "WalletViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "Colors.h"
#import "CommenMethods.h"
#import "Constants.h"
#import "PaymentsViewController.h"
#import "Utilities.h"
#import "CreditCardViewController.h"
#import "ViewController.h"

@interface WalletViewController ()
{
    NSMutableArray *arrPaymentCardList;
}

@end

@implementation WalletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
    [_doneBtn setHidden:YES];
    [self setDesignStyles];
    UITapGestureRecognizer *tapGesture_condition=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewOuterTap)];
    tapGesture_condition.cancelsTouchesInView=NO;
    tapGesture_condition.delegate=self;
    [self.view addGestureRecognizer:tapGesture_condition];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self onGetProfile];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Own Method

-(void)onGetProfile
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [appDelegate onStartLoader];
        
        NSString* UDID_Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
        NSLog(@"output is : %@", UDID_Identifier);
        
        NSDictionary *params=@{@"device_token":appDelegate.strDeviceToken,@"device_type":@"ios", @"device_id":UDID_Identifier};
        
        [afn getDataFromPath:MD_GETPROFILE withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                NSString *currencyStr=[Utilities removeNullFromString: [user valueForKey:@"currency"]];
                _amountLbl.text = [NSString stringWithFormat:@"%@%@", currencyStr, [response valueForKey:@"wallet_balance"]];
                
                [self getAllCards];
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
                [arrPaymentCardList addObjectsFromArray:response];
                NSLog(@"%@",arrPaymentCardList);
                
                if (arrPaymentCardList.count ==0)
                {
                    ///Add cards
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT", nil)  message:@"Please add a card to proceed" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        CreditCardViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardViewController"];
//                        [self presentViewController:wallet animated:YES completion:nil];
                    }];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    NSDictionary *dictVal=[arrPaymentCardList objectAtIndex:0];
                    _cardLbl.text =[NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@",[dictVal valueForKey:@"last_four"]];
                    strCardID = [dictVal valueForKey:@"card_id"];
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


-(void)setDesignStyles
{
    [CSS_Class APP_textfield_Outfocus:_amountText];
    [CSS_Class APP_Blackbutton:_addMoneyBtn];
    [CSS_Class APP_Blackbutton:_walletBtn];
    
    UIBezierPath *shadows = [UIBezierPath bezierPathWithRect:_commonRateView.frame];
    _commonRateView.layer.masksToBounds = NO;
    _commonRateView.layer.shadowColor = [UIColor blackColor].CGColor;
    _commonRateView.layer.shadowOffset = CGSizeMake(1.5f, 3.0f);
    _commonRateView.layer.shadowOpacity = 1.5f;
    _commonRateView.layer.shadowPath = shadows.CGPath;
    
    [CSS_Class APP_fieldValue_Small:_cardLbl];
    [CSS_Class APP_labelName:_enterAmountLbl];
    [CSS_Class APP_labelName:_walletLbl];
    [CSS_Class App_Header:_amountLbl];
    [_amountLbl setTextColor:BLACKCOLOR];
}

-(IBAction)backBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)addBtn:(id)sender
{
    if (arrPaymentCardList.count ==0)
    {
        ///Add cards
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT", nil)  message:NSLocalizedString(@"ADD_CARD", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CreditCardViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardViewController"];
            [self presentViewController:wallet animated:YES completion:nil];
        }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.45 animations:^{
            
            _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height - 300), self.view.frame.size.width,  300);
            
            waitingBGView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width  ,self.view.frame.size.height)];
            
            [waitingBGView setBackgroundColor:[UIColor blackColor]];
            [waitingBGView setAlpha:0.6];
            [self.view addSubview:waitingBGView];
            [self.view bringSubviewToFront:_commonRateView];
            
        }];
    }
}

- (void)ViewOuterTap
{
    [UIView animateWithDuration:0.45 animations:^{
        
        _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +300), self.view.frame.size.width,  300);
        [waitingBGView removeFromSuperview];
        
    }];
    [self.view endEditing:YES];
}

-(IBAction)done:(id)sender
{
     [self.view endEditing:YES];
     [_doneBtn setHidden:YES];
}

-(IBAction)selectCard:(id)sender
{
    PaymentsViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentsViewController"];
    wallet.fromWhereStr = @"WALLET";
    wallet.delegate=self;
    [self presentViewController:wallet animated:YES completion:nil];
}

-(void)onChangePaymentMode:(NSDictionary *)choosedPayment
{
    strCardID=[choosedPayment valueForKey:@"card_id"] ;
    _cardLbl.text=[NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@",[choosedPayment valueForKey:@"last_four"]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer* )gestureRecognizer shouldReceiveTouch:(UITouch* )touch
{
    if ([touch.view isDescendantOfView:_commonRateView])
    {
        return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField == _amountText)
    {
        int length = [self getLength:textField.text];
        if(length >= 4)
        {
            if(range.length == 0)
                return NO;
        }
        
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 4 || returnKey;
    }
    else
    {
        return YES;
    }
}

- (int)getLength:(NSString*)mobileNumber
{
    @try
    {
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        int length = (int)[mobileNumber length];
        
        return length;
        
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}
-(IBAction)addMoneyBtn:(id)sender
{
    if ([_amountText.text isEqualToString:@""])
    {
        [CommenMethods alertviewController_title:@"Alert" MessageAlert:NSLocalizedString(@"AMOUNT_WALLET", nil) viewController:self okPop:NO];
    }
    else
    {
        if ([appDelegate internetConnected])
        {
            NSDictionary *params = @{@"amount":_amountText.text, @"card_id":strCardID};
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [appDelegate onStartLoader];
            [afn getDataFromPath:MD_WALLET withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode)
             {
                 [appDelegate onEndLoader];
                 if (response)
                 {
                     [CommenMethods alertviewController_title:@"Success!" MessageAlert:[response valueForKey:@"message"]viewController:self okPop:NO];
                     
                     NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                     NSString *currencyStr=[Utilities removeNullFromString: [user valueForKey:@"currency"]];
                     
                     NSDictionary *userDict = [response valueForKey:@"user"];
                     _amountLbl.text = [NSString stringWithFormat:@"%@%@",currencyStr,[userDict valueForKey:@"wallet_balance"]];
                     [UIView animateWithDuration:0.45 animations:^{
                         
                         _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +300), self.view.frame.size.width,  300);
                         [waitingBGView removeFromSuperview];
                         
                     }];
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
//                         [CommenMethods onRefreshToken];
//                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_IMG];
//                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_NAME];
//                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_TOKEN_TYPE];
//                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_ACCESS_TOKEN];
//                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_REFERSH_TOKEN];
//                         
//                         ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                         [self.navigationController pushViewController:wallet animated:YES];
                     }
                     else if ([errorcode intValue]==2)
                     {
                         if ([error objectForKey:@"rating"]) {
                             [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"rating"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else if([error objectForKey:@"comments"]) {
                             [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"comments"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else if([error objectForKey:@"is_favorite"]) {
                             [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"is_favorite"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         
                     }
                     
                 }
                 
             }];
        }
        else
        {
            [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_amountText)
    {
        [_amountText resignFirstResponder];
    }
    else
    {
         [textField resignFirstResponder];
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [CSS_Class APP_textfield_Infocus:textField];
    [_doneBtn setHidden:NO];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [CSS_Class APP_textfield_Outfocus:textField];
    return YES;
}


@end
