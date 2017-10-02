//
//  ProfileViewController.m
//  Provider
//
//  Created by iCOMPUTERS on 17/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "ProfileViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "Colors.h"
#import "UIScrollView+EKKeyboardAvoiding.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "CommenMethods.h"
#import "ForgotPasswordViewController.h"
#import "Utilities.h"
#import "ViewController.h"
#import "ChangePasswordViewController.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    AppDelegate *appDelegate;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setDesignStyles];
    
    [_detailsScrollView setContentSize:[_detailsScrollView frame].size];
    [_detailsScrollView setKeyboardAvoidingEnabled:YES];
    
    
    _btnProfilePic.layer.cornerRadius = _btnProfilePic.frame.size.width/2; // this value vary as per your desire
    _btnProfilePic.clipsToBounds = YES;
    [self onGetProfile];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

-(void)onGetProfile
{
     if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:MD_GETPROFILE withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                NSLog(@"PROFILE RES...%@", response);
                
                _firstNameText.text=  [Utilities removeNullFromString: response[@"first_name"]];
                _lastNameText.text= [Utilities removeNullFromString: response[@"last_name"]];
                _phoneText.text= [Utilities removeNullFromString: response[@"mobile"]];
                _emailValueLb.text= [Utilities removeNullFromString: response[@"email"]];
            
                    NSString *socialIdStr = [Utilities removeNullFromString:[response valueForKey:@"social_unique_id"]];
                    
                    NSString *strProfile=[Utilities removeNullFromString:response[@"picture"]];
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    [user setValue:strProfile forKey:UD_PROFILE_IMG];
                
                    NSString *nameStr = [NSString stringWithFormat:@"%@ %@", _firstNameText.text, _lastNameText.text];
                
                    [user setValue:nameStr forKey:UD_PROFILE_NAME];
                    [user setValue:socialIdStr forKey:UD_SOCIAL];
                    [user setValue:[response valueForKey:@"id"] forKey:UD_ID];
                    [user setValue:[response valueForKey:@"sos"] forKey:UD_SOS];

                if (![strProfile isEqualToString:@""])
                {
                    
                    NSString *strSub = [strProfile stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                    NSURL *imgUrl;
                    
                    if ([strProfile containsString:@"http"])
                    {
                        imgUrl = [NSURL URLWithString:strProfile];
                    }
                    else
                    {
                        imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/storage/%@", SERVICE_URL, strSub]];
                    }
                    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                    dispatch_async(q, ^{
                        /* Fetch the image from the server... */
                        NSData *data = [NSData dataWithContentsOfURL:imgUrl];
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                            [_btnProfilePic setBackgroundImage:img forState:UIControlStateNormal];
                            [_profileImg setImage:img];
                        });
                    });
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setDesignStyles
{
    [CSS_Class APP_labelName:_firstNameLb];
    [CSS_Class APP_labelName:_lastNameLb];
    [CSS_Class APP_labelName:_phoneLb];
    [CSS_Class APP_labelName:_carNumLb];
    [CSS_Class APP_labelName:_carNameLb];
    [CSS_Class APP_labelName:_emailtLb];
    [CSS_Class APP_fieldValue:_emailValueLb];
    
//    [CSS_Class APP_textfield_Outfocus:_carNumText];
//    [CSS_Class APP_textfield_Outfocus:_firstNameText];
//    [CSS_Class APP_textfield_Outfocus:_lastNameText];
//    [CSS_Class APP_textfield_Outfocus:_phoneText];
//    [CSS_Class APP_textfield_Outfocus:_carNameText];
    
    [CSS_Class APP_Blackbutton:_saveBtn];
    [CSS_Class APP_Blackbutton:_changePassBtn];
    
    _profileImg.layer.cornerRadius = _profileImg.frame.size.height/2;
    _profileImg.clipsToBounds = YES;
}

-(IBAction)backBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_firstNameText)
    {
        [_lastNameText becomeFirstResponder];
    }
    else if(textField==_lastNameText)
    {
        [_phoneText becomeFirstResponder];
    }
    else if(textField==_phoneText)
    {
        [_phoneText resignFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if((textField == _firstNameText) || (textField == _lastNameText) || (textField == _carNameText))
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= INPUTLENGTH || returnKey;
    }
    else if (textField == _phoneText)
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= PHONELENGTH || returnKey;
    }
    else if (textField == _carNumText)
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 35 || returnKey;
    }
    else
    {
        return YES;
    }
    
    return NO;
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    [CSS_Class APP_textfield_Infocus:textField];
//    return YES;
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    [CSS_Class APP_textfield_Outfocus:textField];
//    return YES;
//}

-(IBAction)saveBtn:(id)sender
{
        [self.view endEditing:YES];
        
        if ([_firstNameText.text isEqualToString:@""] ||[_lastNameText.text isEqualToString:@""] || [_phoneText.text isEqualToString:@""] || [_carNameText.text isEqualToString:@""] ||[_carNumText.text isEqualToString:@""])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT", nil) message:NSLocalizedString(@"VALIDATE", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            
            if ([appDelegate internetConnected])
            {
                [appDelegate onStartLoader];
                NSDictionary * params= @{@"email":_emailValueLb.text,@"first_name":_firstNameText.text,@"last_name":_lastNameText.text,@"mobile":_phoneText.text};
                
//                UIImage *imag=_btnProfilePic.currentBackgroundImage;
                
                UIImage *imag = _profileImg.image;
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                
                [afn getDataFromPath:MD_UPDATEPROFILE withParamDataImage:params andImage:imag withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
                    [appDelegate onEndLoader];
                    if (response)
                    {
                        [CommenMethods alertviewController_title:@"Success!" MessageAlert:@"Profile Updated." viewController:self okPop:NO];
                        
                        [self onGetProfile];
                    }
                    else
                    {
                        if ([errorcode intValue]==1)
                        {
                            [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                        }
                        else if([errorcode  intValue]==3)
                        {
//                            [CommenMethods onRefreshToken];
                            [self logoutMethod];
                            
//                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_IMG];
//                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PROFILE_NAME];
//                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_TOKEN_TYPE];
//                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_ACCESS_TOKEN];
//                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_REFERSH_TOKEN];
//                            
//                            ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                            [self.navigationController pushViewController:wallet animated:YES];
                        }
                        else{
                            if ([error objectForKey:@"email"]) {
                                [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"email"] objectAtIndex:0]  viewController:self okPop:NO];
                            }
                            else if ([error objectForKey:@"first_name"]) {
                                [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"first_name"] objectAtIndex:0]  viewController:self okPop:NO];
                            }
                            else if ([error objectForKey:@"last_name"]) {
                                [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"last_name"] objectAtIndex:0]  viewController:self okPop:NO];
                            }
                            else if ([error objectForKey:@"mobile"]) {
                                [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"mobile"] objectAtIndex:0]  viewController:self okPop:NO];
                            }
                            else if ([error objectForKey:@"picture"]) {
                                [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"picture"] objectAtIndex:0]  viewController:self okPop:NO];
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
    
- (IBAction)onChangePwd:(id)sender {
        ChangePasswordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
        [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)onProfilePic:(id)sender
{ UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}



#pragma mark
#pragma mark - ImagePickerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
//    [_btnProfilePic setBackgroundImage:image forState:UIControlStateNormal];
    [_profileImg setImage:image];
    
    [picker dismissViewControllerAnimated:true completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
