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
-(void)httpPostWithUrl:(NSString*)urlStr params:(NSDictionary*)parameters;
-(void)fetchUsersWithUrl:(NSString*)urlStr completionHandler:(Handler)handler;
@end
