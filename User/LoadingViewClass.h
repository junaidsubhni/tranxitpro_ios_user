//
//  
//  SPANPLAN
//
//  Created by SPAN TECHNOLOGY on 24/12/12.
//  Copyright (c) 2012 SPAN TECHNOLOGY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface LoadingViewClass : NSObject
{
    UIActivityIndicatorView *activityIndicator;
    UIView *backgroundView;
    UIView *loadingView;
    
    NSTimer *SyncTimer;
    
    UILabel *lblLoading;
}

@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, strong) UIImageView *blackImageView;
@property (nonatomic, strong) UIButton *closeButton;

-(void)startLoading;
//-(void)RefreshLoading;
//-(void)SigninLoading;
-(void)stopLoading;
-(void)signinLoading;


@end
