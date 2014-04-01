//
//  User.h
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLocation.h"

@interface User : NSObject

@property NSString *userId;
@property NSString *firstName;
@property NSString *lastName;
@property NSString *email;
@property NSString *hometown;
@property NSString *gender;
@property NSString *employer;
@property NSDate   *birthday;
@property BOOL isAvailable;

@property NSString *facebookProfileLink;
@property NSString *facebookUsername;

@property UserLocation *location;
@property NSArray *nearByUsers;

@property NSMutableDictionary *nearByUsersImages;

@end
