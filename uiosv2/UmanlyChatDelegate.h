//
//  UmanlyChatDelegate.h
//  uiosv2
//
//  Created by Mittal, Pawan on 4/17/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FireBaseDelegate.h"

@interface UmanlyChatDelegate : NSObject

@property FireBaseDelegate *fireBaseDelegate;

typedef void (^UmanlyChatSuccessHandler)(void);

typedef void (^UmanlyChatFailureHandler)(void);

-(void) requestChatWithUser:(NSString *) userId
         withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
         withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) sendMessage:(NSString *) message
         ToUser:(NSString *) userId
         withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
         withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) listenForIncomingChatRequestsForUser:(NSString *) userId
          withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
          withFailureHandler: (UmanlyChatFailureHandler) failureHander;

@end
