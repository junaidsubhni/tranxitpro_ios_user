//
//  HomeViewController.h
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuView.h"
#import "LoadingViewClass.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationViewController.h"
#import "HCSStarRatingView.h"
#import "PaymentsViewController.h"
#import "HelpViewController.h"

@class LoadingViewClass;
@import GoogleMaps;
@interface HomeViewController : UIViewController<LeftMenuViewprotocol, UIGestureRecognizerDelegate, GMSMapViewDelegate, CLLocationManagerDelegate,ChooseLocation,CardDetailsSend, UIPickerViewDelegate, UIPickerViewDataSource>
{
    LeftMenuView *leftMenuViewClass;
    UIView *waitingBGView;
    LoadingViewClass *loading;
    UIView *backgroundView, *popUpView, *backgroundView_Pop;
    BOOL gotLocation, socketConnectFlag, LoggedOut;
    
    UIButton *fixedHrs, *pickUpDrop;
    NSMutableArray *hoursArray,*arrServiceList, *serviceNameArray, *serviceImageArray, *serviceIDArray;
    NSInteger selectedIndex,serviceSelectIndex;
    
    UIView *date_pickerViewContainer;
    UIDatePicker *date_datePicker;
    NSDate *pickerDate;
    UILabel *scheduleDate;
    NSString *currentAddress, *walletFlag, *locationString, *scheduleStr, *globalStatus, *categoryStr, *scheduleNav_Str, *userNameStr, *dragMarkerStr;
    
    
    NSMutableArray *serviceNameArray_Small, *serviceImageArray_Small, *serviceIDArray_Small, *serviceNameArray_Big, *serviceImageArray_Big, *serviceIDArray_Big;
    
    int serviceView_Height, i;
}

@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *BackView;

@property(strong,nonatomic)IBOutlet GMSMarker*marker;
@property (strong, nonatomic) IBOutlet GMSMapView *mkap;
@property(nonatomic,retain) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *menuImgBtn;

@property (weak, nonatomic) IBOutlet UIView *notifyView;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;

//Notifiy view
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *lblServiceName;
@property (weak, nonatomic) IBOutlet UILabel *lblCarNumber;
@property (weak, nonatomic) IBOutlet UIImageView *ServiceImg;
@property (weak, nonatomic) IBOutlet UILabel *lblStatusText;
@property (weak, nonatomic) IBOutlet UILabel *lblapproximateTime;


@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *rateViewView;
@property (weak, nonatomic) IBOutlet UIView *invoiceView;
@property (weak, nonatomic) IBOutlet UIView *commonRateView;

@property (weak, nonatomic) IBOutlet UIScrollView *rateScrollView;

@property (weak, nonatomic) IBOutlet UITextField *commentsText;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, retain) IBOutlet UICollectionView  *hoursCollectionView;
@property(nonatomic,retain) IBOutlet UICollectionView *serviceListCollectionView;


///Select car
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectCarRequestBtn;
@property (weak, nonatomic) IBOutlet UIButton *app_RateRequestBtn;
@property (weak, nonatomic) IBOutlet UIView *selectCarView;
@property (weak, nonatomic) IBOutlet UIView *initialCommonView;
@property (weak, nonatomic) IBOutlet UIView *approximateRateView;


@property (weak, nonatomic) IBOutlet UILabel *modelNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *modelValueLbl;

//Waiting For Request
@property (weak, nonatomic) IBOutlet UIView *requestWaitingView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAnimation;

-(IBAction)onReqCancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;

//App_Rate
@property (weak, nonatomic) IBOutlet UILabel *app_RateHelpLbl;
@property (weak, nonatomic) IBOutlet UILabel *app_RateOptionsLbl;
@property (weak, nonatomic) IBOutlet UILabel *app_RateAmountLbl;
@property (weak, nonatomic) IBOutlet UIImageView *pickupImg;

@property (weak, nonatomic) IBOutlet UILabel *useWallet;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImg;
@property (weak, nonatomic) IBOutlet UILabel *walletAmount;
@property (weak, nonatomic) IBOutlet UIButton *walletCheckBox_Btn;

@property (weak, nonatomic) IBOutlet UIButton *scheduleBtn;


//Where to go
@property (weak, nonatomic) IBOutlet UILabel *whereLbl;
@property (weak, nonatomic) IBOutlet UIView *whereView;
@property (weak, nonatomic) IBOutlet UIButton *whereBtn;


@property (strong, nonatomic) NSString *sourceLat, *sourceLng, *destLat, *destLng;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *rating_default;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *rateToProvider;
- (IBAction)onGetRating:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblRatewithName;

- (IBAction)didChangeValue:(HCSStarRatingView *)sender;

//Invoice view

@property (weak, nonatomic) IBOutlet UILabel *invoice_WalletLbl;
@property (weak, nonatomic) IBOutlet UILabel *invoice_WalletAmt;

@property (weak, nonatomic) IBOutlet UILabel *invoice_discountAmt;
@property (weak, nonatomic) IBOutlet UILabel *invoice_discountLbl;

@property (weak, nonatomic) IBOutlet UILabel *lblWaitingforPayment;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblCommision;

@property (weak, nonatomic) IBOutlet UILabel *lblBacePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTaxPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmt;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentType;
@property (weak, nonatomic) IBOutlet UIImageView *ratingProviderImg;

@property (weak, nonatomic) IBOutlet UIImageView *imgPayment;
@property (weak, nonatomic) IBOutlet UILabel *invoiceIdLbl;


@property (weak, nonatomic) IBOutlet UIView *viewSourceandDestination;

@property (weak, nonatomic) IBOutlet UILabel *lblSource;
@property (weak, nonatomic) IBOutlet UILabel *lblDestination;
@property (weak, nonatomic) IBOutlet UILabel *lblCardName;
@property (weak, nonatomic) IBOutlet UIImageView *imgCard;

//DetailsView
@property (weak, nonatomic) IBOutlet UIView *serviceDetailsView;

@property (weak, nonatomic) IBOutlet UILabel *capacityLbl;
@property (weak, nonatomic) IBOutlet UILabel *fareLbl;
@property (weak, nonatomic) IBOutlet UILabel *kmLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@property (weak, nonatomic) IBOutlet UILabel *capacityValue;
@property (weak, nonatomic) IBOutlet UILabel *fareValue;
@property (weak, nonatomic) IBOutlet UILabel *priceValue;
@property (weak, nonatomic) IBOutlet UILabel *minValue;

@property (weak, nonatomic) IBOutlet UILabel *serviceNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImage;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;

//Category Button
@property (weak, nonatomic) IBOutlet UIButton *smallPackageBtn;
@property (weak, nonatomic) IBOutlet UIButton *bigPackageBtn;

//Map Animation

@property (nonatomic,strong) GMSMutablePath *path2;

@property (nonatomic,strong)NSMutableArray *arrayPolylineGreen;

@property (nonatomic,strong) GMSPolyline *polylineGray;


//Share and sos
@property (weak, nonatomic) IBOutlet UIButton *sosBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

//Surge
@property (weak, nonatomic) IBOutlet UILabel *surgeLbl;
@property (weak, nonatomic) IBOutlet UIView *surgeBgView;
@property (weak, nonatomic) IBOutlet UILabel *surge_XLbl;
@property (weak, nonatomic) IBOutlet UILabel *surge_XViewLbl;




@end
