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

-(void) sendChatRequestFromUser:(NSString *) senderUserId
        ToUser:(NSString *) receiverUserId
         withSuccessHandler: (UmanlyChatSuccessHandler) successHandler
         withFailureHandler: (UmanlyChatFailureHandler) failureHander
{
    NSMutableDictionary *requestChatParams = [[NSMutableDictionary alloc] init];
    [requestChatParams setObject:senderUserId forKey:@"user_id"];
    NSMutableString *chatRequestLocation = [NSMutableString stringWithCapacity:20];
    [chatRequestLocation appendString:receiverUserId];
    [chatRequestLocation appendFormat:@"/chat_requests/sender"];
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
    NSMutableString *chatRequestLocation = [NSMutableString stringWithCapacity:20];
    [chatRequestLocation appendString:userId];
    [chatRequestLocation appendFormat:@"/chat_requests"];
    [self.fireBaseDelegate observeLocation:chatRequestLocation
                        withSuccessHandler: ^(){
                            //NSLog(@"%@",self.fireBaseDelegate.snapshot);
                            self.userIdForIncomingChatRequest = [self.fireBaseDelegate.fireBaseData objectForKey:@"user_id"];
                            NSLog(@"%@", self.userIdForIncomingChatRequest);
                            //NSEnumerator
                            successHandler();
                        }
                        withFailureHandler:^(){}
     ];
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
