//
//  LocationViewController.h
//  User
//
//  Created by iCOMPUTERS on 19/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>

@protocol ChooseLocation;
@import GoogleMaps;

@interface LocationViewController : UIViewController<CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteFetcherDelegate, UIGestureRecognizerDelegate, GMSAutocompleteViewControllerDelegate,UITextFieldDelegate>
{
    NSMutableArray *cityNameArray, *placeIdArray, *primaryTextArray;
    GMSMarker *endLocationMarker, *startLocationMarker;
    BOOL gotLocation;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) NSString *currentAddress;

@property(strong,nonatomic)IBOutlet GMSMarker*marker;
@property (strong, nonatomic) IBOutlet GMSMapView *mkap;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@property (weak, nonatomic) IBOutlet UITextField *fromText;
@property (weak, nonatomic) IBOutlet UITextField *toText;
@property (nonatomic, retain) IBOutlet UITableView *locationTableView;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *setPinLocationBtn;
@property (weak, nonatomic) IBOutlet UIView *setPinLocationView;



@property(nonatomic,retain) CLLocationManager *locationManager;

@property(nonatomic,retain) id<ChooseLocation> delegate;

@end

@protocol ChooseLocation <NSObject>

-(void)getLatLong:(NSString *) SourceLat :(NSString *) sourceLong :(NSString *) destLat :(NSString *) destLong :(NSString *) sourceAddress :(NSString *) destAddress;

@end
