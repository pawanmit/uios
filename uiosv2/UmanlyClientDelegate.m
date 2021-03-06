//
//  UmanlyClientDelegate.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UmanlyClientDelegate.h"

@implementation UmanlyClientDelegate

NSString *const BaseURLString = @"http://mydublin.us/umanlyapi/user/";
//NSString *const BaseURLString = @"http://api.umanly.com/user/";

-(void) saveOrUpdateUser:(User *) user
      withSuccessHandler: (UmanlyRequestSuccessHandler) successHandler
      withFailureHandler: (UmanlyRequestFailureHandler) failureHander
{
    //NSLog([NSString stringWithFormat:@"%@" , user.firstName]);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = [self getParamsFromUser:user];
    [manager POST:BaseURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id userJson = [responseObject objectForKey:@"user"];
        [self updateUser:user fromJson:userJson];
        successHandler();

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failureHander();
    }];
}

- (NSDictionary*) getParamsFromUser:(User *)user
{
    NSMutableDictionary *userParams = [[NSMutableDictionary alloc] init];
    
    if ( ![self isNilOrEmpty:user.firstName] ) {
        [userParams setObject:user.firstName forKey:@"first_name"];
    }
    if ( ![self isNilOrEmpty:user.lastName] ) {
        [userParams setObject:user.lastName forKey:@"last_name"];
    }
    if ( ![self isNilOrEmpty:user.email] ) {
        [userParams setObject:user.email forKey:@"email"];
    }
    if ( ![self isNilOrEmpty:user.hometown] ) {
        [userParams setObject:user.hometown forKey:@"hometown"];
    }
    if ( ![self isNilOrEmpty:user.birthday] ) {
        [userParams setObject:user.birthday forKey:@"birthday"];
    }
    if ( ![self isNilOrEmpty:user.facebookProfileLink] ) {
        [userParams setObject:user.facebookProfileLink forKey:@"facebook_link"];
    }
    if ( ![self isNilOrEmpty:user.facebookUsername] ) {
        [userParams setObject:user.facebookUsername forKey:@"facebook_username"];
    }
    if ( ![self isNilOrEmpty:user.chatStatus] ) {
        [userParams setObject:user.chatStatus forKey:@"chat_status"];
    }
    
    return userParams;
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
        user.location = location;
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
        id userJson = [responseObject objectForKey:@"user"];
        self.user = [self getUserFromJson:userJson];
        successHandler();
        //NSLog(@"Response %@", (NSDictionary *)responseObject);
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
    self.nearByUsers = [self getNearByUsersFromJson:users];
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
    //NSMutableArray *nearbyUsers = [[NSMutableArray alloc] init];
    //NSMutableDictionary *nearbyUsersDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *nearbyUsers = [[NSMutableArray alloc] init];
    for (id userId in users) {
        id user = [users objectForKey:userId];
        User *nearByUser = [self getUserFromJson:user];
        [nearbyUsers addObject:nearByUser];
    }
    return nearbyUsers;
}

-(User *) getUserFromJson: (id) userJson
{
    User *user = [[User alloc] init];
    user.userId = [userJson objectForKey:@"id"];
    user.firstName = [userJson objectForKey:@"first_name"];
    user.lastName = [userJson objectForKey:@"last_name"];
    user.facebookUsername = [userJson objectForKey:@"facebook_username"];
    user.birthday = [userJson objectForKey:@"birthday"];
    user.hometown = [userJson objectForKey:@"hometown"];
    user.gender = [userJson objectForKey:@"gender"];
    id location = [userJson objectForKey:@"location"];
    if (location != nil) {
        UserLocation *userLocation = [[UserLocation alloc] init];
        userLocation.latitude = [[location objectForKey:@"latitude"] floatValue];
        userLocation.longitude = [[location objectForKey:@"longitude"] floatValue];
        user.location = userLocation;
    }
    NSString *availability = [userJson objectForKey:@"availability"];
    user.isAvailable = [availability boolValue];
    user.chatStatus = [userJson objectForKey:@"chat_status"];
    return user;
}

-(void) updateUser:(User *) user
            fromJson: (id) userJson
{
    user.userId = [userJson objectForKey:@"id"];
    user.firstName = [userJson objectForKey:@"first_name"];
    user.lastName = [userJson objectForKey:@"last_name"];
    user.facebookUsername = [userJson objectForKey:@"facebook_username"];
    user.birthday = [userJson objectForKey:@"birthday"];
    user.hometown = [userJson objectForKey:@"hometown"];
    user.gender = [userJson objectForKey:@"gender"];
    id location = [userJson objectForKey:@"location"];
    if (location != nil) {
        UserLocation *userLocation = [[UserLocation alloc] init];
        userLocation.latitude = [[location objectForKey:@"latitude"] floatValue];
        userLocation.longitude = [[location objectForKey:@"longitude"] floatValue];
        user.location = userLocation;
    }
    NSString *availability = [userJson objectForKey:@"availability"];
    user.isAvailable = [availability boolValue];
    user.chatStatus = [userJson objectForKey:@"chat_status"];
}

-(NSString *) convertNilToEmptyString:(NSString *) text
{
    if (text == nil) {
        return @"";
    } else {
        return text;
    }
}

-(BOOL) isNilOrEmpty:(NSString *) string
{
    BOOL isNilOrEmpty = NO;
    if (string == nil) {
        isNilOrEmpty = YES;
    } else {
     NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        if ([trimmedString length] < 1) {
            isNilOrEmpty = YES;
        }
    }
    return isNilOrEmpty;
}
@end
