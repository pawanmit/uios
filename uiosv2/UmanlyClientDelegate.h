//
//  UmanlyClientDelegate.h
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "UserLocation.h"

@interface UmanlyClientDelegate : NSObject

@property User *user;

typedef void (^UmanlyRequestSuccessHandler)(void);

typedef void (^UmanlyRequestFailureHandler)(void);

-(void) saveOrUpdateUser:(User *) user
        withSuccessHandler: (UmanlyRequestSuccessHandler) handler
        withFailureHandler: (UmanlyRequestFailureHandler) failureHander;

-(void) updateUser: (User *) user
        withLocation: (UserLocation *) location
        withSuccessHandler: (UmanlyRequestSuccessHandler) successHandler
        withFailureHandler: (UmanlyRequestFailureHandler) failureHander;


-(void) getUsers;

-(NSArray *) getUsersNearUser:(User *) user
           withSuccessHandler: (UmanlyRequestSuccessHandler) successHandler
           withFailureHandler: (UmanlyRequestFailureHandler) failureHander;

@end
