
//  HomeViewController.m
//  User
//
//  Created by iCOMPUTERS on 12/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "HomeViewController.h"
#import "EmailViewController.h"
#import "WalletViewController.h"
#import "YourTripViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "ViewController.h"
#import "CSS_Class.h"
#import "config.h"
#import "Colors.h"
#import "Utilities.h"
#import "ProfileViewController.h"
#import "UIScrollView+EKKeyboardAvoiding.h"
#import "CouponsViewController.h"
#import "PaymentsViewController.h"
#import "HoursCollectionViewCell.h"

#import "CommenMethods.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AFNHelper.h"
#import "ServiceListCollectionViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImage+animatedGIF.h"
#import "FLAnimatedImage.h"

#import <SocketIO/SocketIO-Swift.h>
#import "UIView+Toast.h"

@interface HomeViewController ()
{
    CLLocation *myLocation;
    NSMutableArray *services;
    GMSCameraPosition *lastCameraPosition;
    CLLocationCoordinate2D newCoords;
    GMSMarker *endLocationMarker, *startLocationMarker ,*markerCarLocation, *providerMarkers;
    
    GMSCoordinateBounds *bounds;
    CLGeocoder *geocoder;
    AppDelegate *appDelegate;
    NSTimer *timerLocationUpdate,*timeRequestCheck;
    NSString *strServiceID,*strKM,*strProviderCell,*strRating;
    NSString *strSourceAddress,*strDestAddress;
   
    NSString *strCardID,*strCardLastNo;
    
    UIButton *btnCurrentLocation;
    SocketIOClient* socket;
    
    int nSocketCheck;
}
    
@property (nonatomic,retain)UIView*mapV;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self onClearLatLong];
    
    [self onLocationUpdateStart];
    
    [self onGetProfile];
    
    walletFlag = @"0";
    
    strCardID=@"";
    strCardLastNo=@"";
    scheduleStr = @"false";
    LoggedOut = false;
    serviceView_Height = 0;
        
    scheduleNav_Str =@"FALSE";

    socketConnectFlag = false;
    [self connectSocket];
    _rateToProvider.value=1;

    [self onRequestCheck];
    timeRequestCheck= [NSTimer scheduledTimerWithTimeInterval:5.0
                                                       target:self
                                                     selector:@selector(onRequestCheck)
                                                     userInfo:nil
                                                      repeats:YES];

    gotLocation = false;
    geocoder = [[CLGeocoder alloc] init];
    
    [_rateScrollView setContentSize:[_rateScrollView frame].size];
    [_rateScrollView setKeyboardAvoidingEnabled:YES];
    
    
    _mkap=[[GMSMapView alloc]initWithFrame:_mapView.frame];
    _mkap.myLocationEnabled = YES;
    _mkap.delegate=self;
    NSError *error;
    NSURL *url1 =[[NSBundle mainBundle] URLForResource:@"map_style" withExtension:@"json"];
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:url1 error:&error];
    
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    _mkap.mapStyle = style;
    [_mapView addSubview:_mkap];
    
    _arrayPolylineGreen = [[NSMutableArray alloc] init];
    _path2 = [[GMSMutablePath alloc]init];
    
    //Current Location Button
    btnCurrentLocation=[[UIButton alloc]initWithFrame:CGRectMake(_mapView.frame.size.width-60, _mapView.frame.origin.y+20, 50, 50)];
    [btnCurrentLocation addTarget:self action:@selector(onLocationUpdateStart) forControlEvents:UIControlEventTouchUpInside];
    [btnCurrentLocation setBackgroundImage:[UIImage imageNamed:@"tracker"] forState:UIControlStateNormal];
    btnCurrentLocation.hidden=NO;
    [_mapView addSubview:btnCurrentLocation];
    
    
    [self.view bringSubviewToFront:_mapView];
    [self.view bringSubviewToFront:_menuImgBtn];
    [self.view bringSubviewToFront:_menuBtn];
    [self.view bringSubviewToFront:_whereView];
    [self.view bringSubviewToFront:_viewSourceandDestination];
    
    [self.view bringSubviewToFront:_sosBtn];
    [self.view bringSubviewToFront:_shareBtn];
    
    [_shareBtn setHidden:YES];
    [_sosBtn setHidden:YES];
    
    hoursArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    arrServiceList=[[NSMutableArray alloc]init];
    selectedIndex = -1;
    serviceSelectIndex=0;
    
    date_pickerViewContainer                 = [[UIView alloc] init];
    date_datePicker                          = [[UIDatePicker alloc] init];
    date_pickerViewContainer.backgroundColor = [UIColor whiteColor];
    
    
    NSURL *urls = [[NSBundle mainBundle] URLForResource:@"location" withExtension:@"gif"];
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:urls]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(0.0, 0.0, 75.0, 75.0);
    [_imgAnimation addSubview:imageView];
    
    
    [_btnBack addTarget:self action:@selector(clear_BackBtn) forControlEvents:UIControlEventTouchDown];
    _BackView.hidden=YES;
    [self.view bringSubviewToFront:_menuView];
    
    UITapGestureRecognizer *lpgr = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(touched:)];
    lpgr.numberOfTapsRequired = 2.0;
    lpgr.delegate = self;
    [_serviceListCollectionView addGestureRecognizer:lpgr];
}
    
-(void)clear_BackBtn
    {
        [self onClearLatLong];
        [self onGetService];
    }

-(void)onClearLatLong
{
    [_whereBtn setUserInteractionEnabled:YES];
    strKM=@"";
    strServiceID=@"";
    strRating=@"1";
    _sourceLat =@"";
    _sourceLng =@"";
    _destLat =@"";
    _destLng =@"";
    _whereView.hidden=NO;
    _viewSourceandDestination.hidden=YES;
    [_mkap clear];
    GMSPolyline *polyline = nil;
    polyline.map = nil;
    
    _BackView.hidden=YES;
        _menuView.hidden=NO;
    [self.view bringSubviewToFront:_menuView];
    [UIView animateWithDuration:0.45 animations:^{
        
        _initialCommonView.frame = CGRectMake(self.view.frame.size.width*3, (self.view.frame.origin.y +self.view.frame.size.height - 250), self.view.frame.size.width,  250);
    }];
    [self onGetService];
    
}

#pragma mark
#pragma mark - Source and Destination Delegates Method
-(void)getLatLong:(NSString *)SourceLat :(NSString *)sourceLong :(NSString *)destLat :(NSString *)destLong :(NSString *)sourceAddress :(NSString *)destAddress
{
    [_mkap clear];
    GMSPolyline *polyline = nil;
    polyline.map = nil;
    
    _sourceLat =SourceLat;
    _sourceLng =sourceLong;
    _destLat =destLat;
    _destLng =destLong;
    strSourceAddress=sourceAddress;
    strDestAddress=destAddress;
    
    _viewSourceandDestination.hidden=NO;
    _whereView.hidden=YES;
    _lblSource.text=strSourceAddress;
    _lblDestination.text=strDestAddress;
    
    _menuView.hidden=YES;
    _BackView.hidden=NO;
    [self.view bringSubviewToFront:_BackView];
    
    [self loadMapView];
    [_serviceListCollectionView reloadData];
}

#pragma mark
#pragma mark - Choose Payment Delegates Method
-(void)onChangePaymentMode:(NSDictionary *)choosedPayment
{
    strCardID=[choosedPayment valueForKey:@"card_id"] ;
    strCardLastNo=[choosedPayment valueForKey:@"last_four"];
    
    if ([strCardID isEqualToString:@""])
    {
        _imgCard.image=[UIImage imageNamed:@"money_icon"];
        _lblCardName.text=@"CASH";
    }
    else
    {
        _imgCard.image=[UIImage imageNamed:@"visa"];
        _lblCardName.text=[NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@",[choosedPayment valueForKey:@"last_four"]];
    }
}

#pragma mark
#pragma mark - Get Current Location

-(void)onLocationUpdateStart
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    btnCurrentLocation.hidden=YES;
    [_locationManager stopUpdatingLocation];
    
    myLocation = newLocation; //(CLLocation *)[locations lastObject];
    NSLog(@"Location: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.latitude]);
    NSLog(@"Location: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.longitude]);
    
    NSString *strLat=[NSString stringWithFormat:@"%.8f", myLocation.coordinate.latitude];
    NSString *strLong=[NSString stringWithFormat:@"%.8f", myLocation.coordinate.longitude];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude
                                 
                                                            longitude:myLocation.coordinate.longitude
                                                                 zoom:16];
    
    [_mkap animateToCameraPosition:camera];
    NSLog(@"Resolving the Address");
        
    [geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks lastObject];
            currentAddress = [Utilities removeNullFromString: [NSString stringWithFormat:@"%@,%@,%@",placemark.name,placemark.locality,placemark.subAdministrativeArea]];
            NSLog(@"Placemark %@",currentAddress);
                        
            //Location Update to server
            NSDictionary *params=@{@"latitude":strLat,@"longitude":strLong,@"address":currentAddress};
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:MD_UPDATELOCATION withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
                if (response) {
                    
                }
            }];
        }
        else
        {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

-(void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
    if ([marker.userData isEqualToString:@"PICKUP"])
    {
        dragMarkerStr =@"PICKUP";
        NSLog(@"marker dragged to FromLocation: %f,%f", marker.position.latitude, marker.position.longitude);
        _sourceLat = [NSString stringWithFormat:@"%f", marker.position.latitude];
        _sourceLng = [NSString stringWithFormat:@"%f", marker.position.longitude];
        
        NSString *PickupAddressStr = [NSString stringWithFormat:@"%@",[self getAddressFromLatLon:[[NSString stringWithFormat:@"%f", marker.position.latitude] doubleValue] withLongitude:[[NSString stringWithFormat:@"%f", marker.position.longitude] doubleValue]]];
        _lblSource.text = [Utilities removeNullFromString:PickupAddressStr];
        NSLog(@"Pickup Address...%@", _lblSource.text);
    }
    else
    {
        dragMarkerStr =@"DROP";

        NSLog(@"marker dragged to FromLocation: %f,%f", marker.position.latitude, marker.position.longitude);
        _destLat = [NSString stringWithFormat:@"%f", marker.position.latitude];
        _destLng = [NSString stringWithFormat:@"%f", marker.position.longitude];
        
        NSString *addressStr = [NSString stringWithFormat:@"%@",[self getAddressFromLatLon:[_destLat doubleValue] withLongitude:[_destLng doubleValue]]];
        _lblDestination.text = [Utilities removeNullFromString:addressStr];
        NSLog(@"Pickup Address...%@", _lblDestination.text);
    }
     [self onMapReload];
}

-(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:pdblLatitude longitude:pdblLongitude];
    
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  if (placemark)
                  {
                      NSLog(@"placemark %@",placemark);
                      //String to hold address
                      NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                      NSLog(@"addressDictionary %@", placemark.addressDictionary);
                      
                      NSLog(@"placemark %@",placemark.region);
                      NSLog(@"placemark %@",placemark.country);  // Give Country Name
                      NSLog(@"placemark %@",placemark.locality); // Extract the city name
                      NSLog(@"location %@",placemark.name);
                      NSLog(@"location %@",placemark.ocean);
                      NSLog(@"location %@",placemark.postalCode);
                      NSLog(@"location %@",placemark.subLocality);
                      
                      NSLog(@"location %@",placemark.location);
                      //Print the location to console
                      NSLog(@"I am currently at %@",locatedAt);
                      locationString = locatedAt;
                      
                      if ([dragMarkerStr isEqualToString:@"DROP"])
                      {
                          _lblDestination.text = locationString;
                      }
                      else
                      {
                          _lblSource.text = locationString;
                      }
                  }
                  else {
                      NSLog(@"Could not locate");
                      locationString = @"";
                  }
              }
     ];
    [self onMapReload];
    return locationString;
}


#pragma mark - Own Method

-(void)onGetProfile
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [appDelegate onStartLoader];
        
        NSString* UDID_Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
        NSLog(@"output is : %@", UDID_Identifier);
        
       NSDictionary *params=@{@"device_token":appDelegate.strDeviceToken,@"device_type":@"ios", @"device_id":UDID_Identifier};
        
        [afn getDataFromPath:MD_GETPROFILE withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                if( [response[@"picture"] isKindOfClass:[NSNull class]] )
                    [user setValue:@"" forKey:UD_PROFILE_IMG];
                else
                    [user setValue:response[@"picture"] forKey:UD_PROFILE_IMG];
                
                NSString *nameStr = [NSString stringWithFormat:@"%@ %@", [Utilities removeNullFromString: response[@"first_name"]], [Utilities removeNullFromString: response[@"last_name"]]];
                
                [user setValue:nameStr forKey:UD_PROFILE_NAME];
                [user setValue:response[@"currency"] forKey:@"currency"];
                [user synchronize];
                
                categoryStr = @"SMALL";
                [self onGetService];
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
                }
            }
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
}

-(void)onGetService
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        // [appDelegate onStartLoader];
        [afn getDataFromPath:MD_GET_SERVICE withParamData:nil withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            arrServiceList=[[NSMutableArray alloc]init];
            
            serviceNameArray_Small = [[NSMutableArray alloc]init];
            serviceImageArray_Small = [[NSMutableArray alloc]init];
            serviceIDArray_Small = [[NSMutableArray alloc]init];
            
            serviceNameArray_Big = [[NSMutableArray alloc]init];
            serviceImageArray_Big = [[NSMutableArray alloc]init];
            serviceIDArray_Big = [[NSMutableArray alloc]init];
            
            if (response)
            {
                
                NSLog(@"Services....%@", response);
                
                arrServiceList= response;
                
                for (int i=0; i<[response count]; i++)
                {
                    NSDictionary *dict = [response objectAtIndex:i];
                    
                        [serviceImageArray_Small addObject:[dict valueForKey:@"image"]];
                        [serviceIDArray_Small addObject:[dict valueForKey:@"id"]];
                        [serviceNameArray_Small addObject:[dict valueForKey:@"name"]];
                }
                
                [_serviceListCollectionView reloadData];
            }
            else
            {
                if ([errorcode intValue]==1)
                {
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else if ([errorcode intValue]==3)
                {
//                    [CommenMethods onRefreshToken];
                    [self logoutMethod];
                }
            }
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setDesignStyles
{
    [_smallPackageBtn setBackgroundColor:BLACKCOLOR];
    _smallPackageBtn.layer.cornerRadius = _smallPackageBtn.frame.size.height/2;
    _smallPackageBtn.clipsToBounds = YES;
    [_smallPackageBtn setTitleColor:RGB(255, 255, 255)
                           forState:UIControlStateNormal];
    
    _bigPackageBtn.layer.cornerRadius = _bigPackageBtn.frame.size.height/2;
    _bigPackageBtn.clipsToBounds = YES;
    
    [_bigPackageBtn setBackgroundColor:RGB(255, 255, 255)];
    [_bigPackageBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    
    [CSS_Class APP_Blackbutton:_statusBtn];
    [CSS_Class APP_Blackbutton:_scheduleBtn];
    
    [CSS_Class APP_Blackbutton:_rejectBtn];
    [CSS_Class APP_Blackbutton:_paymentBtn];
    [CSS_Class APP_Blackbutton:_submitBtn];
    
    [CSS_Class APP_Blackbutton:_callBtn];
    [CSS_Class APP_Blackbutton:_selectCarRequestBtn];
    [CSS_Class APP_Blackbutton:_app_RateRequestBtn];
    [CSS_Class APP_SocialLabelName:_useWallet];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_notifyView.frame];
    _notifyView.layer.masksToBounds = NO;
    _notifyView.layer.shadowColor = [UIColor blackColor].CGColor;
    _notifyView.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _notifyView.layer.shadowOpacity = 0.5f;
    _notifyView.layer.shadowPath = shadowPath.CGPath;
    
    UIBezierPath *_initialView = [UIBezierPath bezierPathWithRect:_initialCommonView.frame];
    _initialCommonView.layer.masksToBounds = NO;
    _initialCommonView.layer.shadowColor = [UIColor blackColor].CGColor;
    _initialCommonView.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _initialCommonView.layer.shadowOpacity = 0.5f;
    _initialCommonView.layer.shadowPath = _initialView.CGPath;
    
    UIBezierPath *shadows = [UIBezierPath bezierPathWithRect:_commonRateView.frame];
    _commonRateView.layer.masksToBounds = NO;
    _commonRateView.layer.shadowColor = [UIColor blackColor].CGColor;
    _commonRateView.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _commonRateView.layer.shadowOpacity = 0.5f;
    _commonRateView.layer.shadowPath = shadows.CGPath;
    
    UIBezierPath *whereViewPath = [UIBezierPath bezierPathWithRect:_whereView.bounds];
    _whereView.layer.masksToBounds = NO;
    _whereView.layer.shadowColor = [UIColor blackColor].CGColor;
    _whereView.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _whereView.layer.shadowOpacity = 0.5f;
    _whereView.layer.shadowPath = whereViewPath.CGPath;
    
    UIBezierPath *viewSourceandDestinationPath = [UIBezierPath bezierPathWithRect:_viewSourceandDestination.bounds];
    _viewSourceandDestination.layer.masksToBounds = NO;
    _viewSourceandDestination.layer.shadowColor = [UIColor blackColor].CGColor;
    _viewSourceandDestination.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _viewSourceandDestination.layer.shadowOpacity = 0.5f;
    _viewSourceandDestination.layer.shadowPath = viewSourceandDestinationPath.CGPath;
    
    _userImg.layer.cornerRadius = _userImg.frame.size.height/2;
    _userImg.clipsToBounds = YES;
    
    _surge_XViewLbl.layer.cornerRadius = _surge_XViewLbl.frame.size.height/2;
    _surge_XViewLbl.clipsToBounds = YES;
    
    _ratingProviderImg.layer.cornerRadius = _ratingProviderImg.frame.size.height/2;
    _ratingProviderImg.clipsToBounds = YES;
    
    [CSS_Class APP_textfield_Outfocus:_commentsText];
    
    [_surgeBgView setHidden:YES];
}

-(IBAction)menuBtn:(id)sender
{
    [leftMenuViewClass setHidden:NO];
    [self LeftMenuView];
}

-(void)viewWillAppear:(BOOL)animated
{
    UITapGestureRecognizer *tapGesture_condition=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewOuterTap)];
    tapGesture_condition.cancelsTouchesInView=NO;
    tapGesture_condition.delegate=self;
    [self.view addGestureRecognizer:tapGesture_condition];
    
    leftMenuViewClass = [[[NSBundle mainBundle] loadNibNamed:@"LeftMenuView" owner:self options:nil] objectAtIndex:0];
    [leftMenuViewClass setFrame:CGRectMake(-(self.view.frame.size.width - 100), 0, self.view.frame.size.width - 100, self.view.frame.size.height)];
    
    leftMenuViewClass.LeftMenuViewDelegate =self;
    leftMenuViewClass.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:leftMenuViewClass];
    [leftMenuViewClass setHidden:YES];
    [self setDesignStyles];
    
    [self onGetService];
}

#pragma mark
#pragma mark - Slide Menu controllers

-(void)LeftMenuView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        leftMenuViewClass.frame = CGRectMake(0, 0, self.view.frame.size.width - 100,  self.view.frame.size.height);
        
    }];
    waitingBGView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width  ,self.view.frame.size.height)];
    
    [waitingBGView setBackgroundColor:[UIColor blackColor]];
    [waitingBGView setAlpha:0.6];
    [self.view addSubview:waitingBGView];
    [self.view bringSubviewToFront:leftMenuViewClass];
}

- (void)ViewOuterTap
{
    [UIView animateWithDuration:0.3 animations:^{
        
        leftMenuViewClass.frame = CGRectMake(-(self.view.frame.size.width - 100), 0, self.view.frame.size.width - 100,  self.view.frame.size.height);
        
    }];
    
    [waitingBGView removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer* )gestureRecognizer shouldReceiveTouch:(UITouch* )touch
{
    if ([touch.view isDescendantOfView:leftMenuViewClass])
    {
        return NO;
    }
    return YES;
}

-(void)yourTripsView
{
    [self ViewOuterTap];
    YourTripViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"YourTripViewController"];
    [self.navigationController pushViewController:wallet animated:YES];
}
-(void)walletView
{
    [self ViewOuterTap];
    WalletViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"WalletViewController"];
    [self presentViewController:wallet animated:YES completion:nil];
}

-(void)helpView
{
    [self ViewOuterTap];
    HelpViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
    [self presentViewController:wallet animated:YES completion:nil];
}
    
-(void)shareView
    {
        [self ViewOuterTap];
        UIImage *img = [UIImage imageNamed:@"icon"];
        NSMutableArray *sharingItems = [NSMutableArray new];
        [sharingItems addObject:@"TRANXIT"];
        [sharingItems addObject:img];
        [sharingItems addObject:[NSURL URLWithString:@"https://itunes.apple.com/us/app/tranxit/id1204487551?mt=8"]];
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
        [self presentViewController:activityController animated:YES completion:nil];
    }

-(void)profileView
{
    [self ViewOuterTap];
    ProfileViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self presentViewController:wallet animated:YES completion:nil];
}

-(void)logOut
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Are you sure want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self logoutMethod_FromApp];
        
    }];
    [alertController addAction:ok];
    [alertController addAction:no];
    [self presentViewController:alertController animated:YES completion:nil];
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

-(void)logoutMethod_FromApp
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [appDelegate onStartLoader];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *idStr = [defaults valueForKey:UD_ID];
        NSDictionary *param = @{@"id":idStr};
        
        [afn getDataFromPath:MD_LOGOUT withParamData:param withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                LoggedOut = true;
                
                [self ViewOuterTap];
                [socket disconnect];
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLoggedin"];
                
                ViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                [self.navigationController pushViewController:wallet animated:YES];
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

-(void)payments
{
    [self ViewOuterTap];
    PaymentsViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentsViewController"];
    wallet.fromWhereStr = @"LEFT MENU";
    [self.navigationController pushViewController:wallet animated:YES];
}

-(void)coupons
{
    [self ViewOuterTap];
    CouponsViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"CouponsViewController"];
    [self.navigationController pushViewController:wallet animated:YES];
}

-(IBAction)rejectBtn:(id)sender
{
    [_statusView setHidden:YES];
}

-(IBAction)callBtn:(id)sender
{
    if ([strProviderCell isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Driver was not provided the number to call." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:strProviderCell]];
        NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:strProviderCell]];
        
        if ([UIApplication.sharedApplication canOpenURL:phoneUrl])
        {
            [UIApplication.sharedApplication openURL:phoneUrl options:@{} completionHandler:nil];
        }
        else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl])
        {
            [UIApplication.sharedApplication openURL:phoneFallbackUrl options:@{} completionHandler:nil];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Your device does not support calling" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];    }
    }
}

- (IBAction)statusBtnAction:(id)sender
{
    [UIView animateWithDuration:0.45 animations:^{
        
        _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +50), self.view.frame.size.width,  185);
    }];
    
    [UIView animateWithDuration:0.45 animations:^{
        
        _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height - 300), self.view.frame.size.width,  300);
        
        [self.view bringSubviewToFront:_commonRateView];
        
    }];
}

- (IBAction)paymentBtnAction:(id)sender
{
    if ([appDelegate internetConnected])
    {
    
        NSString *strReqID=[[NSUserDefaults standardUserDefaults] valueForKey:UD_REQUESTID];
        NSDictionary *params=@{@"request_id":strReqID};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:MD_PAYMENT withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    _invoiceView.frame = CGRectMake( -self.view.frame.size.width, 0, self.view.frame.size.width, 300);
                    
                    _rateViewView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
                    
                }];
            }
            else
            {
                if ([errorcode intValue]==1)
                {
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else if ([errorcode intValue]==3)
                {
//                    [CommenMethods onRefreshToken];
                    [self logoutMethod];
                }
                else if ([errorcode intValue]==2)
                {
                    if ([error objectForKey:@"rating"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"rating"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else if([error objectForKey:@"comments"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"comments"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else if([error objectForKey:@"is_favorite"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"is_favorite"] objectAtIndex:0]  viewController:self okPop:NO];
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
- (IBAction)didChangeValue:(HCSStarRatingView *)sender
{
    //%.02f
    strRating=[NSString stringWithFormat:@"%.f",sender.value];
    NSLog(@"%@",strRating);
}

- (IBAction)submitBtnAction:(id)sender
{
    if ([appDelegate internetConnected])
    {
        NSString *strReqID=[[NSUserDefaults standardUserDefaults] valueForKey:UD_REQUESTID];
        NSDictionary *params=@{@"request_id":strReqID,@"rating":strRating,@"comment":_commentsText.text};
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:MD_RATE_PROVIDER withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                _rateToProvider.value=1;
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_REQUESTID];
                [self onClearLatLong];
                strRating=@"1";
                _commentsText.text=@"";
                [UIView animateWithDuration:0.45 animations:^{
                    _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +30), self.view.frame.size.width,  300);
                }];
                
                [UIView animateWithDuration:0.45 animations:^{
                    
                    _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +20), self.view.frame.size.width,  220);
                }];
            }
            else
            {
                if ([errorcode intValue]==1)
                {
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else if ([errorcode intValue]==3)
                {
//                    [CommenMethods onRefreshToken];
                    [self logoutMethod];
                }
                else if ([errorcode intValue]==2)
                {
                    if ([error objectForKey:@"rating"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"rating"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else if([error objectForKey:@"comments"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"comments"] objectAtIndex:0]  viewController:self okPop:NO];
                    }
                    else if([error objectForKey:@"is_favorite"]) {
                        [CommenMethods alertviewController_title:@"" MessageAlert:[[error objectForKey:@"is_favorite"] objectAtIndex:0]  viewController:self okPop:NO];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_commentsText)
    {
        [_commentsText resignFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

-(IBAction)selectCarRequestBtn:(id)sender
{
    scheduleStr = @"false";
    
    [self onGetFareEsitmate];

//    if ([strCardID isEqualToString:@""])
//    {
//       // strPay=@"CASH";
//        [CommenMethods alertviewController_title:NSLocalizedString(@"ALERT", nil)  MessageAlert:@"Please add a card to proceed" viewController:self okPop:NO];
//    }
//    else
//    {
//      [self onGetFareEsitmate];
//    }
}

-(IBAction)walletBtnAction:(id)sender
{
    if ([walletFlag isEqualToString:@"0"])
    {
       walletFlag = @"1";
       _checkBoxImg.image = [UIImage imageNamed:@"checked"];
        
    }
    else
    {
        walletFlag = @"0";
        _checkBoxImg.image = [UIImage imageNamed:@"uncheck"];
    }
}

-(IBAction)app_RateRequestBtn:(id)sender
{
    if ([appDelegate internetConnected])
    {
        NSString *strPay=@"";
         if ([strCardID isEqualToString:@""])
         {
             strPay=@"CASH";
            //  [CommenMethods alertviewController_title:NSLocalizedString(@"ALERT", nil)  MessageAlert:@"Tilføj venligst et kort for at fortsætte" viewController:self okPop:NO];
         }
        else
            strPay=[NSString stringWithFormat:@"CARD"];
        NSDictionary *params;
        if ([scheduleStr isEqualToString:@"true"])
        {
            
            NSArray *dateArr = [scheduleDate.text componentsSeparatedByString:@" "];
            NSString *schDate = [dateArr objectAtIndex:0];
            NSString *schtime = [dateArr objectAtIndex:1];
            
            params=@{@"s_latitude":_sourceLat,@"s_longitude":_sourceLng,@"d_latitude":_destLat,@"d_longitude":_destLng,@"service_type":strServiceID,@"distance":strKM,@"payment_mode":strPay,@"card_id":strCardID,@"s_address":strSourceAddress,@"d_address":strDestAddress, @"use_wallet":walletFlag, @"schedule_date": schDate, @"schedule_time": schtime};
        }
        else
        {
            params=@{@"s_latitude":_sourceLat,@"s_longitude":_sourceLng,@"d_latitude":_destLat,@"d_longitude":_destLng,@"service_type":strServiceID,@"distance":strKM,@"payment_mode":strPay,@"card_id":strCardID,@"s_address":strSourceAddress,@"d_address":strDestAddress, @"use_wallet":walletFlag};
        }
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:MD_CREATE_REQUEST withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                [_surgeBgView setHidden:YES];

                if ([scheduleStr isEqualToString:@"true"])
                {
                    scheduleNav_Str =@"TRUE";
                }
                NSString *reqStr = [[response objectForKey:@"request_id"] stringValue];
                if ([reqStr isEqualToString:@""] || reqStr.length ==0)
                {
                    [CommenMethods alertviewController_title:NSLocalizedString(@"ALERT", nil)  MessageAlert:[response objectForKey:@"message"] viewController:self okPop:NO];
                }
                else
                {
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    [user setValue:[NSString stringWithFormat:@"%@",response[@"request_id"]] forKey:UD_REQUESTID];
                    [UIView animateWithDuration:0.45 animations:^{
                        
                        _initialCommonView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +30), self.view.frame.size.width,  300);
                        
                        _selectCarView.frame = CGRectMake( 0, 0, self.view.frame.size.width, 300);
                        _approximateRateView.frame = CGRectMake(self.view.frame.size.width+5, 0, self.view.frame.size.width, 300);
                        
                    }];
                    
                    [_requestWaitingView setHidden:NO];
                    [UIView animateWithDuration:0.45 animations:^{
                        
                        _requestWaitingView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                        
                        [self.view bringSubviewToFront:_requestWaitingView];
                    }];
                }
            }
            else
            {
                if ([errorcode intValue]==1)
                {
                    if ([error objectForKey:@"error"])
                        [CommenMethods alertviewController_title:@"" MessageAlert:[error objectForKey:@"error"] viewController:self okPop:NO];
                    else
                        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else if ([errorcode intValue]==3)
                {
                    [self logoutMethod];
                }
            }
            
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
}

-(void)helpPopUp
{
    {
        backgroundView_Pop = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        [backgroundView_Pop setBackgroundColor:[UIColor blackColor]];
        [backgroundView_Pop setAlpha:0.6];
        [self.view addSubview:backgroundView_Pop];
        
        [UIView animateWithDuration:0.45 animations:^{
            
            _serviceDetailsView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height-300+serviceView_Height), self.view.frame.size.width, 300);
        }];

        _serviceDetailsView.clipsToBounds = NO;
        _serviceDetailsView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_serviceDetailsView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
        [tapGestureRecognizer setDelegate:self];
        [backgroundView_Pop addGestureRecognizer:tapGestureRecognizer];
    }
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self closeActionPop];
}


-(IBAction)pickUpDrop:(id)sender
{
    pickUpDrop.selected = YES;
    fixedHrs.selected = NO;
    
    [_app_RateHelpLbl setText:@"Including all other charges"];
    [_app_RateOptionsLbl setText:@"Pickup & Drop"];
    [_pickupImg setHidden:NO];
    [_hoursCollectionView setHidden:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        _initialCommonView.frame = CGRectMake(0, self.view.frame.size.height-180, self.view.frame.size.width,  300);
        _selectCarView.frame = CGRectMake( -self.view.frame.size.width, 0, self.view.frame.size.width, 210);
        _approximateRateView.frame = CGRectMake(0, 0, self.view.frame.size.width, 180);
        _surgeBgView.frame = CGRectMake(0,-80, self.view.frame.size.width, 80);
        [self.view bringSubviewToFront:_initialCommonView];
    }];
}


-(IBAction)fixedHrs:(id)sender
{
    fixedHrs.selected = YES;
    pickUpDrop.selected = NO;
    
    [_app_RateHelpLbl setText:@"How many hours do you need"];
    [_app_RateOptionsLbl setText:@"Fixed hours"];
    [_pickupImg setHidden:YES];
    [_hoursCollectionView setHidden:NO];
    [_hoursCollectionView reloadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _selectCarView.frame = CGRectMake( -self.view.frame.size.width, 0, self.view.frame.size.width, 300);
        _approximateRateView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
        
    }];
}

-(IBAction)changePaymentBtn:(id)sender
{
    PaymentsViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentsViewController"];
    wallet.fromWhereStr = @"HOME";
    wallet.delegate=self;
    [self presentViewController:wallet animated:YES completion:nil];
}

-(IBAction)whereBtn:(id)sender
{
    LocationViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];
    wallet.delegate=self;
    if ([currentAddress isEqualToString:@""])
    {
        currentAddress = @"";
    }
    else
    {
        
    }
    wallet.currentAddress = currentAddress;
    [self presentViewController:wallet animated:YES completion:nil];
    
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    btnCurrentLocation.hidden=NO;
    [_mapView bringSubviewToFront:btnCurrentLocation];
    
}

-(void)loadMapView
{
    [self onMapReload];
    
    if ([strCardID isEqualToString:@""])
    {
        _imgCard.image=[UIImage imageNamed:@"money_icon"];
        _lblCardName.text=@"CASH";
    }
    
 //   [self smallPackageBtn:self];
    
    [UIView animateWithDuration:0.45 animations:^{
        
        _initialCommonView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height - 250), self.view.frame.size.width,  250);
        _selectCarView.frame = CGRectMake( 0, 0, self.view.frame.size.width, 250);
        
        _approximateRateView.frame = CGRectMake(self.view.frame.size.width+5, 0, self.view.frame.size.width, 220);
        [self.view bringSubviewToFront:_initialCommonView];
        
    }];
}

//-(IBAction)smallPackageBtn:(id)sender
//{
//    [_bigPackageBtn setBackgroundColor:RGB(255, 255, 255)];
//    [_bigPackageBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
//    
//    [_smallPackageBtn setBackgroundColor:BLACKCOLOR];
//    [_smallPackageBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
//    
//    serviceNameArray = [[NSMutableArray alloc]init];
//    serviceImageArray = [[NSMutableArray alloc]init];
//    serviceIDArray = [[NSMutableArray alloc]init];
//    
//    [serviceNameArray addObjectsFromArray:serviceNameArray_Small];
//    [serviceImageArray addObjectsFromArray:serviceImageArray_Small];
//    [serviceIDArray addObjectsFromArray:serviceIDArray_Small];
//    
//    [_serviceListCollectionView reloadData];
//    
//}
//
//-(IBAction)bigPackageBtn:(id)sender
//{
//    [_smallPackageBtn setBackgroundColor:RGB(255, 255, 255)];
//    [_smallPackageBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
//    
//    [_bigPackageBtn setBackgroundColor:BLACKCOLOR];
//    [_bigPackageBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
//    
//    serviceNameArray = [[NSMutableArray alloc]init];
//    serviceImageArray = [[NSMutableArray alloc]init];
//    serviceIDArray = [[NSMutableArray alloc]init];
//    
//    [serviceNameArray addObjectsFromArray:serviceNameArray_Big];
//    [serviceImageArray addObjectsFromArray:serviceImageArray_Big];
//    [serviceIDArray addObjectsFromArray:serviceIDArray_Big];
//    
//    [_serviceListCollectionView reloadData];
//
//}

- (void)getPath
{
    NSString *googleUrl = @"https://maps.googleapis.com/maps/api/directions/json";
    
    NSString *urlString = [NSString stringWithFormat:@"%@?origin=%@,%@&destination=%@,%@&sensor=false&waypoints=%@&mode=driving", googleUrl, _sourceLat, _sourceLng, _destLat, _destLng, @""];
    
    NSLog(@"my driving api URL --- %@", urlString);
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error)
      {
          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
          
          NSArray *routesArray = [json objectForKey:@"routes"];
          
          if ([routesArray count] > 0)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  GMSPolyline *polyline = nil;
                  [polyline setMap:nil];
                  NSDictionary *routeDict = [routesArray objectAtIndex:0];
                  NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                  NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                  GMSPath *path = [GMSPath pathFromEncodedPath:points];
                  polyline = [GMSPolyline polylineWithPath:path];
                  polyline.strokeWidth = 3.f;
                  polyline.strokeColor = BLACKCOLOR;
                  polyline.map = _mkap;
                  [_mkap animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:80.0f]];
                  
//                  [NSTimer scheduledTimerWithTimeInterval:0.000003 repeats:true block:^(NSTimer * _Nonnull timer) {
//                      [self animate:path];
//                  }];
              });
          }
      }] resume];
    
}

-(void)animate:(GMSPath *)path {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (i < path.count) {
            [_path2 addCoordinate:[path coordinateAtIndex:i]];
            _polylineGray = [GMSPolyline polylineWithPath:_path2];
            _polylineGray.strokeColor = [UIColor grayColor];
            _polylineGray.strokeWidth = 3.f;
            _polylineGray.map = _mkap;
            [_arrayPolylineGreen addObject:_polylineGray];
            i++;
        }
        else {
            i = 0;
            _path2 = [[GMSMutablePath alloc] init];
            
            for (GMSPolyline *line in _arrayPolylineGreen) {
                line.map = nil;
            }
            
        }
    });
}

-(IBAction)scheduleBtn:(id)sender
{
//    [UIView animateWithDuration:0.45 animations:^{
//        
//        _initialCommonView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +300), self.view.frame.size.width,  300);
//    }];
    
    [scheduleDate removeFromSuperview];
    [self setDate];
}

#pragma mark -- date
- (void)setDate
{
    @try
    {
        [self.view endEditing:YES];
        
        date_pickerViewContainer.frame = CGRectMake(0, (self.view.bounds.size.height)-250, self.view.bounds.size.width, 250);
        date_datePicker.frame=CGRectMake(0, 55, self.view.frame.size.width, 140);
        date_datePicker.hidden = NO;
        date_datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [date_datePicker addTarget:self action:@selector(dateChangedValue) forControlEvents:UIControlEventValueChanged]; //no.2
        
        
        backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        backgroundView.alpha = 0.4f;
        backgroundView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:backgroundView];
        
        UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(16, 8, 200, 21)];
        header.text = @"Schedule a ride";
        [CSS_Class APP_labelName:header];
        [date_pickerViewContainer addSubview:header];
        
        scheduleDate = [[UILabel alloc]initWithFrame:CGRectMake(16, 30, 280, 21)];
        NSDate *now = [[NSDate alloc] init];
        now = [now dateByAddingTimeInterval:120];
        
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc]init];
        [DateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [DateFormatter setDateFormat:@"dd-MM-yyyy hh:mma"];
        scheduleDate.text =[DateFormatter stringFromDate:now];
        
        [CSS_Class APP_fieldValue_Small:scheduleDate];
        [date_pickerViewContainer addSubview:scheduleDate];
        
        UILabel *lineLbl = [[UILabel alloc]initWithFrame:CGRectMake(16, 53, 288, 1)];
        lineLbl.backgroundColor = RGB(200, 200, 200);
        [date_pickerViewContainer addSubview:lineLbl];
        
        UIButton *PickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [PickerBtn addTarget:self
                            action:@selector(setDateFromPicker)
                  forControlEvents:UIControlEventTouchUpInside];
        PickerBtn.frame = CGRectMake(date_datePicker.frame.size.width-290, 190, 260, 40);
        [PickerBtn setTitle:@"SCHEDULE REQUEST" forState:UIControlStateNormal];
        [CSS_Class APP_Blackbutton:PickerBtn];
        
        [date_pickerViewContainer addSubview:date_datePicker];
        [date_pickerViewContainer addSubview:PickerBtn];
        
        /// From Current Date
        
        NSCalendar *calendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *max_DateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:now];
        
        NSInteger day = [max_DateComponents day];
        [max_DateComponents setDay:day + 7];
        
        NSDate *maxDate = [calendar dateFromComponents:max_DateComponents];
        
        date_datePicker.minimumDate = now;
        date_datePicker.maximumDate = maxDate;
        
        [self.view addSubview:date_pickerViewContainer];
        
         UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canceldatePick)];
        [tapGestureRecognizer setDelegate:self];
        [backgroundView addGestureRecognizer:tapGestureRecognizer];
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}

- (void)dateChangedValue
{
    @try
    {
        NSArray *listofViews = [date_pickerViewContainer subviews];
        
        for(UIView *subView in listofViews)
        {
            if([subView isKindOfClass:[UIDatePicker class]])
            {
                scheduleDate.text = @"";
                pickerDate = [(UIDatePicker *)subView date];
            }
        }
        
        NSDate *now = [[NSDate alloc] init];
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc]init];
        [DateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        NSString *date=[DateFormatter stringFromDate:now];
        [DateFormatter setDateFormat:@"dd-MM-yyyy hh:mma"];
        date=[DateFormatter stringFromDate:now];
        [scheduleDate setText:[DateFormatter stringFromDate:pickerDate]];
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}

-(void)setDateFromPicker
{
    scheduleStr = @"true";
    [self canceldatePick];
    [self app_RateRequestBtn:self];
}

- (void)canceldatePick
{
    [date_pickerViewContainer removeFromSuperview];
    [backgroundView removeFromSuperview];
}



-(void)closeActionPop
{
    [backgroundView_Pop removeFromSuperview];
//    [popUpView removeFromSuperview];
    
    [UIView animateWithDuration:0.45 animations:^{
        
        _serviceDetailsView.frame = CGRectMake(0, self.view.frame.origin.y +self.view.frame.size.height+10, self.view.frame.size.width,  300);
    }];
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

-(void)start
{
    loading = [LoadingViewClass new];
    [loading startLoading];
}

-(void)stop
{
    [loading stopLoading];
}

#pragma mark - Collection View Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==_serviceListCollectionView)
    {
        return [serviceIDArray_Small count];
    }
    else{
        return [hoursArray count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==_serviceListCollectionView)
    {
        ServiceListCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceListCollectionViewCell"forIndexPath:indexPath];
        
        NSDictionary *dictVal=[arrServiceList objectAtIndex:indexPath.row];
        cell.lblServiceName.text=[dictVal valueForKey:@"name"];
        
        if (serviceSelectIndex==indexPath.row)
        {
            strServiceID=[NSString stringWithFormat:@"%@",[serviceIDArray_Small objectAtIndex:indexPath.row]];
            _modelValueLbl.text=[NSString stringWithFormat:@"%@",[serviceNameArray_Small objectAtIndex:indexPath.row]];

            [cell.lblServiceName setBackgroundColor:BLACKCOLOR];
            cell.lblServiceName.layer.cornerRadius = cell.lblServiceName.frame.size.height/2;
            cell.lblServiceName.clipsToBounds = YES;
          //  cell.lblServiceName.textColor = RGB(255, 255, 255);
            cell.lblServiceName.textColor = [UIColor whiteColor];

        }
        else
        {
            [CSS_Class APP_fieldValue:cell.lblServiceName];
        }
        
        NSString *strProfile = [Utilities removeNullFromString:[serviceImageArray_Small objectAtIndex:indexPath.row]];
        
        if (![strProfile isKindOfClass:[NSNull class]])
        {
            if ([strProfile length]!=0)
            {
                [ cell.imgService sd_setImageWithURL:[NSURL URLWithString:strProfile]
                                    placeholderImage:[UIImage imageNamed:@"sedan-car-model"]];
            }
        }
        else
        {
            cell.imgService.image=[UIImage imageNamed:@"sedan-car-model"];
        }
        cell.imgSelected.hidden=YES;
        
        return cell;
        
    }
    else
    {
        HoursCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HoursCollectionViewCell"forIndexPath:indexPath];
        cell.numberLbl.text = [NSString stringWithFormat:@"%@", [hoursArray objectAtIndex:indexPath.row]];
        [CSS_Class App_Header:cell.numberLbl];
        [cell.numberLbl setTextColor:BLACKCOLOR];
        
        if (selectedIndex==indexPath.row)
        {
            [cell.selectedImg setHidden:NO];
        }
        else
        {
            [cell.selectedImg setHidden:YES];
        }
        
        return cell;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView==_serviceListCollectionView)
        return [arrServiceList count];
    else
        return hoursArray.count;
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==_serviceListCollectionView)
    {
        serviceSelectIndex=indexPath.row;
        strServiceID=[NSString stringWithFormat:@"%@",[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"id"]];
        _modelValueLbl.text =[NSString stringWithFormat:@"%@",[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"name"]];

        [_serviceListCollectionView reloadData];
        
        if (![[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"image"] isKindOfClass:[NSNull class]])
        {
            NSString *strProfile = [[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"image"];
            if ([strProfile length]!=0)
            {
                [ _serviceImage sd_setImageWithURL:[NSURL URLWithString:strProfile]
                                  placeholderImage:[UIImage imageNamed:@"sedan-car-model"]];
            }
        }
        else
        {
            _serviceImage.image=[UIImage imageNamed:@"sedan-car-model"];
        }
        
        NSString *calculator =[NSString stringWithFormat:@"%@",[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"calculator"]];
        
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *currencyStr=[Utilities removeNullFromString: [user valueForKey:@"currency"]];
        
        _fareValue.text =[NSString stringWithFormat:@"%@%@",currencyStr,[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"fixed"]];
        
        _capacityValue.text =[NSString stringWithFormat:@"%@ People",[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"capacity"]];
        
        NSString *descriptionStr =[Utilities removeNullFromString:[NSString stringWithFormat:@"%@",[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"description"]]];
        
        if ([descriptionStr isEqualToString:@""])
        {
            serviceView_Height = 65;
        }
        else
        {
            _descriptionLbl.text =descriptionStr;
            serviceView_Height = 0;
        }
        
        _serviceNameLbl.text =[NSString stringWithFormat:@"%@",[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"name"]];
        
        [_priceValue setHidden:YES];
        [_priceLbl setHidden:YES];
        
        if ([calculator isEqualToString:@"DISTANCE"])
        {
            _kmLbl.text =@"per Km";
            _minValue.text =[NSString stringWithFormat:@"%@%@",currencyStr,[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"price"]];
        }
        else if ([calculator isEqualToString:@"DISTANCEMIN"] || [calculator isEqualToString:@"DISTANCEHOUR"])
        {
            [_priceValue setHidden:NO];
            [_priceLbl setHidden:NO];
            
            _kmLbl.text =@"per min";
            _minValue.text =[NSString stringWithFormat:@"%@%@",currencyStr,[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"minute"]];
            
            _priceValue.text =[NSString stringWithFormat:@"%@%@",currencyStr,[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"price"]];
            
        }
        else if ([calculator isEqualToString:@"MIN"] || [calculator isEqualToString:@"HOUR"])
        {
            _kmLbl.text =@"per min";
            _minValue.text =[NSString stringWithFormat:@"%@%@",currencyStr,[[arrServiceList objectAtIndex:indexPath.row] valueForKey:@"minute"]];
        }
        
        [self getProvidersInCurrentLocation];
    }
    else
    {
        selectedIndex=indexPath.row;
        [_hoursCollectionView reloadData];
    }
}

-(void)touched:(UIGestureRecognizer *)tap{
    
    NSLog(@"the touch happened");
    [self helpPopUp];
}

-(void)getProvidersInCurrentLocation
{
    [self onMapReload];
    
    NSString *strLat=[NSString stringWithFormat:@"%.8f", myLocation.coordinate.latitude];
    NSString *strLong=[NSString stringWithFormat:@"%.8f", myLocation.coordinate.longitude];
    
    if ([appDelegate internetConnected])
    {
        NSDictionary *params=@{@"latitude":strLat,@"longitude":strLong,@"service":strServiceID};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:MD_GETPROVIDERS withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            if (response)
            {
                NSLog(@"CALLED");
                
                if([response isKindOfClass:[NSArray class]])
                {
                    if ([response count]!=0)
                    {
                        for (int j=0; j<[response count]; j++)
                        {
                            NSDictionary *providerDict = [response objectAtIndex:j];
                            
                            NSString *latStr = [providerDict valueForKey:@"latitude"];
                            NSString *longStr = [providerDict valueForKey:@"longitude"];
                            
                            providerMarkers=[[GMSMarker alloc]init];
                            providerMarkers.position=CLLocationCoordinate2DMake([latStr doubleValue], [longStr doubleValue]);
                            providerMarkers.groundAnchor=CGPointMake(0.5,0.5);
                            providerMarkers.draggable = NO;
                            providerMarkers.icon = [UIImage imageNamed:@"car"];
                            providerMarkers.map=_mkap;
                        }
                    }
                    else
                    {
                      //DO NOTHING
                    }
                }
                else if([response isKindOfClass:[NSDictionary class]])
                {
                   NSString *error = [Utilities removeNullFromString:[response objectForKey:@"message"]];
                   NSLog(@"NO PROVIDERS....%@",error);
                    
                    [self onMapReload];
                }
                else
                {
                    
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
                } 
                
            }
            
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
}

-(void)onGetFareEsitmate
{
    if ([appDelegate internetConnected])
    {
        NSDictionary *params=@{@"s_latitude":_sourceLat,@"s_longitude":_sourceLng,@"d_latitude":_destLat,@"d_longitude":_destLng,@"service_type":strServiceID};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:MD_GET_FAREESTIMATE withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                NSLog(@"ESTIMATE...%@", response);
                if (![response[@"estimated_fare"] isKindOfClass:[NSNull class]]) {
                    
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    NSString *currencyStr=[Utilities removeNullFromString: [user valueForKey:@"currency"]];
                    NSString *surge = [NSString stringWithFormat:@"%@", [response valueForKey:@"surge"]];

                    _app_RateAmountLbl.text= [NSString stringWithFormat:@"%@%@" , currencyStr, response[@"estimated_fare"]];
                    _lblapproximateTime.text=response[@"time"];
                    NSString *amountStr = [NSString stringWithFormat:@"%@", [response valueForKey:@"wallet_balance"]];
                    _walletAmount.text = [NSString stringWithFormat:@"%@%@", currencyStr, amountStr];
                    
                    if ([amountStr isEqualToString:@"0"])
                    {
                        [_useWallet setHidden:YES];
                        [_walletCheckBox_Btn setHidden:YES];
                        [_checkBoxImg setHidden:YES];
                        [_walletAmount setHidden:YES];
                    }
                    else
                    {
                        [_useWallet setHidden:NO];
                        [_walletCheckBox_Btn setHidden:NO];
                        [_checkBoxImg setHidden:NO];
                        [_walletAmount setHidden:NO];
                    }
                    
                    if ([surge isEqualToString:@"1"])
                    {
                        [_surgeLbl setText:@"Due to high demand price may vary"];
                        _surge_XLbl.text = [NSString stringWithFormat:@"%@", [response valueForKey:@"surge_value"]];
                        
                        [_surgeBgView setHidden:NO];
                    }
                    
                    [_whereBtn setUserInteractionEnabled:NO];
                }
                if (![response[@"distance"] isKindOfClass:[NSNull class]]) {
                    strKM=response[@"distance"];
                }
                [self pickUpDrop:nil];
            }
            else
            {
                if ([errorcode intValue]==1)
                {
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
                else if ([errorcode intValue]==3)
                {
//                    [CommenMethods onRefreshToken];
                    [self logoutMethod];
                }
                
            }
            
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
    
}

-(IBAction)onReqCancel:(id)sender
{
    if ([appDelegate internetConnected])
    {
        NSString *strReqID=[[NSUserDefaults standardUserDefaults] valueForKey:UD_REQUESTID];
        
        NSDictionary *params=@{@"request_id":strReqID};
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [appDelegate onStartLoader];
        [afn getDataFromPath:MD_CANCEL_REQUEST withParamData:params withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            [appDelegate onEndLoader];
            if (response)
            {
                
                [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:UD_REQUESTID];
                _requestWaitingView.hidden=YES;
                
                [UIView animateWithDuration:0.45 animations:^{
                    _commonRateView.frame = CGRectMake(-self.view.frame.size.width, (self.view.frame.origin.y +self.view.frame.size.height -300), self.view.frame.size.width,  300);
                }];
                
                [UIView animateWithDuration:0.45 animations:^{
                    
                    _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +20), self.view.frame.size.width,  220);
                }];
            }
            else
            {
                
                if ([errorcode intValue]==1)
                {
                    [CommenMethods alertviewController_title:@"Error!" MessageAlert:[error objectForKey:@"error"] viewController:self okPop:NO];
                }
                else if ([errorcode intValue]==3)
                {
//                    [CommenMethods onRefreshToken];
                    [self logoutMethod];
                }
                else
                {
                    [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"ERRORMSG", nil) viewController:self okPop:NO];
                }
            }
            [self onClearLatLong];
            _requestWaitingView.hidden=YES;
            
        }];
    }
    else
    {
        [CommenMethods alertviewController_title:@"" MessageAlert:NSLocalizedString(@"CHKNET", nil) viewController:self okPop:NO];
    }
}

-(void)onRequestCheck
{
    if ([appDelegate internetConnected])
    {
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:MD_REQUEST_CHECK withParamData:Nil withBlock:^(id response, NSDictionary *error, NSString *errorcode) {
            if (response)
            {
                
                NSLog(@"Data..%@", response);
                NSArray *arrLocal=response[@"data"];
                
                [_shareBtn setHidden:YES];
                [_sosBtn setHidden:YES];
                
                if ([arrLocal count]!=0)
                {
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    _BackView.hidden=YES;
                    _menuView.hidden=NO;
                    
                    [self.view bringSubviewToFront:_menuView];
                    
                    NSDictionary *dictVal=[response[@"data"]objectAtIndex:0];
                    NSString *strCheck=[dictVal valueForKey:@"status"];
                    _invoiceIdLbl.text=[NSString stringWithFormat:@"INVOICE ID - %@",[Utilities removeNullFromString:[dictVal valueForKey:@"booking_id"]]];

                    NSString *str = [[dictVal valueForKey:@"id"]stringValue];
                    [user setValue:str forKey:UD_REQUESTID];
                    
                        globalStatus = strCheck;
                        
                        if ([strCheck isEqualToString:@"ACCEPTED"])
                            _lblStatusText.text=@"Driver Accepted your request";
                        else if ([strCheck isEqualToString:@"STARTED"])
                        _lblStatusText.text=[NSString stringWithFormat:@"Arriving at your location"];
                        else if ([strCheck isEqualToString:@"ARRIVED"])
                            _lblStatusText.text=@"Arrived to your location";
                        else if ([strCheck isEqualToString:@"PICKEDUP"])
                            _lblStatusText.text=@"You are on Ride";

                        if ([_sourceLat length]==0)
                        {
                            _sourceLat=[NSString  stringWithFormat:@"%@",dictVal[@"s_latitude"]];
                            _sourceLng=[NSString  stringWithFormat:@"%@",dictVal[@"s_longitude"]];
                            
                            _destLat=[NSString  stringWithFormat:@"%@",dictVal[@"d_latitude"]];
                            _destLng=[NSString  stringWithFormat:@"%@",dictVal[@"d_longitude"]];
                            strSourceAddress=dictVal[@"s_address"];
                            strDestAddress=dictVal[@"d_address"];
                            
                            [self onMapReload];
                        }
                        
                        NSString *strPayment;
                        if (![[dictVal valueForKey:@"payment_mode"] isKindOfClass:[NSNull class]])
                    {
                        strPayment=[dictVal valueForKey:@"payment_mode"];
                        _lblPaymentType.text=[NSString stringWithFormat:@"%@", [dictVal valueForKey:@"payment_mode"]];
                        
                        if ([strPayment isEqualToString:@"CASH"])
                        {
                            _imgPayment.image = [UIImage imageNamed:@"money_icon"];
                        }
                        else
                        {
                            _imgPayment.image = [UIImage imageNamed:@"payment"];
                        }
                    }
                        else
                            strPayment=@"";
                        
                        if ([strCheck isEqualToString:@"STARTED"]||[strCheck isEqualToString:@"ARRIVED"]||[strCheck isEqualToString:@"ACCEPTED"]||[strCheck isEqualToString:@"PICKEDUP"])
                        {
                            startLocationMarker.draggable = NO;
                            endLocationMarker.draggable = NO;
                            _requestWaitingView.hidden=YES;
                            _whereView.hidden=YES;
                            _viewSourceandDestination.hidden=YES;
                            btnCurrentLocation.hidden=NO;
                            
                            if(socketConnectFlag)
                            {
                                //Already connected
                            }
                            else
                            {
                                [socket connect];
                            }
                            
                            NSDictionary *userDictLocal=[dictVal valueForKey:@"user"];
                            if (![[userDictLocal valueForKey:@"user"] isKindOfClass:[NSNull class]])
                            {
                               userNameStr =[NSString stringWithFormat:@"%@ %@",[userDictLocal valueForKey:@"first_name"],[userDictLocal valueForKey:@"last_name"]];
                            }
                            
                            NSDictionary *dictLocal=[dictVal valueForKey:@"provider"];
                            if (![[dictVal valueForKey:@"provider"] isKindOfClass:[NSNull class]])
                            {
                                if (![[dictLocal valueForKey:@"avatar"] isKindOfClass:[NSNull class]]) {
                                    
//                                    NSString *social_unique_id = [Utilities removeNullFromString:[dictLocal valueForKey:@"social_unique_id"]];
                                    NSString *imageUrl = [dictLocal valueForKey:@"avatar"];
                                    
                                    if ([imageUrl containsString:@"http"])
                                    {
                                        imageUrl = [NSString stringWithFormat:@"%@",[dictLocal valueForKey:@"avatar"]];
                                    }
                                    else
                                    {
                                        imageUrl = [NSString stringWithFormat:@"%@/storage/%@",SERVICE_URL, [dictLocal valueForKey:@"avatar"]];
                                    }
                                    
                                    [_userImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                                                placeholderImage:[UIImage imageNamed:@"userProfile"]];
                                }
                                else
                                {
                                    _userImg.image=[UIImage imageNamed:@"userProfile"];
                                }
                                _nameLbl.text=[NSString stringWithFormat:@"%@ %@",[dictLocal valueForKey:@"first_name"],[dictLocal valueForKey:@"last_name"]];
                                strProviderCell= [Utilities removeNullFromString: [dictLocal valueForKey:@"mobile"]];
                                
                                NSString *latit = [dictLocal valueForKey:@"latitude"];
                                NSString *longi = [dictLocal valueForKey:@"longitude"];
                                
                                CLLocationCoordinate2D navi_location = CLLocationCoordinate2DMake([latit doubleValue], [longi doubleValue]);
                                CLLocationCoordinate2D old= markerCarLocation.position;
                                CLLocationCoordinate2D new= navi_location;
                                
                                if (markerCarLocation == nil)
                                {
                                    markerCarLocation = [GMSMarker markerWithPosition:navi_location];
                                    markerCarLocation.icon = [UIImage imageNamed:@"car"];
                                    markerCarLocation.map= _mkap;
                                }
                                else
                                {
                                    [CATransaction begin];
                                    [CATransaction setAnimationDuration:2.0];
                                    markerCarLocation.position = navi_location;
                                    [CATransaction commit];
                                }
                                float getAngle = [self angleFromCoordinate:old toCoordinate:new];
                                markerCarLocation.rotation = getAngle * (180.0 / M_PI);
                                
                                if (![[dictLocal valueForKey:@"rating"] isKindOfClass:[NSNull class]])
                                    _rating_default.value=[[dictLocal valueForKey:@"rating"] floatValue];
                                else
                                    _rating_default.value=0;
                            }
                    
                            NSDictionary *dictServiceType=[dictVal valueForKey:@"service_type"];
                            if (![[dictServiceType valueForKey:@"image"] isKindOfClass:[NSNull class]])
                            {
                                
                                NSString *imageUrl = [NSString stringWithFormat:@"%@",[dictServiceType valueForKey:@"image"]];
                                
                                [_ServiceImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                                               placeholderImage:[UIImage imageNamed:@"sedan-car-model"]];
                            }
                            else
                            {
                                _ServiceImg.image=[UIImage imageNamed:@"sedan-car-model"];
                            }
                            
                            _lblServiceName.text=[dictServiceType valueForKey:@"name"];
                            
                            
                            NSDictionary *carNumberDict=[dictVal valueForKey:@"provider_service"];
                            NSString *carNumber = [carNumberDict valueForKey:@"service_number"];
                            NSString *carModel = [carNumberDict valueForKey:@"service_model"];
                            _lblCarNumber.text= [Utilities removeNullFromString:[NSString stringWithFormat:@"%@\n%@", carModel, carNumber]] ;
                            
                            if ([strCheck isEqualToString:@"STARTED"]||[strCheck isEqualToString:@"ACCEPTED"])
                            {
                                _statusView.hidden=NO;
                                [UIView animateWithDuration:0.45 animations:^{
                                    
                                    _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height -260), self.view.frame.size.width,  260);
                                    
                                    [self.view bringSubviewToFront:_notifyView];
                                }];
                            }
                            if ([strCheck isEqualToString:@"ARRIVED"])
                            {
                                _statusView.hidden=NO;
                                [UIView animateWithDuration:0.45 animations:^{
                                    
                                    _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height -260), self.view.frame.size.width,  260);
                                    
                                    [self.view bringSubviewToFront:_notifyView];
                                }];
                            }
                            if ([strCheck isEqualToString:@"PICKEDUP"])
                            {
                                [self.view bringSubviewToFront:_sosBtn];
                                [self.view bringSubviewToFront:_shareBtn];
                                
                                [_shareBtn setHidden:NO];
                                [_sosBtn setHidden:NO];
                                
                                _statusView.hidden=YES;
                                [UIView animateWithDuration:0.45 animations:^{
                                    
                                    _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height -220), self.view.frame.size.width,  220);
                                    
                                    [self.view bringSubviewToFront:_notifyView];
                                }];
                            }
                        }
                        else if (([strCheck isEqualToString:@"DROPPED"] ||[strCheck isEqualToString:@"COMPLETED"])&&[[dictVal valueForKey:@"paid"]intValue]==0 && [strPayment isEqualToString:@"CARD"])
                        {
                            [self.view bringSubviewToFront:_sosBtn];
                            [_sosBtn setHidden:NO];
                            
                            _statusView.hidden=YES;
                            _whereView.hidden=YES;
                            _viewSourceandDestination.hidden=YES;
                            _requestWaitingView.hidden=YES;
                            
                            if (![[dictVal valueForKey:@"payment"] isKindOfClass:[NSNull class]]) {
                                
                                NSDictionary *dictPayment=[dictVal valueForKey:@"payment"];
                                NSString *currencyStr=[user valueForKey:@"currency"];
                                
                                _lblBacePrice.text=[NSString stringWithFormat:@"%@%@",currencyStr,[dictPayment valueForKey:@"fixed"]];
                                _lblTaxPrice.text=[NSString stringWithFormat:@"%@%@",currencyStr, [dictPayment valueForKey:@"tax"]];
                                _lblTotalAmt.text=[NSString stringWithFormat:@"%@%@",currencyStr,[dictPayment valueForKey:@"total"]];
                                _lblDistance.text=[NSString stringWithFormat:@"%@%@",currencyStr,[dictPayment valueForKey:@"distance"]];
                                _invoice_WalletAmt.text=[NSString stringWithFormat:@"%@%@",currencyStr,[dictPayment valueForKey:@"wallet"]];

                                _btnChange.hidden=YES;
                                _lblPaymentType.text=[NSString stringWithFormat:@"%@", [dictVal valueForKey:@"payment_mode"]];
                                
                                NSString *wallet=[NSString stringWithFormat:@"%@",[dictPayment valueForKey:@"wallet"]];
                                if ([wallet isEqualToString:@"0.00"] || [wallet isEqualToString:@"0"])
                                {
                                    [_invoice_WalletAmt setHidden:YES];
                                    [_invoice_WalletLbl setHidden:YES];
                                }
                                else
                                {
                                    [_invoice_WalletAmt setHidden:NO];
                                    [_invoice_WalletLbl setHidden:NO];
                                    
                                    _invoice_WalletAmt.text=[NSString stringWithFormat:@"%@%@",currencyStr,wallet];
                                }
                                
                                NSString *discount=[NSString stringWithFormat:@"%@",[dictPayment valueForKey:@"discount"]];
                                if ([discount isEqualToString:@"0.00"] || [discount isEqualToString:@"0"])
                                {
                                    //No discount
                                    [_invoice_discountLbl setHidden:YES];
                                    [_invoice_discountAmt setHidden:YES];
                                }
                                else
                                {
                                    [_invoice_discountLbl setHidden:NO];
                                    [_invoice_discountAmt setHidden:NO];
                                    _invoice_discountAmt.text=[NSString stringWithFormat:@"%@%@",currencyStr,discount];
                                }
                                
                                [UIView animateWithDuration:0.45 animations:^{
                                    _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height -300), self.view.frame.size.width,  300);
                                    _notifyView.frame = CGRectMake(self.view.frame.size.width, (self.view.frame.origin.y +self.view.frame.size.height -220), self.view.frame.size.width,  220);
                                    
                                    _rateViewView.frame = CGRectMake(self.view.frame.size.width+5, 0, self.view.frame.size.width, 300);
                                    [self.view bringSubviewToFront:_commonRateView];
                                    
                                    // [self.view bringSubviewToFront:_notifyView];
                                }];
                                
                                [UIView animateWithDuration:0.45 animations:^{
                                    
                                    _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height -300), self.view.frame.size.width,  300);
                                    
                                    _invoiceView.frame = CGRectMake( 0, 0, self.view.frame.size.width, 300);
                                    _rateViewView.frame = CGRectMake(self.view.frame.size.width+5, 0, self.view.frame.size.width, 300);
                                    [self.view bringSubviewToFront:_commonRateView];
                                }];
                            }
                        }
                        else if ([strCheck isEqualToString:@"DROPPED"]&&[[dictVal valueForKey:@"paid"]intValue]==0 && [strPayment isEqualToString:@"CASH"])
                        {
                            [self.view bringSubviewToFront:_sosBtn];
                            [_sosBtn setHidden:NO];

                            
                            [_whereView setHidden:YES];
                            _requestWaitingView.hidden=YES;
                            if (![[dictVal valueForKey:@"payment"] isKindOfClass:[NSNull class]]) {
                                
                                NSDictionary *dictPayment=[dictVal valueForKey:@"payment"];
                                
                                NSString *currencyStr= [Utilities removeNullFromString:[user valueForKey:@"currency"]];
                                
//                                [_invoice_WalletAmt setHidden:YES];
//                                [_invoice_WalletLbl setHidden:YES];
//                                
//                                NSString *walletStr = [[dictVal valueForKey:@"use_wallet"]stringValue];
                                
                                _lblBacePrice.text=[NSString stringWithFormat:@"%@%@",currencyStr,[dictPayment valueForKey:@"fixed"]];
                                _lblTaxPrice.text=[NSString stringWithFormat:@"%@%@",currencyStr, [dictPayment valueForKey:@"tax"]];
                                _lblTotalAmt.text=[NSString stringWithFormat:@"%@%@",currencyStr,[dictPayment valueForKey:@"total"]];
                                _lblDistance.text=[NSString stringWithFormat:@"%@%@",currencyStr,[dictPayment valueForKey:@"distance"]];
                                
                                _invoice_WalletAmt.text=[NSString stringWithFormat:@"%@%@",currencyStr,[dictPayment valueForKey:@"wallet"]];
                                
                                NSString *wallet=[NSString stringWithFormat:@"%@",[dictPayment valueForKey:@"wallet"]];
                                if ([wallet isEqualToString:@"0.00"] || [wallet isEqualToString:@"0"])
                                {
                                    [_invoice_WalletAmt setHidden:YES];
                                    [_invoice_WalletLbl setHidden:YES];
                                }
                                else
                                {
                                    [_invoice_WalletAmt setHidden:NO];
                                    [_invoice_WalletLbl setHidden:NO];
                                    
                                    _invoice_WalletAmt.text=[NSString stringWithFormat:@"%@%@",currencyStr,wallet];
                                }
                                
                                NSString *discount=[NSString stringWithFormat:@"%@",[dictPayment valueForKey:@"discount"]];
                                if ([discount isEqualToString:@"0.00"] || [discount isEqualToString:@"0"])
                                {
                                    //No discount
                                    [_invoice_discountLbl setHidden:YES];
                                    [_invoice_discountAmt setHidden:YES];
                                }
                                else
                                {
                                    [_invoice_discountLbl setHidden:NO];
                                    [_invoice_discountAmt setHidden:NO];
                                    _invoice_discountAmt.text=[NSString stringWithFormat:@"%@%@",currencyStr,discount];
                                }
                                
                                _btnChange.hidden=YES;
                                _paymentBtn.hidden=YES;
                                _lblPaymentType.hidden=NO;
                                _imgPayment.hidden=NO;
                                
                                _lblWaitingforPayment.hidden=NO;
                                _lblWaitingforPayment.text=NSLocalizedString(@"WAIT_PAY_MENT", nil);
                                
                                
                                [UIView animateWithDuration:0.45 animations:^{
                                    
                                    _notifyView.frame = CGRectMake(self.view.frame.size.width, (self.view.frame.origin.y +self.view.frame.size.height -220), self.view.frame.size.width,  220);
                                    
                                    // [self.view bringSubviewToFront:_notifyView];
                                }];
                                
                                [UIView animateWithDuration:0.45 animations:^{
                                    
                                    if ([strPayment isEqualToString:@"CASH"])
                                    {
                                        _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height -250), self.view.frame.size.width,  250);
                                        
                                        _invoiceView.frame = CGRectMake( 0, 0, self.view.frame.size.width, 290);
                                        _rateViewView.frame = CGRectMake(self.view.frame.size.width+5, 0, self.view.frame.size.width, 250);
                                    }
                                    else
                                    {
                                        _lblPaymentType.hidden=NO;
                                        _imgPayment.hidden=NO;
                                        _paymentBtn.hidden=NO;
                                        _lblWaitingforPayment.hidden=YES;
                                        
                                        _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height -300), self.view.frame.size.width,  300);
                                        
                                        _invoiceView.frame = CGRectMake( 0, 0, self.view.frame.size.width, 300);
                                        _rateViewView.frame = CGRectMake(self.view.frame.size.width+5, 0, self.view.frame.size.width, 300);
                                    }
                                    
                                    
                                    [self.view bringSubviewToFront:_commonRateView];
                                    
                                }];
                            }
                        }
                        else if ([strCheck isEqualToString:@"COMPLETED"]&&[[dictVal valueForKey:@"paid"]intValue]==1)
                        {
                           _statusView.hidden=YES;
                            _requestWaitingView.hidden=YES;
                            _lblRatewithName.text=[NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"RATING_VIEW", nil),[[dictVal valueForKey:@"provider"] valueForKey:@"first_name"],[[dictVal valueForKey:@"provider"] valueForKey:@"last_name"]];
                            
                            NSDictionary *dictLocal=[dictVal valueForKey:@"provider"];
                            if (![[dictLocal valueForKey:@"avatar"] isKindOfClass:[NSNull class]]) {
                                NSString *imageUrl =[dictLocal valueForKey:@"avatar"];
                                
                                if ([imageUrl containsString:@"http"])
                                {
                                    imageUrl = [NSString stringWithFormat:@"%@",[dictLocal valueForKey:@"avatar"]];
                                }
                                else
                                {
                                    imageUrl = [NSString stringWithFormat:@"%@/storage/%@",SERVICE_URL, [dictLocal valueForKey:@"avatar"]];
                                }
                                
                                [_ratingProviderImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                                            placeholderImage:[UIImage imageNamed:@"userProfile"]];
                            }
                            else
                            {
                                _ratingProviderImg.image=[UIImage imageNamed:@"userProfile"];
                            }
                            
                            [UIView animateWithDuration:0.45 animations:^{
                                
                                _commonRateView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height -300), self.view.frame.size.width,  300);
                                
                                _invoiceView.frame = CGRectMake( -self.view.frame.size.width, 0, self.view.frame.size.width, 300);
                                _rateViewView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
                                
                                [self.view bringSubviewToFront:_commonRateView];
                                
                            }];

                        }
                        else if ([strCheck isEqualToString:@"SEARCHING"])
                        {
                            _whereView.hidden=YES;
                            _viewSourceandDestination.hidden=NO;
                            _lblSource.text=strSourceAddress;
                            _lblDestination.text=strDestAddress;
                            
                            [_requestWaitingView setHidden:NO];
                            [UIView animateWithDuration:0.45 animations:^{
                                
                                _requestWaitingView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                                
                                [self.view bringSubviewToFront:_requestWaitingView];
                            }];
                        }
                        else if ([strCheck isEqualToString:@"CANCELLED"])
                        {
                            [_mkap clear];
                            [self onClearLatLong];
                            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:UD_REQUESTID];
                            _requestWaitingView.hidden=YES;
                        }
                }
                else
                {
                    if ([globalStatus isEqualToString:@"SEARCHING"] || [globalStatus isEqualToString:@"STARTED"] || [globalStatus isEqualToString:@"ARRIVED"] ||[globalStatus isEqualToString:@"COMPLETED"])
                    {
                        //Clear the view after the request cancel without accept by any driver
                        [_shareBtn setHidden:YES];
                        [_sosBtn setHidden:YES];
                        
                        globalStatus = @"";
                        [_mkap clear];
                        [self onClearLatLong];
                        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:UD_REQUESTID];
                        _requestWaitingView.hidden=YES;
                        
                        [UIView animateWithDuration:0.45 animations:^{
                            
                            _notifyView.frame = CGRectMake(0, (self.view.frame.origin.y +self.view.frame.size.height +20), self.view.frame.size.width,  260);
                        }];
                    }
                    else
                    {
                        
                    }
                    _requestWaitingView.hidden=YES;
                    strRating=@"1";
                    _commentsText.text=@"";
                    
                    /// For schedule
                    
                    if ([scheduleNav_Str isEqualToString:@"TRUE"])
                    {
                        scheduleNav_Str  =@"FALSE";
                        [self onClearLatLong];
                        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:UD_REQUESTID];
                        _requestWaitingView.hidden=YES;
                        
                        YourTripViewController *wallet = [self.storyboard instantiateViewControllerWithIdentifier:@"YourTripViewController"];
                        wallet.navigateStr = @"Home";
                        [self.navigationController pushViewController:wallet animated:YES];
                    }
                    else
                    {
                        //Nothing
                    }
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
                    if (LoggedOut ==false)
                    {
                        
                        [self logoutMethod];
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

-(void)onMapReload
{
    GMSPolyline *polyline;
    polyline.map = nil;
    [_mkap clear];
    
    startLocationMarker.map=nil;
    bounds = [[GMSCoordinateBounds alloc] init];
    
    startLocationMarker=[[GMSMarker alloc]init];
    startLocationMarker.position=CLLocationCoordinate2DMake([_sourceLat doubleValue], [_sourceLng doubleValue]);
    startLocationMarker.icon=[UIImage imageNamed:@"ub__ic_pin_pickup"];
    startLocationMarker.groundAnchor=CGPointMake(0.5,0.5);
    startLocationMarker.draggable = YES;
    startLocationMarker.userData = @"PICKUP";
    bounds = [bounds includingCoordinate:startLocationMarker.position];
    startLocationMarker.map=_mkap;
    
    endLocationMarker.map=nil;
    endLocationMarker=[[GMSMarker alloc]init];
    endLocationMarker.position=CLLocationCoordinate2DMake([_destLat doubleValue], [_destLng doubleValue]);
    endLocationMarker.icon=[UIImage imageNamed:@"ub__ic_pin_dropoff"];
    endLocationMarker.groundAnchor=CGPointMake(0.5,0.5);
    endLocationMarker.draggable = YES;
    endLocationMarker.userData = @"DROP";
    bounds = [bounds includingCoordinate:endLocationMarker.position];
    endLocationMarker.map=_mkap;
    [self getPath];
}

-(void)connectSocket
{
    NSURL* url = [[NSURL alloc] initWithString:WEB_SOCKET];
    socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES,@"forcePolling":@YES}];
    
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        socketConnectFlag = true;
        NSString *strReqID=[[NSUserDefaults standardUserDefaults] valueForKey:UD_REQUESTID];
        [socket emit:@"update sender" with:@[@{@"request_id":strReqID, @"type":@"user"}]];
    }];
    
    [socket on:@"disconnect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"disconnect");
        socketConnectFlag = false;
    }];
    
    [socket on:@"location update" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"location update......Socket %@",data);
        if ([data count]!=0)
        {
            NSString *latit = [[data valueForKey:@"latitude"]objectAtIndex:0];
            NSString *longi = [[data valueForKey:@"longitude"]objectAtIndex:0];
            
            CLLocationCoordinate2D navi_location = CLLocationCoordinate2DMake([latit doubleValue], [longi doubleValue]);
            CLLocationCoordinate2D old= markerCarLocation.position;
            CLLocationCoordinate2D new= navi_location;
            
            if (markerCarLocation == nil)
            {
                markerCarLocation = [GMSMarker markerWithPosition:navi_location];
                markerCarLocation.icon = [UIImage imageNamed:@"car"];
                markerCarLocation.map= _mkap;
            }
            else
            {
                [CATransaction begin];
                [CATransaction setAnimationDuration:2.0];
                markerCarLocation.position = navi_location;
                [CATransaction commit];
            }
            
            float getAngle = [self angleFromCoordinate:old toCoordinate:new];
            markerCarLocation.rotation = getAngle * (180.0 / M_PI);
        }
        else
        {
            NSLog(@"NO DATA");
        }
    }];
}
-(void)disconnectSocket
{
    socketConnectFlag = false;
    [socket disconnect];
}

- (float)angleFromCoordinate:(CLLocationCoordinate2D)first
                toCoordinate:(CLLocationCoordinate2D)second {
    
    float deltaLongitude = second.longitude - first.longitude;
    float deltaLatitude = second.latitude - first.latitude;
    float angle = (M_PI * .5f) - atan(deltaLatitude / deltaLongitude);
    
    if (deltaLongitude > 0)      return angle;
    else if (deltaLongitude < 0) return angle + M_PI;
    else if (deltaLatitude < 0)  return M_PI;
    
    return 0.0f;
}

-(IBAction)sosBtnAction:(id)sender
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *sosNumber = [Utilities removeNullFromString:[def valueForKey:UD_SOS]];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Are you sure want to Call Emergency?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([sosNumber isEqualToString:@""])
        {
            //No SOS number was provided
        }
        else
        {
            NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:sosNumber]];
            NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:sosNumber]];
            
            if ([UIApplication.sharedApplication canOpenURL:phoneUrl])
            {
                [UIApplication.sharedApplication openURL:phoneUrl options:@{} completionHandler:nil];
            }
            else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl])
            {
                [UIApplication.sharedApplication openURL:phoneFallbackUrl options:@{} completionHandler:nil];
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Your device does not support calling" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];    }
        }
        
    }];
    [alertController addAction:ok];
    [alertController addAction:no];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(IBAction)shareBtnAction:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Are you sure want to share the ride?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *strLat=[NSString stringWithFormat:@"%.8f", myLocation.coordinate.latitude];
        NSString *strLong=[NSString stringWithFormat:@"%.8f", myLocation.coordinate.longitude];
        
        NSString *shareUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?q=loc:%@,%@",strLat, strLong];
        NSString *strTitle=[NSString stringWithFormat:@"TRANXIT - %@ would like to share a ride with you at ", userNameStr];
        UIImage *img = [UIImage imageNamed:@"icon"];
        [self shareText:strTitle andImage:img andUrl:[NSURL URLWithString:shareUrlStr]];
    }];
    [alertController addAction:ok];
    [alertController addAction:no];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
