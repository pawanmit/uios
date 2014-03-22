//
//  UmanlyClientDelegate.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UmanlyClientDelegate.h"

@implementation UmanlyClientDelegate

-(void) saveOrUpdateUser:(User *) user
      withSuccessHandler: (UmanlyRequestSuccessHandler) successHandler
{
    NSLog([NSString stringWithFormat:@"%@" , user]);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"first_name": user.firstName,
                             @"last_name": user.lastName,
                             @"email": user.email,
                             @"hometown": user.hometown,
                             @"gender": user.gender,
                             @"birthday": user.birthday,
                             @"facebook_link": user.facebookProfileLink
                             };
    [manager POST:@"http://localhost/user" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *userId = [responseObject objectForKey:@"id"];
        self.user = user;
        self.user.userId = userId;
        successHandler();

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) getUsers
{
    static NSString * const BaseURLString = @"http://api.umanly.com/user";
    NSURL *url = [NSURL URLWithString:BaseURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response %@", (NSDictionary *)responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@" , error);
    }];
    
    [operation start];
}

@end
