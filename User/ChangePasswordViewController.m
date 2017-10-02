//
//  ChangePasswordViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 01/02/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "EmailViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "AFNHelper.h"
#import "ViewController.h"
#import "Constants.h"
#import "CommenMethods.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setDesignStyles];
     appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

-(void)setDesignStyles
{
    [CSS_Class APP_labelName:_helpLbl];
    [CSS_Class APP_textfield_Outfocus:_passText];
    [CSS_Class APP_textfield_Outfocus:_confirmPassText];
    [CSS_Class APP_textfield_Outfocus:_oldPassText];
    
    [CSS_Class APP_labelName_Small:_oldPassLbl];
    [CSS_Class APP_labelName_Small:_passLbl];
    [CSS_Class APP_labelName_Small:_confirmPassLbl];
    [CSS_Class APP_Blackbutton:_changePasswordBtn];
}

-(IBAction)backBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_oldPassText)
    {
        [_passText becomeFirstResponder];
    }
    if(textField==_passText)
    {
        [_confirmPassText becomeFirstResponder];
    }
    else if(textField==_confirmPassText)
    {
        [_confirmPassText resignFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if((textField == _passText) || (textField == _oldPassText) || (textField == _confirmPassText))
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= PASSWORDLENGTH || returnKey;
    }
    else
    {
        return YES;
    }
    
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [CSS_Class APP_textfield_Infocus:textField];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [CSS_Class APP_textfield_Outfocus:textField];
    return YES;
}

-(IBAction)Nextbtn:(id)sender
{
    [self.view endEditing:YES];
    
    if((_passText.text.length==0) || (_confirmPassText.text.length==0) || (_oldPassText.text.length==0))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT", nil) message:NSLocalizedString(@"PWD_REQ", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(![_passText.text isEqualToString:_confirmPassText.text])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT", nil) message:NSLocalizedString(@"MATCH_PWD", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        if([appDelegate internetConnected])
        {
            NSDictionary*params;
            params=@{@"password":_passText.text, @"password_confirmation":_confirmPassText.text, @"old_password":_oldPassText.text};
            [appDelegate onStartLoader];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:MD_CHANGEPASSWORD  withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode)
             {
                 [appDelegate onEndLoader];

                 if (response)
                 {
                     NSLog(@"RESPONSE ...%@", response);
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success!" message:NSLocalizedString(@"PWD_CHD", nil)preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         
                         [self backBtn:self];
                     }];
                     [alertController addAction:ok];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
                 else
                 {
                     if ([errorcode intValue]==1)
                     {
                         [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                     }
                     else if([errorcode  intValue]==3)
                     {
//                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_IMG];
//                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_NAME];
//                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_TOKEN_TYPE];
//                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_ACCESS_TOKEN];
//                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_REFERSH_TOKEN];
//                         
//                         ViewController *logout = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                         [self.navigationController pushViewController:logout animated:YES];
                         
                         [self logoutMethod];
                     }
                     else{
                         if ([error objectForKey:@"old_password"]) {
                             [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"old_password"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else if ([error objectForKey:@"password"]) {
                             [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"password"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         else if ([error objectForKey:@"password_confirmation"]) {
                             [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"password_confirmation"] objectAtIndex:0]  viewController:self okPop:NO];
                         }
                         
                     }
                 }
             }];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT", nil) message:NSLocalizedString(@"CONNECTION", nil)preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
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

@end
