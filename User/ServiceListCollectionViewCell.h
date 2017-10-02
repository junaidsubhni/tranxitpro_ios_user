//
//  ServiceListCollectionViewCell.h
//  User
//
//  Created by veena on 2/1/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgService;
@property (weak, nonatomic) IBOutlet UILabel *lblServiceName;
@property (weak, nonatomic) IBOutlet UILabel *lblServicePrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelected;

@end
