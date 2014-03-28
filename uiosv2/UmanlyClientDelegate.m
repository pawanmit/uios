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
      withFailureHandler: (UmanlyRequestFailureHandler) failureHander
{
    NSLog([NSString stringWithFormat:@"%@" , user.firstName]);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"first_name": user.firstName,
                             @"last_name": user.lastName,
                             @"email": user.email,
                             @"hometown": [self convertNilToEmptyString:user.hometown],
                             @"gender": user.gender,
                             @"birthday": [self convertNilToEmptyString:user.birthday],
                             @"facebook_link": user.facebookProfileLink,
                             @"facebook_username": user.facebookUsername
                             };
    [manager POST:@"http://localhost/user" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *userId = [responseObject objectForKey:@"id"];
        NSLog(@"User saved with id %@",  userId);
        self.user = user;
        self.user.userId = userId;
        successHandler();

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failureHander();
    }];
}

-(void) updateUser: (User *) user
      withLocation: (UserLocation *) location
    withSuccessHandler: (UmanlyRequestSuccessHandler) successHandler
    withFailureHandler: (UmanlyRequestFailureHandler) failureHander
{
    NSMutableString *updateLocationUrl = [NSMutableString stringWithCapacity:100];
    [updateLocationUrl appendString:@"http://api.umanly.com/user/"];
    [updateLocationUrl appendString:user.userId];
    [updateLocationUrl appendString:@"/location"];
    NSDictionary *params = @{@"longitude": [NSString stringWithFormat:@"%f", location.longitude],
                             @"latitude": [NSString stringWithFormat:@"%f", location.latitude]
                             };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:updateLocationUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.user = user;
        self.user.location = location;
        successHandler();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failureHander();
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

-(NSArray *) getUsersNearUser:(User *) user
           withSuccessHandler: (UmanlyRequestSuccessHandler) successHandler
           withFailureHandler: (UmanlyRequestFailureHandler) failureHandler
{
    NSArray *userArray = [[NSArray alloc] init];
    NSString *searchByLocationEndPoint = [NSString stringWithFormat:@"http://api.umanly.com/user/search/distance/?longitude=%f&latitude=%f&distance=2", user.location.longitude, user.location.latitude];
    NSURL *url = [NSURL URLWithString:searchByLocationEndPoint];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    responseObject = (NSDictionary *) responseObject;
            id users = [responseObject objectForKey:@"users"];
            NSArray *nearByUsers = [self getNearByUsersFromJson:users];
        user.nearByUsers = nearByUsers;
        self.user = user;
        successHandler();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@" , error);
        failureHandler();
    }];
    
    [operation start];
    return userArray;
}

-(NSMutableArray *) getNearByUsersFromJson:(id) users
{
    NSMutableArray *nearbyUsers = [[NSMutableArray alloc] init];
    for (id userId in users) {
        id user = [users objectForKey:userId];
        User *nearByUser = [[User alloc] init];
        nearByUser.userId = [user objectForKey:@"id"];
        nearByUser.firstName = [user objectForKey:@"first_name"];
        nearByUser.lastName = [user objectForKey:@"last_name"];
        nearByUser.facebookUsername = [user objectForKey:@"facebook_username"];
        id location = [user objectForKey:@"location"];
        UserLocation *userLocation = [[UserLocation alloc] init];
        userLocation.latitude = [[location objectForKey:@"latitude"] floatValue];
        userLocation.longitude = [[location objectForKey:@"longitude"] floatValue];
        nearByUser.location = userLocation;
        [nearbyUsers addObject:nearByUser];
        NSLog(@"%@", nearByUser);
    }
    return nearbyUsers;
}

-(NSString *) convertNilToEmptyString:(NSString *) text
{
    if (text == nil) {
        return @"";
    } else {
        return text;
    }
}

@end
