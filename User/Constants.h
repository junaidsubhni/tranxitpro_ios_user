//
//  Constants.h
//  Truck
//
//  Created by veena on 1/12/17.
//  Copyright © 2017 appoets. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Service URL

#define SERVICE_URL @"http://schedule.tranxit.co/"
#define WEB_SOCKET @"http://schedule.tranxit.co:7000"
#define ACCEPTABLE_CHARECTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

#define Address_URL @"https://maps.googleapis.com/maps/api/geocode/json?"
#define AutoComplete_URL @"https://maps.googleapis.com/maps/api/place/autocomplete/json?"
#define Google_Client_ID @"710279630663-4lgj6e2c98imgiv4t2d6207l3296987e.apps.googleusercontent.com"

#define GOOGLE_API_KEY @"AIzaSyDhHsZ6Kv30G52ANlaab3He7cHjtuG1kew"
//#define GMSMAP_KEY @"AIzaSyBKwV2w7uWSf3bpgZeRNbMTBKdRbqnmQew"
//#define GMSPLACES_KEY @"AIzaSyBe-77R1y2Z4QnW5EJqVt-E3MwdVFrJIw4"

#define GMSMAP_KEY @"AIzaSyBKwV2w7uWSf3bpgZeRNbMTBKdRbqnmQew"
#define GMSPLACES_KEY @"AIzaSyBKwV2w7uWSf3bpgZeRNbMTBKdRbqnmQew"

#define Stripe_KEY @"pk_test_0G4SKYMm8dK6kgayCPwKWTXy"

#define ClientID @"2"
#define Client_SECRET @"yVnKClKDHPcDlqqO1V05RtDRdvtrVHfvjlfqliha"


//convert latlng to address;

#pragma mark - userdefaults
#pragma mark -

extern NSString *const UD_TOKEN_TYPE;
extern NSString *const UD_ACCESS_TOKEN;
extern NSString *const UD_REFERSH_TOKEN;
extern NSString *const UD_PROFILE_IMG;
extern NSString *const UD_PROFILE_NAME;
extern NSString *const UD_REQUESTID;
extern NSString *const UD_SOCIAL;
extern NSString *const UD_ID;
extern NSString *const UD_SOS;

#pragma mark - Parameters
#pragma mark - --
extern NSString *const PICTURE;

#pragma mark - Parameters
#pragma mark - --   Seque

extern NSString *const LOGIN;
extern NSString *const REGISTER;

#pragma mark - methods
#pragma mark - 

extern NSString *const MD_LOGIN;
extern NSString *const MD_REGISTER;
extern NSString *const MD_GETPROFILE;
extern NSString *const MD_UPDATEPROFILE;
extern NSString *const MD_UPDATELOCATION;
extern NSString *const MD_CHANGEPASSWORD;
extern NSString *const MD_GET_SERVICE;
extern NSString *const MD_GET_FAREESTIMATE;
extern NSString *const MD_CREATE_REQUEST;
extern NSString *const MD_CANCEL_REQUEST;
extern NSString *const MD_REQUEST_CHECK;
extern NSString *const MD_RATE_PROVIDER;
extern NSString *const MD_GET_HISTORY;
extern NSString *const MD_GET_SINGLE_HISTORY;
extern NSString *const MD_ADD_CARD;
extern NSString *const MD_LIST_CARD;
extern NSString *const MD_PAYMENT;
extern NSString *const MD_CARD_DELETE;
extern NSString *const MD_WALLET;
extern NSString *const MD_UPCOMING;
extern NSString *const MD_UPCOMING_HISTORYDETAILS;
extern NSString *const MD_GETPROVIDERS;
extern NSString *const MD_RESETPASSWORD;
extern NSString *const MD_FORGOTPASSWORD;
extern NSString *const MD_FACEBOOK;
extern NSString *const MD_GOOGLE;
extern NSString *const MD_LOGOUT;
extern NSString *const MD_HELP;
extern NSString *const MD_REFRESH_TOKEN;
extern NSString *const MD_EMAILVERIFY;


