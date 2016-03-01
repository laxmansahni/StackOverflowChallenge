//
//  SOCApiRequestManager.m
//  StackOverflowChallenge
//
//  Created by Cafex-Development on 28/02/16.
//  Copyright © 2016 Cafex-Development. All rights reserved.
//

#import "SOCApiRequestManager.h"

@implementation SOCApiRequestManager

-(void)httpPostWithUrl:(NSString*)urlStr params:(NSDictionary*)parameters
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = @"";
    if ([parameters count] > 0) {
        
        NSArray *allKeys = [parameters allKeys];
        
        for (int i=0; i<allKeys.count; i++)
        {
            params = [[[params stringByAppendingString:[allKeys objectAtIndex:i]] stringByAppendingString:@"="] stringByAppendingString:[parameters objectForKey:[allKeys objectAtIndex:i]]];
            
            if(i<allKeys.count -1)
            {
                params = [NSString stringWithFormat:@"%@&",params];
            }
        }
    }

    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}
-(void)fetchUsersWithUrl:(NSString*)urlStr completionHandler:(Handler)handler
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:handler];
    [dataTask resume];
}
@end
