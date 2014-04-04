//
//  UmanlyClientDelegate.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UmanlyClientDelegate.h"

@implementation UmanlyClientDelegate

NSString *const BaseURLString = @"http://api.umanly.com/user/";

-(void) saveOrUpdateUser:(User *) user
      withSuccessHandler: (UmanlyRequestSuccessHandler) successHandler
      withFailureHandler: (UmanlyRequestFailureHandler) failureHander
{
    //NSLog([NSString stringWithFormat:@"%@" , user.firstName]);
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
    [manager POST:BaseURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *user = [self getUserFromJson:responseObject];
        self.user = user;
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
    [updateLocationUrl appendString:BaseURLString];
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

-(void) updateUserAvailability: (BOOL) isAvailable
            withSuccessHandler: (UmanlyRequestSuccessHandler) successHandler
            withFailureHandler: (UmanlyRequestFailureHandler) failureHander
{
    NSMutableString *updateAvailabilityUrl = [NSMutableString stringWithCapacity:100];
    [updateAvailabilityUrl appendString:BaseURLString];
    [updateAvailabilityUrl appendFormat:@"%@/availability", self.user.userId];
    NSString *availability = (isAvailable) ? @"1" : @"0";
    NSDictionary *params = @{@"availability": availability};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:updateAvailabilityUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.user.isAvailable = isAvailable;
        successHandler();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failureHander();
    }];
    
}


-(void) getUsers
{
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

-(void) getUserById:(NSString *) userId
 withSuccessHandler: (UmanlyRequestSuccessHandler) successHandler
 withFailureHandler: (UmanlyRequestFailureHandler) failureHander
{
    NSMutableString *getUserByIdUrl = [NSMutableString stringWithCapacity:100];
    [getUserByIdUrl appendString:BaseURLString];
    [getUserByIdUrl appendString:userId];
    NSURL *url = [NSURL URLWithString:getUserByIdUrl];
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
    NSMutableString *searchByLocationEndPoint = [NSMutableString stringWithCapacity:100];
    [searchByLocationEndPoint appendString:BaseURLString];
    [searchByLocationEndPoint appendFormat:@"search/distance/?longitude=%f&latitude=%f&distance=2", user.location.longitude, user.location.latitude];
    NSURL *url = [NSURL URLWithString:searchByLocationEndPoint];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    responseObject = (NSDictionary *) responseObject;
            id users = [responseObject objectForKey:@"users"];
            NSDictionary *nearByUsersDictionary = [self getNearByUsersFromJson:users];
        user.nearByUsers = nearByUsersDictionary;
        self.user = user;
        successHandler();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@" , error);
        failureHandler();
    }];
    
    [operation start];
    return userArray;
}

-(NSMutableDictionary *) getNearByUsersFromJson:(id) users
{
    //NSMutableArray *nearbyUsers = [[NSMutableArray alloc] init];
    NSMutableDictionary *nearbyUsersDictionary = [[NSMutableDictionary alloc] init];
    for (id userId in users) {
        id user = [users objectForKey:userId];
        User *nearByUser = [self getUserFromJson:user];
        [nearbyUsersDictionary setObject:nearByUser forKey:nearByUser.userId];
    }
    return nearbyUsersDictionary;
}

-(User *) getUserFromJson: (id) userJson
{
    //NSLog(@"%@", userJson);
    User *user = [[User alloc] init];
    user.userId = [userJson objectForKey:@"id"];
    user.firstName = [userJson objectForKey:@"first_name"];
    user.lastName = [userJson objectForKey:@"last_name"];
    user.facebookUsername = [userJson objectForKey:@"facebook_username"];
    id location = [userJson objectForKey:@"location"];
    if (location != nil) {
        UserLocation *userLocation = [[UserLocation alloc] init];
        userLocation.latitude = [[location objectForKey:@"latitude"] floatValue];
        userLocation.longitude = [[location objectForKey:@"longitude"] floatValue];
        user.location = userLocation;
    }
    NSString *availability = [userJson objectForKey:@"availability"];
    user.isAvailable = [availability boolValue];
    return user;
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
