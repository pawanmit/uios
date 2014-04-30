//
//  UmanlyChatDelegate.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/17/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UmanlyChatDelegate.h"
#import "ChatConfirmationController.h"
#import "UmanlyStoryboardSegue.h"

@implementation UmanlyChatDelegate

-(id) init {
    self = [super init];
    if (self) {
        self.fireBaseDelegate = [[FireBaseDelegate alloc] init];
    }
    return(self);
}

-(void) sendChatRequestFromSender:(NSString *) senderUserId
        toReceiver:(NSString *) receiverUserId
         withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
         withFailureHandler: (UmanlyChatFailureHandler) failureHander
{

    NSMutableString *chatRequestLocation = [self getChatRequestLocationForUser:receiverUserId];
    [chatRequestLocation appendString:@"/"];
    [chatRequestLocation appendString:senderUserId];
    NSMutableDictionary *requestChatParams = [[NSMutableDictionary alloc] init];
    [requestChatParams setObject:senderUserId forKey:@"user_id"];
    [requestChatParams setObject:@"sent" forKey:@"status"];
    [self.fireBaseDelegate appendValue:requestChatParams
                            ToLocation:chatRequestLocation
                            withSuccessHandler: ^(){
                            }
                            withFailureHandler:^(){
                            }
     ];
    
}

- (void) listenForIncomingChatRequestsForUser:(NSString *) userId
           withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
           withFailureHandler: (UmanlyChatFailureHandler) failureHander;
{
    NSString *chatRequestLocation = [self getChatRequestLocationForUser:userId];
    [self.fireBaseDelegate observeLocation:chatRequestLocation
                        withSuccessHandler: ^(){
                            NSLog(@"%@",self.fireBaseDelegate.fireBaseData);
                            self.userIdForIncomingChatRequest = [self.fireBaseDelegate.fireBaseData objectForKey:@"user_id"];
                            NSLog(@"user Id of chat request sender%@", self.userIdForIncomingChatRequest);
                            //NSEnumerator
                            successHandler();
                        }
                        withFailureHandler:^(){}
     ];
}

-(void) updateChatStatus:(NSString *) chatStatus
           betweenSender:(NSString *) senderUserId
             andReceiver:(NSString *) receiverUserId
      withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
      withFailureHandler: (UmanlyChatFailureHandler) failureHander
{
    NSMutableString *chatRequestLocation = [self getChatRequestLocationForUser:receiverUserId];
    [chatRequestLocation appendFormat:@"/%@", senderUserId];
    NSMutableDictionary *requestChatParams = [[NSMutableDictionary alloc] init];
    [requestChatParams setObject:senderUserId forKey:@"user_id"];
    [requestChatParams setObject:chatStatus forKey:@"status"];
    [self.fireBaseDelegate appendValue:requestChatParams
                            ToLocation:chatRequestLocation
                    withSuccessHandler: ^(){
                    }
                    withFailureHandler:^(){
                    }
     ];
    
    
}

-(NSMutableString *) getChatRequestLocationForUser:(NSString *) userId
{
 
    NSMutableString *chatRequestLocation = [NSMutableString stringWithCapacity:20];
    [chatRequestLocation appendString:userId];
    [chatRequestLocation appendFormat:@"/chat_requests"];
    return chatRequestLocation;
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

@end
