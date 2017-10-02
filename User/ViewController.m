//
//  ViewController.m
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "ViewController.h"
#import "SocailMediaViewController.h"
#import "EmailViewController.h"
#import "CSS_Class.h"
#import "config.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setDesignStyles];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDesignStyles
{
    [CSS_Class APP_SocialLabelName:_socialLbl];
    
    
    _lblTitle.text=NSLocalizedString(@"TITLE_LBL", nil);
    _lblAppName.text=NSLocalizedString(@"APP_NAME", nil);
    _socialLbl.text=NSLocalizedString(@"SOCIAL_BUTTON", nil);
  //  [_btnMailId setTitle:NSLocalizedString(@"MAIL_BUTTON", nil) forState:UIControlStateNormal];
    //[_btnSocial setTitle:NSLocalizedString(@"SOCIAL_BUTTON", nil) forState:UIControlStateNormal];
    
    
    
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_xuberView.bounds];
    _xuberView.layer.masksToBounds = NO;
    _xuberView.layer.shadowColor = [UIColor blackColor].CGColor;
    _xuberView.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
    _xuberView.layer.shadowOpacity = 1.0f;
    _xuberView.layer.shadowPath = shadowPath.CGPath;
    _xuberView.layer.cornerRadius = 5.0f;
}

-(IBAction)socialbtn:(id)sender
{
    SocailMediaViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SocailMediaViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)emailBtn:(id)sender
{
    EmailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
