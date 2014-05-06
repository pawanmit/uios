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
        self.fireBaseDelegate = [[FireBaseDelegate alloc] init];
    }
    return(self);
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
    [self.fireBaseDelegate appendValue:requestChatParams
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
    [self.fireBaseDelegate observeLocation:chatRequestLocation
                        withSuccessHandler: ^(){
                            NSLog(@"%@",self.fireBaseDelegate.fireBaseData);
                            self.userIdForIncomingChatRequest = [self.fireBaseDelegate.fireBaseData objectForKey:@"user_id"];
                            self.chatStatus = [self.fireBaseDelegate.fireBaseData objectForKey:@"status"];
                            NSLog(@"Chat request received from %@ with status %@", self.userIdForIncomingChatRequest, self.chatStatus);
                            //NSEnumerator
                            successHandler();
                        }
                        withFailureHandler:^(){}
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
    [self.fireBaseDelegate appendValue:requestChatParams
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
    [self.fireBaseDelegate removeValueFromLocation:chatRequestLocation
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