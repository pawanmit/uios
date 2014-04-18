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

-(void) observeEndPoint:(NSString *) endPointUrl
     withSuccessHandler: (FireBaseSuccessHandler) successHandler
     withFailureHandler: (FireBaseFailureHandler) failureHandler;

-(void) appendMessage: (NSString *) message
           ToEndPoint:(NSString *) endPointUrl
           withSuccessHandler: (FireBaseSuccessHandler) successHandler
           withFailureHandler: (FireBaseFailureHandler) failureHandler;

@end
