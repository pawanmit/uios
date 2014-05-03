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

@property NSString* userIdForIncomingChatRequest;
@property NSString* chatStatus;

-(void) sendChatRequestFromSender:(NSString *) senderUserId
                         toReceiver:(NSString *) receiverUserId
             withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
             withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) sendMessage:(NSString *) message
           fromSender:(NSString *) userId
         toReceiver:(NSString *) userId
         withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
         withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) listenForIncomingChatRequestsForUser:(NSString *) userId
          withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
          withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) updateChatStatus:(NSString *) chatStatus
        betweenSender:(NSString *) senderUserId
        andReceiver:(NSString *) receiverUserId
        withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
        withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) declineChatRequestFromSender:(NSString *) senderUserId
                          toReceiver: (NSString *) receiverUserId
                  withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
                  withFailureHandler: (UmanlyChatFailureHandler) failureHander;

-(void) clearChatRequestLocation:(NSString *) userId;

@end
