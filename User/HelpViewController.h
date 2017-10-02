//
//  HelpViewController.h
//  User
//
//  Created by iCOMPUTERS on 21/06/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"


@interface HelpViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    NSString *strProviderCell, *mailAddress;
    AppDelegate *appDelegate;
}

@end
