//
//  LocationViewController.m
//  User
//
//  Created by iCOMPUTERS on 19/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "LocationViewController.h"
#import "config.h"
#import "CSS_Class.h"
#import "Colors.h"
#import "NSString+StringValidation.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "HomeViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Utilities.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define apiURL @"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@"
#define GOOGLEPLACE_API_KEY @"AIzaSyBe-77R1y2Z4QnW5EJqVt-E3MwdVFrJIw4"

@interface LocationViewController ()
{
    int nCheckVal;
    NSString *strSourceLat,*strSourceLong,*strSourceAddress, *locationString;
    AppDelegate *appDelegate;
    GMSCameraPosition *lastCameraPosition;
    CLLocationCoordinate2D newCoords;
    CLLocation *myLocation;
    GMSAutocompleteFetcher *fetcher;
    GMSAutocompleteFilter *filter;
    
}

@end

@implementation LocationViewController
@synthesize topView, locationTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setDesignStyles];
    _fromText.text = @"";
    gotLocation = false;
    [self onLocationUpdateStart];
    cityNameArray = [[NSMutableArray alloc]init];
    placeIdArray = [[NSMutableArray alloc]init];
    
    _fromText.delegate = self;
    _toText.delegate = self;
    
    UITapGestureRecognizer *tapGesture_condition=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewOuterTap)];
    tapGesture_condition.cancelsTouchesInView=NO;
    tapGesture_condition.delegate=self;
    [topView addGestureRecognizer:tapGesture_condition];
    
    [self.view bringSubviewToFront:_doneBtn];
    [_doneBtn setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ViewOuterTap
{
    [self.view endEditing:YES];
}


-(void)setDesignStyles
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:topView.frame];
    topView.layer.masksToBounds = NO;
    topView.layer.shadowColor = [UIColor blackColor].CGColor;
    topView.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    topView.layer.shadowOpacity = 0.5f;
    topView.layer.shadowPath = shadowPath.CGPath;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _fromText.leftView = paddingView;
    _fromText.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _toText.leftView = padding;
    _toText.leftViewMode = UITextFieldViewModeAlways;
    
    [CSS_Class APP_Blackbutton:_doneBtn];
    
}
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
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    
    NSLog(@"Location: %@", [NSString stringWithFormat:@"%.8f", newLocation.coordinate.latitude]);
    NSLog(@"Location: %@", [NSString stringWithFormat:@"%.8f", newLocation.coordinate.longitude]);
    myLocation = newLocation; //(CLLocation *)[locations lastObject];
    
    filter = [[GMSAutocompleteFilter alloc] init];
    
    CLLocationCoordinate2D center =  CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001);
    //GMSVisibleRegion visibleRegion = self.mkap.projection.visibleRegion;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                       coordinate:southWest];
    
    //    filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
    
    // Create the fetcher.
    fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:bounds filter:filter];
    fetcher.delegate = self;
    
    strSourceLat=[NSString stringWithFormat:@"%.8f", newLocation.coordinate.latitude];
    strSourceLong=[NSString stringWithFormat:@"%.8f", newLocation.coordinate.longitude];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks lastObject];
            strSourceAddress = [NSString stringWithFormat:@"%@,%@,%@",placemark.name,placemark.locality,placemark.subAdministrativeArea];
            nCheckVal=2;
            _fromText.text = strSourceAddress;
            [_toText becomeFirstResponder];
        }
        else
        {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
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
                      locationString = locatedAt;
                      
                      if (nCheckVal ==1)
                      {
                          _fromText.text = [Utilities removeNullFromString:locationString];
                      }
                      else
                      {
                          _toText.text = [Utilities removeNullFromString:locationString];
                      }
                      
                      NSLog(@"Pickup Address...%@", _fromText.text);
                  }
                  else {
                      NSLog(@"Could not locate");
                      locationString = @"";
                  }
              }
     ];
    return locationString;
}

- (void)mapView:(GMSMapView* )mapView idleAtCameraPosition:(GMSCameraPosition* )position
{
    lastCameraPosition = nil; // reset pin moving, no ice skating pins ;)
    
    lastCameraPosition = position;
    newCoords = CLLocationCoordinate2DMake(position.target.latitude, position.target.longitude);
    
    [self getAddressFromLatLon:[[NSString stringWithFormat:@"%f", newCoords.latitude] doubleValue] withLongitude:[[NSString stringWithFormat:@"%f", newCoords.longitude] doubleValue]];
    
    return;
    
}

-(IBAction)setPinLocationBtn:(id)sender
    {
        [self.view endEditing:YES];
        
        [_setPinLocationView setHidden:YES];
        
        if (gotLocation ==false)
        {
            _mapView.frame = CGRectMake(0, self.topView.frame.origin.y+self.topView.frame.size.height, self.mapView.frame.size.width, self.mapView.frame.size.height);
            _mkap=[[GMSMapView alloc]initWithFrame:CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height)];
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
            
            CGRect visibleRect = CGRectMake(_mkap.frame.origin.x, _mapView.frame.origin.x, _mapView.frame.size.width, _mkap.frame.size.height);
            CGPoint centerPoint = CGPointMake(visibleRect.size.width/2, visibleRect.size.height/2-31);
            
            NSLog(@"CenterPoint...%f %f", centerPoint.x, centerPoint.y);
            
            
            UIButton *markerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            markerBtn.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 33, 48);
            markerBtn.backgroundColor = [UIColor clearColor];
            UIImage *buttonImage = [UIImage imageNamed:@"MoveMapMarker"];
            [markerBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
            [markerBtn setCenter:centerPoint];
            [_mkap addSubview:markerBtn];
            
            CLLocationCoordinate2D coor = [_mkap.projection coordinateForPoint:centerPoint];
            
            NSLog(@"coor.Location: %@", [NSString stringWithFormat:@"%.8f", coor.latitude]);
            NSLog(@"coor.Location: %@", [NSString stringWithFormat:@"%.8f", coor.longitude]);
            
            
            NSLog(@"myLocation: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.latitude]);
            NSLog(@"myLocation: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.longitude]);
            
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude
                                         
                                                                    longitude:myLocation.coordinate.longitude
                                                                         zoom:14];
            
            [_mkap animateToCameraPosition:camera];
            
            gotLocation = true;
        }
        
        [_mapView setHidden:NO];
        [locationTableView setHidden:YES];
        [_doneBtn setHidden:NO];
    }

-(IBAction)backBtn:(id)sender
{
    [_fromText resignFirstResponder];
    [_toText resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField==_fromText)
    {
        nCheckVal=1;

    }
    else if(textField==_toText)
    {
        nCheckVal=2;
        cityNameArray = [[NSMutableArray alloc]init];
        placeIdArray = [[NSMutableArray alloc]init];
        primaryTextArray = [[NSMutableArray alloc]init];
        
        [locationTableView reloadData];
    }
    
    [_mapView setHidden:YES];
    [locationTableView setHidden:NO];
    [_doneBtn setHidden:YES];
    [_setPinLocationView setHidden:NO];

    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _fromText)
    {
        NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (updatedText.length == 0)
        {
            cityNameArray = [[NSMutableArray alloc]init];
            placeIdArray = [[NSMutableArray alloc]init];
            primaryTextArray = [[NSMutableArray alloc]init];
            
            [fetcher sourceTextHasChanged:@""];
        }
        else
        {
            NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            if (updatedText.length > 50)
            {
                return NO;
            }
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            // [self queryGetLocationName: newString];
            
            [fetcher sourceTextHasChanged:newString];
            

        }
    }
    else if (textField == _toText)
    {
        NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (updatedText.length == 0)
        {
            
            
            cityNameArray = [[NSMutableArray alloc]init];
            placeIdArray = [[NSMutableArray alloc]init];
            primaryTextArray = [[NSMutableArray alloc]init];
            
            [fetcher sourceTextHasChanged:@""];
            
        }
        else
        {
            NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            if (updatedText.length > 50)
            {
                return NO;
            }
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            // [self queryGetLocationName: newString];
            [fetcher sourceTextHasChanged:newString];
            
        }
    }
    
    return YES;
}

#pragma mark - Name Search

- (void)didAutocompleteWithPredictions:(NSArray<GMSAutocompletePrediction *> *)predictions
{
    NSLog(@"PREDICTION...%@", predictions);
    
    cityNameArray = [[NSMutableArray alloc]init];
    placeIdArray = [[NSMutableArray alloc]init];
    primaryTextArray = [[NSMutableArray alloc]init];
    
    
    if (predictions.count !=0)
    {
        NSMutableString *resultsStr = [NSMutableString string];
        for (GMSAutocompletePrediction *prediction in predictions) {
            [resultsStr appendFormat:@"%@\n", [prediction.attributedPrimaryText string]];
            NSLog(@"Result '%@' with placeID %@", prediction.attributedFullText.string, prediction.placeID);
            
            [primaryTextArray addObject:[prediction.attributedPrimaryText string]];
            [cityNameArray addObject:[prediction.attributedFullText string]];
            [placeIdArray addObject:prediction.placeID];
            NSLog(@"Google Data: %@", cityNameArray);
        }
    }
    else
    {
    }
    [locationTableView reloadData];
}

- (void)didFailAutocompleteWithError:(NSError *)error
{
    NSLog(@"Autocomplete: %@", error);
    
}

#pragma mark - Name Search

/*- (void)queryGetLocationName: (NSString *) inputType
 {
 @try
 {
 if (inputType.length > 0)
 {
 NSString *encodedUrlString = [inputType urlencode];
 
 NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=%@&input=%@",GOOGLE_API_KEY, encodedUrlString];
 
 //Formulate the string as URL object.
 NSURL *googleRequestURL=[NSURL URLWithString:url];
 
 // Retrieve the results of the URL.
 dispatch_async(kBgQueue, ^{
 NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
 [self performSelectorOnMainThread:@selector(fetchedlocationData:) withObject:data waitUntilDone:YES];
 });
 
 }
 else
 {
 
 }
 }
 @catch (NSException *exception)
 {
 
 }
 }*/


//- (void)fetchedlocationData:(NSData *)responseData
//{
//    @try
//    {
//        //parse out the json data
//        NSError* error;
//        NSDictionary* json = [NSJSONSerialization
//                              JSONObjectWithData:responseData
//                              options:kNilOptions
//                              error:&error];
//
//        //The results from Google will be an array obtained from the NSDictionary object with the key "results".
//        NSArray* places = [json objectForKey:@"predictions"];
//
//        cityNameArray = [places valueForKey:@"structured_formatting"];
//        placeIdArray = [places valueForKey:@"place_id"];
//
//        NSLog(@"Google Data: %@", cityNameArray);
//
//        [locationTableView reloadData];
//
//    }
//    @catch (NSException *exception)
//    {
//
//    }
//}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return cityNameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    NSString *centernameStr;
    NSString *fullAddressStr;
    
//    if (indexPath.row ==0)
//    {
//        cell.textLabel.text = @"Set Pin Location";
//    }
//    else
//    {
        if (cityNameArray.count >0)
        {
            centernameStr = [primaryTextArray objectAtIndex:indexPath.row];
            fullAddressStr = [cityNameArray objectAtIndex:indexPath.row];
            
            //            centernameStr = [dict valueForKey:@"main_text"];
            //            fullAddressStr = [dict valueForKey:@"secondary_text"];
        }
        
        cell.textLabel.text =centernameStr;
        cell.detailTextLabel.text = fullAddressStr;
//    }
    
    
    [CSS_Class APP_labelName:cell.textLabel];
    [CSS_Class APP_fieldValue_Small:cell.detailTextLabel];
    
    cell.detailTextLabel.textColor =TEXTCOLOR_LIGHT ;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.contentView.superview setClipsToBounds:NO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.view endEditing:YES];
    
//    if (indexPath.row ==0)
//    {
//        if (gotLocation ==false)
//        {
//            _mapView.frame = CGRectMake(0, self.topView.frame.origin.y+self.topView.frame.size.height, self.mapView.frame.size.width, self.mapView.frame.size.height);
//            _mkap=[[GMSMapView alloc]initWithFrame:CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height)];
//            _mkap.myLocationEnabled = YES;
//            _mkap.delegate=self;
//            NSError *error;
//            NSURL *url1 =[[NSBundle mainBundle] URLForResource:@"map_style" withExtension:@"json"];
//            GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:url1 error:&error];
//            
//            if (!style) {
//                NSLog(@"The style definition could not be loaded: %@", error);
//            }
//            _mkap.mapStyle = style;
//            [_mapView addSubview:_mkap];
//            
//            CGRect visibleRect = CGRectMake(_mkap.frame.origin.x, _mapView.frame.origin.x, _mapView.frame.size.width, _mkap.frame.size.height);
//            CGPoint centerPoint = CGPointMake(visibleRect.size.width/2, visibleRect.size.height/2-31);
//            
//            NSLog(@"CenterPoint...%f %f", centerPoint.x, centerPoint.y);
//            
//            
//            UIButton *markerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            markerBtn.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 33, 48);
//            markerBtn.backgroundColor = [UIColor clearColor];
//            UIImage *buttonImage = [UIImage imageNamed:@"MoveMapMarker"];
//            [markerBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
//            [markerBtn setCenter:centerPoint];
//            [_mkap addSubview:markerBtn];
//            
//            CLLocationCoordinate2D coor = [_mkap.projection coordinateForPoint:centerPoint];
//            
//            NSLog(@"coor.Location: %@", [NSString stringWithFormat:@"%.8f", coor.latitude]);
//            NSLog(@"coor.Location: %@", [NSString stringWithFormat:@"%.8f", coor.longitude]);
//            
//            
//            NSLog(@"myLocation: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.latitude]);
//            NSLog(@"myLocation: %@", [NSString stringWithFormat:@"%.8f", myLocation.coordinate.longitude]);
//            
//            
//            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:myLocation.coordinate.latitude
//                                         
//                                                                    longitude:myLocation.coordinate.longitude
//                                                                         zoom:14];
//            
//            [_mkap animateToCameraPosition:camera];
//            
//            gotLocation = true;
//        }
//        
//        [_mapView setHidden:NO];
//        [locationTableView setHidden:YES];
//        [_doneBtn setHidden:NO];
//    }
//    else
//    {
        NSString *placeIdStr = [placeIdArray objectAtIndex:indexPath.row];
        [self getPlaceDetailForReferance:placeIdStr];
//    }
    
}

- (void)getPlaceDetailForReferance:(NSString*)strReferance
{
    [NSString stringWithFormat:apiURL,strReferance,GOOGLE_API_KEY];
    
    [[GMSPlacesClient sharedClient]lookUpPlaceID:strReferance callback:^(GMSPlace *place, NSError *error) {
        if(place)
        {
            NSLog(@"SELECTED ADDRESS :%@",place);
            
            NSString *latitudeStr = [NSString stringWithFormat:@"%f", place.coordinate.latitude];
            NSString *longitudeStr = [NSString stringWithFormat:@"%f", place.coordinate.longitude];
            
            CLLocationCoordinate2D center =  CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude);
            CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001);
            CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001);
            //GMSVisibleRegion visibleRegion = self.mkap.projection.visibleRegion;
            GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                               coordinate:southWest];
            
            //    filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
            
            // Create the fetcher.
            fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:bounds filter:filter];
            fetcher.delegate = self;
            
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place attributions %@", place.attributions.string);
            
            if (nCheckVal==1)
            {
                _fromText.text = [NSString stringWithFormat:@"%@", place.formattedAddress];
                strSourceLat=latitudeStr;
                strSourceLong=longitudeStr;
                strSourceAddress=[NSString stringWithFormat:@"%@", place.formattedAddress];
                [_toText becomeFirstResponder];
            }
            else
            {
                _toText.text = [NSString stringWithFormat:@"%@", place.formattedAddress];
                [_delegate getLatLong:strSourceLat :strSourceLong :latitudeStr :longitudeStr:strSourceAddress:_toText.text];
                [self backBtn:self];
            }
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
}

-(IBAction)doneBtn:(id)sender
{
    if ([_fromText.text isEqualToString:@""] || [_toText.text isEqualToString:@""])
    {
        //Dont proceed
        [CommenMethods alertviewController_title:@"Alert" MessageAlert:@"Please enter location to ride" viewController:self okPop:nil];
    }
    else
    {
        NSString *latitudeStr = [NSString stringWithFormat:@"%f", newCoords.latitude];
        NSString *longitudeStr = [NSString stringWithFormat:@"%f", newCoords.longitude];
        [_delegate getLatLong:strSourceLat :strSourceLong :latitudeStr :longitudeStr:strSourceAddress:_toText.text];
        [self backBtn:self];
    }
}



@end
