//
//  UmanlyClientDelegate.h
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UmanlyClientDelegate : NSObject

@property User *user;

typedef void (^UmanlyRequestSuccessHandler)(void);

-(void) saveOrUpdateUser:(User *) user
        withSuccessHandler: (UmanlyRequestSuccessHandler) handler;
-(void) getUsers;

@end
