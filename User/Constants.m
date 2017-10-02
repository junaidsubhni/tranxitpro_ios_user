//
//  Constants.m
//  Truck
//
//  Created by veena on 1/12/17.
//  Copyright © 2017 appoets. All rights reserved.
//
//

#import "Constants.h"

NSString *const PICTURE=@"picture"; //

#pragma mark - userdefaults
#pragma mark -
NSString *const UD_TOKEN_TYPE =@"token_type";
NSString *const UD_ACCESS_TOKEN =@"access_token";
NSString *const UD_REFERSH_TOKEN =@"ref_token";
NSString *const UD_PROFILE_IMG =@"profile_img";
NSString *const UD_PROFILE_NAME =@"profile_name";
NSString *const UD_REQUESTID=@"request_id";
NSString *const UD_SOCIAL =@"socialId";
NSString *const UD_ID =@"id";
NSString *const UD_SOS =@"sos";




#pragma mark - Parameters
#pragma mark - --   Seque

NSString *const LOGIN=@"segLogin";
NSString *const REGISTER=@"segRegister";

NSString *const MD_LOGIN = @"oauth/token";
NSString *const MD_REGISTER =@"api/user/signup";
NSString *const MD_GETPROFILE =@"api/user/details";
NSString *const MD_UPDATEPROFILE =@"api/user/update/profile";
NSString *const MD_UPDATELOCATION =@"api/user/update/location";
NSString *const MD_CHANGEPASSWORD =@"api/user/change/password";
NSString *const MD_GET_SERVICE =@"api/user/services";
NSString *const MD_GET_FAREESTIMATE =@"api/user/estimated/fare";
NSString *const MD_CREATE_REQUEST =@"api/user/send/request";
NSString *const MD_CANCEL_REQUEST =@"api/user/cancel/request";
NSString *const MD_REQUEST_CHECK =@"api/user/request/check";
NSString *const MD_RATE_PROVIDER =@"api/user/rate/provider";
NSString *const MD_GET_HISTORY =@"api/user/trips";
NSString *const MD_GET_SINGLE_HISTORY =@"api/user/trip/details";
NSString *const MD_ADD_CARD =@"api/user/card";
NSString *const MD_LIST_CARD =@"api/user/card";
NSString *const MD_PAYMENT =@"api/user/payment";
NSString *const MD_CARD_DELETE =@"api/user/card/destory";
NSString *const MD_WALLET =@"api/user/add/money";
NSString *const MD_GETPROMO =@"api/user/promocodes";
NSString *const MD_ADDPROMO =@"api/user/promocode/add";
NSString *const MD_UPCOMING =@"api/user/upcoming/trips";
NSString *const MD_UPCOMING_HISTORYDETAILS =@"api/user/upcoming/trip/details";

NSString *const MD_GETPROVIDERS =@"api/user/show/providers";

NSString *const MD_RESETPASSWORD =@"api/user/reset/password";
NSString *const MD_FORGOTPASSWORD =@"api/user/forgot/password";
NSString *const MD_FACEBOOK =@"api/user/auth/facebook";
NSString *const MD_GOOGLE =@"api/user/auth/google";

NSString *const MD_LOGOUT =@"api/user/logout";
NSString *const MD_HELP =@"api/user/help";
NSString *const MD_REFRESH_TOKEN= @"oauth/token";


NSString *const MD_EMAILVERIFY= @"api/user/verify";






