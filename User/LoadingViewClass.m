//
//  LoadingViewClass.m
//  LoadingView
//
//  Created by Rajesh on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingViewClass.h"
#import "AppDelegate.h"
#import "UIImage+animatedGIF.h"
#import "config.h"

@implementation LoadingViewClass

#define RADIANS(degrees) ((degrees * (float)M_PI) / 180.0f)


-(void)startLoading
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *notif)
     {
         UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
         NSInteger degrees = 0;
         
         CGRect BGframe,blackFrame;
         if (UIInterfaceOrientationIsLandscape(orientation)) {
             if (orientation == UIInterfaceOrientationLandscapeLeft) { degrees = -90; }
             else { degrees = 90; }
             // Window coordinates differ!
             BGframe = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
             //blackFrame = CGRectMake(180.0, 120.0, 160.0, 60.0);
             
         } else {
             if (orientation == UIInterfaceOrientationPortraitUpsideDown) { degrees = 180; }
             else { degrees = 0; }
             BGframe = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
             blackFrame = CGRectMake(80.0, 200.0, 200.0, 60.0);
         }
         
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(RADIANS(degrees));
         
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationDuration:1.0];
         [UIView setAnimationDelay:0.0];
         
         [backgroundView setFrame:BGframe];
         [loadingView setTransform:rotationTransform];
         
         [UIView commitAnimations];
         
         
         
     }];
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)/2 - 90, ([UIScreen mainScreen].bounds.size.height)/2 - 50, 180, 100)];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    NSInteger degrees = 0;
    
    CGRect BGframe,blackFrame;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (orientation == UIInterfaceOrientationLandscapeLeft) { degrees = -90; }
        else { degrees = 90; }
        // Window coordinates differ!
        BGframe = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        //blackFrame = CGRectMake(180.0, 120.0, 160.0, 60.0);
        
    } else {
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) { degrees = 180; }
        else { degrees = 0; }
        BGframe = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        blackFrame = CGRectMake(80.0, 200.0, 200.0, 60.0);
    }

    
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(RADIANS(degrees));
    
    [backgroundView setFrame:BGframe];
    [loadingView setTransform:rotationTransform];
    
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    [backgroundView setAlpha:0.5];
    
    [appdelegate.window addSubview:backgroundView];
    
    loadingView.autoresizingMask = UIViewAutoresizingNone;
    //loadingView.layer.borderColor = [[UIColor whiteColor] CGColor];
    //loadingView.layer.borderWidth = 2.0;
   loadingView.layer.cornerRadius = 5.0;
    loadingView.backgroundColor = [UIColor clearColor];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loader" withExtension:@"gif"];
    
    UIImageView *animatedImageView = [[UIImageView alloc] init];
    [animatedImageView setFrame:CGRectMake((loadingView.bounds.size.width)/2 - 50,(loadingView.bounds.size.height)/2 - 50, 100, 100)];
    animatedImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    animatedImageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    [loadingView addSubview: animatedImageView];
    
    lblLoading = [[UILabel alloc]initWithFrame:CGRectMake((loadingView.bounds.size.width)/2 - 30, 27.0, 90, 50.0)];
    lblLoading.backgroundColor = [UIColor clearColor];
    lblLoading.font = [UIFont fontWithName:@"League Gothic" size:24];
    lblLoading.textColor = [UIColor blackColor];
    lblLoading.text = @"Loading...";
    
    //[loadingView addSubview:lblLoading];
    [appdelegate.window addSubview:loadingView];
    
}

-(void)stopLoading
{
    
//    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
//        loadingView.center = CGPointMake(loadingView.center.x,0);
//    } completion:NULL ];
    
    [backgroundView removeFromSuperview];
    [loadingView removeFromSuperview];
}

-(void)signinLoading
{
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *notif)
     {
         UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
         NSInteger degrees = 0;
         
         CGRect BGframe,blackFrame;
         if (UIInterfaceOrientationIsLandscape(orientation)) {
             if (orientation == UIInterfaceOrientationLandscapeLeft) { degrees = -90; }
             else { degrees = 90; }
             // Window coordinates differ!
             BGframe = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
             //blackFrame = CGRectMake(180.0, 120.0, 160.0, 60.0);
             
         } else {
             if (orientation == UIInterfaceOrientationPortraitUpsideDown) { degrees = 180; }
             else { degrees = 0; }
             BGframe = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
             blackFrame = CGRectMake(80.0, 200.0, 200.0, 60.0);
         }
         
         CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(RADIANS(degrees));
         
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationDuration:1.0];
         [UIView setAnimationDelay:0.0];
         
         [backgroundView setFrame:BGframe];
         [loadingView setTransform:rotationTransform];
         
         [UIView commitAnimations];
         
     }];
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)/2 - 90, ([UIScreen mainScreen].bounds.size.height)/2 - 50, 180.0, 100.0)];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    NSInteger degrees = 0;
    
    CGRect BGframe,blackFrame;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (orientation == UIInterfaceOrientationLandscapeLeft) { degrees = -90; }
        else { degrees = 90; }
        // Window coordinates differ!
        BGframe = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        //blackFrame = CGRectMake(180.0, 120.0, 160.0, 60.0);
        
    } else {
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) { degrees = 180; }
        else { degrees = 0; }
        BGframe = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        blackFrame = CGRectMake(80.0, 200.0, 200.0, 60.0);
    }

    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(RADIANS(degrees));
    
    [backgroundView setFrame:BGframe];
    [loadingView setTransform:rotationTransform];
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    [backgroundView setAlpha:0.5];
    
    [appdelegate.window addSubview:backgroundView];
    
    loadingView.autoresizingMask = UIViewAutoresizingNone;
    //loadingView.layer.borderColor = [[UIColor whiteColor] CGColor];
    //loadingView.layer.borderWidth = 2.0;
    loadingView.layer.cornerRadius = 5.0;
    loadingView.backgroundColor = [UIColor clearColor];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loader" withExtension:@"gif"];
    
    UIImageView *animatedImageView = [[UIImageView alloc] init];
    [animatedImageView setFrame:CGRectMake((loadingView.bounds.size.width)/2 - 50,(loadingView.bounds.size.height)/2 - 50, 80, 80)];
    animatedImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    animatedImageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    [loadingView addSubview: animatedImageView];
    
    lblLoading = [[UILabel alloc]initWithFrame:CGRectMake((loadingView.bounds.size.width)/2 - 40, 27.0, 80.0, 50.0)];
    lblLoading.backgroundColor = [UIColor clearColor];
    lblLoading.font = [UIFont fontWithName:@"League Gothic" size:24];
    lblLoading.textColor = [UIColor blackColor];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *path= [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    lblLoading.text = [languageBundle localizedStringForKey:@"signinmessage" value:@"" table:nil];
    
    //[loadingView addSubview:lblLoading];
    [appdelegate.window addSubview:loadingView];
    
}
@end
