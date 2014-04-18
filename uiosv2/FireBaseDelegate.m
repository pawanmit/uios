//
//  FireBaseDelegate.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/17/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "FireBaseDelegate.h"

@implementation FireBaseDelegate

NSString *const FireBaseURL = @"https://popping-fire-3020.firebaseIO.com/";

-(void) observeEndPoint:(NSString *)endPointUrl
     withSuccessHandler: (FireBaseSuccessHandler) successHandler
     withFailureHandler: (FireBaseFailureHandler) failureHandler
{

    //NSLog(@"Observing firebase url %@", fireBaseUrl);
    Firebase *firebase = [self getFireBaseReferenceForEndPoint:endPointUrl];
    [firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        //NSLog(@"%@", snapshot);
        
    }];
}

-(void) appendMessage: (NSString *) message
        ToEndPoint:(NSString *) endPointUrl
        withSuccessHandler: (FireBaseSuccessHandler) successHandler
        withFailureHandler: (FireBaseFailureHandler) failureHandler
{
 
    Firebase *firebase = [self getFireBaseReferenceForEndPoint:endPointUrl];
    [[firebase childByAppendingPath:@"message"] setValue:message];
}

-(Firebase *) getFireBaseReferenceForEndPoint:(NSString *) endPointUrl
{
    NSMutableString *fireBaseUrl = [NSMutableString stringWithCapacity:100];
    [fireBaseUrl appendString:FireBaseURL];
    [fireBaseUrl appendFormat:endPointUrl];
    NSLog(@"Firebase Ref created for URL %@", fireBaseUrl);
    Firebase *firebase = [[Firebase alloc] initWithUrl:fireBaseUrl];
    return firebase;
}

@end
