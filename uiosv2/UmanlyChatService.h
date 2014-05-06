//
//  UmanlyChatDelegate.h
//  uiosv2
//
//  Created by Mittal, Pawan on 4/17/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FireBaseService.h"
#import "User.h"

@interface UmanlyChatService : NSObject

@property FireBaseService *fireBaseService;


typedef void (^UmanlyChatSuccessHandler)(void);

typedef void (^UmanlyChatFailureHandler)(void);

@property NSString* userIdForIncomingChatRequest;
@property NSString* chatStatus;

-(void) sendChatRequestToUser:(NSString *) userId
             withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
             withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) sendChatMessage:(NSString *) message
           toUser:(NSString *) userId
         withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
         withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) listenForIncomingChatRequests:(User *) test
          withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
          withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) declineChatRequestFromUser:(NSString *) userId
                  withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
                  withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) acceptChatRequestFromUser:(NSString *) userId
                withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
                withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) handleDeclinedChatRequest;

@end
