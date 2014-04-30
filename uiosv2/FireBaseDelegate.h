//
//  FireBaseDelegate.h
//  uiosv2
//
//  Created by Mittal, Pawan on 4/17/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

typedef void (^FireBaseSuccessHandler)(void);
typedef void (^FireBaseFailureHandler)(void);

@interface FireBaseDelegate : NSObject

@property id fireBaseData;

-(void) observeLocation:(NSString *) Location
     withSuccessHandler: (FireBaseSuccessHandler) successHandler
     withFailureHandler: (FireBaseFailureHandler) failureHandler;

-(void) appendValue: (NSString *) message
           ToLocation:(NSString *) location
           withSuccessHandler: (FireBaseSuccessHandler) successHandler
           withFailureHandler: (FireBaseFailureHandler) failureHandler;

-(void) removeValueFromLocation:(NSString *) location
             withSuccessHandler: (FireBaseSuccessHandler) successHandler
             withFailureHandler: (FireBaseFailureHandler) failureHandler;

@end
