//
//  EmailViewController.h
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailViewController : UIViewController<UIGestureRecognizerDelegate>
{
    NSString *emailString;
}

@property (weak, nonatomic) IBOutlet UILabel *helpLbl;
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property (weak, nonatomic) IBOutlet UILabel *register_Lbl;


@end
