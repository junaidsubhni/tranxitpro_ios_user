//
//  UINavigationController+NavigationControl.m
//  UnitWise
//
//  Created by $ h i v a on 31/12/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "UINavigationController+NavigationControl.h"

@implementation UINavigationController (NavigationControl)

- (NSUInteger) supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    else
    {
        return UIInterfaceOrientationMaskLandscape;
    }
}


@end
