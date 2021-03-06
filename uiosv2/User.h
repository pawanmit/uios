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
@property NSString *birthday;
@property BOOL isAvailable;
@property NSString *chatStatus;

@property NSString *facebookProfileLink;
@property UIImage *facebookProfileImage;
@property NSString *facebookUsername;

@property UserLocation *location;

@property NSMutableDictionary *nearByUsers;

+ (id)sharedUser;

@end
