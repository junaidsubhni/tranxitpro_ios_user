//
//  AFNHelper.h
//  Truck
//
//  Created by veena on 1/12/17.
//  Copyright © 2017 appoets. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define POST_METHOD @"POST"
#define GET_METHOD  @"GET"

typedef void (^RequestCompletionBlock)(id response, NSDictionary *error, NSString *errorcode);

@interface AFNHelper : NSObject
{
//blocks
    RequestCompletionBlock dataBlock;
}

@property(nonatomic,copy)NSString *strReqMethod;

-(id)initWithRequestMethod:(NSString *)method;

-(void)getDataFromPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block;

-(void)getDataFromPath:(NSString *)path withParamDataImage:(NSDictionary *)dictParam andImage:(UIImage *)image withBlock:(RequestCompletionBlock)block;

-(void)getAddressFromGooglewithParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block;

-(void)getAddressFromGooglewAutoCompletewithParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block;

-(void)refreshMethod_NoLoader:(NSString *)path withBlock:(RequestCompletionBlock)block;

@end
