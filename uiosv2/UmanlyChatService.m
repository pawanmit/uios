//
//  UmanlyChatDelegate.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/17/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UmanlyChatService.h"
#import "ChatConfirmationController.h"
#import "UmanlyStoryboardSegue.h"

@implementation UmanlyChatService

-(id) init {
    self = [super init];
    if (self) {
        self.fireBaseService = [[FireBaseService alloc] init];
    }
    return(self);
}

+ (id)sharedChatService {
    static UmanlyChatService *umanlyChatService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umanlyChatService = [[self alloc] init];
    });
    return umanlyChatService;
}

-(void) sendChatRequestToUser:(NSString *) userId
         withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
         withFailureHandler: (UmanlyChatFailureHandler) failureHander
{

    NSMutableString *chatRequestLocation = [self getChatRequestLocationForUser:userId];
    [chatRequestLocation appendString:@"/"];
    User *thisUser = [User sharedUser];
    [chatRequestLocation appendString:thisUser.userId];
    NSMutableDictionary *requestChatParams = [[NSMutableDictionary alloc] init];
    [requestChatParams setObject:thisUser.userId forKey:@"user_id"];
    [requestChatParams setObject:@"request" forKey:@"status"];
    [self.fireBaseService appendValue:requestChatParams
                            ToLocation:chatRequestLocation
                            withSuccessHandler: ^(){
                            }
                            withFailureHandler:^(){
                            }
     ];
    
}

- (void) listenForIncomingChatRequests:(User *) user
           withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
           withFailureHandler: (UmanlyChatFailureHandler) failureHander;
{
    User *thisUser = [User sharedUser];
    NSString *chatRequestLocation = [self getChatRequestLocationForUser:thisUser.userId];
    [self.fireBaseService observeLocation:chatRequestLocation
                        withSuccessHandler: ^(){
                            NSLog(@"%@",self.fireBaseService.fireBaseData);
                            self.userIdForIncomingChatRequest = [self.fireBaseService.fireBaseData objectForKey:@"user_id"];
                            self.chatStatus = [self.fireBaseService.fireBaseData objectForKey:@"status"];
                            NSLog(@"Chat request received from %@ with status %@", self.userIdForIncomingChatRequest, self.chatStatus);
                            //NSEnumerator
                            [self handleChatRequests];
                        }
                        withFailureHandler:^(){}
     ];
}

-(void) handleChatRequests
{
    if ([self.chatStatus isEqualToString:@"request"]) {
        [self.delegate chatRequestReceived];
    } else if( [self.chatStatus isEqualToString:@"declined"] ) {
        [self.delegate chatRequestDeclined];
        [self clearChatRequestLocation];
    } else if ( [self.chatStatus isEqualToString:@"accepted"]) {
        [self.delegate chatRequestAccepted];
    }
}

-(void) acceptChatRequestFromUser:(NSString *) userId
                withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
                withFailureHandler: (UmanlyChatFailureHandler) failureHander
{
    [self updateChatStatusTo:@"accepted" ofUser:userId
          withSuccessHandler:^{
              successHandler();
          }
          withFailureHandler:^{}
     ];
    [self clearChatRequestLocation];
    User *thisUser = [User sharedUser];
   [self updateChatStatusOfUser:thisUser.userId fromUser:userId toStatus: @"accepted"
          withSuccessHandler:^{
              successHandler();
          }
          withFailureHandler:^{}
     ];
}

-(void) declineChatRequestFromUser:(NSString *) userId
                withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
                withFailureHandler: (UmanlyChatFailureHandler) failureHander
{
    [self updateChatStatusTo:@"declined" ofUser:userId
          withSuccessHandler:^{
              successHandler();
              [self clearChatRequestLocation];
          }
          withFailureHandler:^{}
     ];
}

-(void) updateChatStatusOfUser:(NSString *) userId1
                      fromUser:(NSString *) userId2
                      toStatus:(NSString *) chatStatus
                    withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
                    withFailureHandler: (UmanlyChatFailureHandler) failureHander
{
    NSMutableString *chatRequestLocation = [self getChatRequestLocationForUser:userId1];
    [chatRequestLocation appendFormat:@"/%@", userId2];
    NSMutableDictionary *requestChatParams = [[NSMutableDictionary alloc] init];
    [requestChatParams setObject:userId2 forKey:@"user_id"];
    [requestChatParams setObject:chatStatus forKey:@"status"];
    [self.fireBaseService appendValue:requestChatParams
                           ToLocation:chatRequestLocation
                   withSuccessHandler: ^(){
                       successHandler();
                   }
                   withFailureHandler:^(){
                   }
     ];
}

-(void) updateChatStatusTo:(NSString *) chatStatus
           ofUser:(NSString *) userId
      withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
      withFailureHandler: (UmanlyChatFailureHandler) failureHander
{
    NSMutableString *chatRequestLocation = [self getChatRequestLocationForUser:userId];
    User *thisUser = [User sharedUser];
    [chatRequestLocation appendFormat:@"/%@", thisUser.userId];
    NSMutableDictionary *requestChatParams = [[NSMutableDictionary alloc] init];
    [requestChatParams setObject:thisUser.userId forKey:@"user_id"];
    [requestChatParams setObject:chatStatus forKey:@"status"];
    [self.fireBaseService appendValue:requestChatParams
                            ToLocation:chatRequestLocation
                    withSuccessHandler: ^(){
                        successHandler();
                    }
                    withFailureHandler:^(){
                    }
     ];
    
    
}

-(void) clearChatRequestLocation
{
    User *thisUser = [User sharedUser];
    NSString *chatRequestLocation = [self getChatRequestLocationForUser:thisUser.userId];
    [self.fireBaseService removeValueFromLocation:chatRequestLocation
                                withSuccessHandler:^{
                                }
                                withFailureHandler:^{
                                    
                                }];
}

-(NSString *) getJsonFromChatParams:(NSDictionary *) chatParams
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:chatParams
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                        
                                                         error:&error];
    NSString *jsonString = @"";
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Requesting chat: %@",  jsonData);
    }
    return jsonString;
}


-(NSMutableString *) getChatRequestLocationForUser:(NSString *) userId
{
    
    NSMutableString *chatRequestLocation = [NSMutableString stringWithCapacity:20];
    [chatRequestLocation appendString:userId];
    [chatRequestLocation appendFormat:@"/chat_requests"];
    return chatRequestLocation;
}

@end
