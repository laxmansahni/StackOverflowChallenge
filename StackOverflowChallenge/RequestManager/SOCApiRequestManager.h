//
//  SOCApiRequestManager.h
//  StackOverflowChallenge
//
//  Created by Cafex-Development on 28/02/16.
//  Copyright © 2016 Cafex-Development. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^Handler)(NSData *data, NSURLResponse *response, NSError *error);

@interface SOCApiRequestManager : NSObject<NSURLSessionDataDelegate>
/**
 http POST request manager.
 */
-(void)httpPostWithUrl:(NSString*)urlStr params:(NSDictionary*)parameters;
/**
 http GET request manager.
 */
-(void)fetchUsersWithUrl:(NSString*)urlStr completionHandler:(Handler)handler;
@end
