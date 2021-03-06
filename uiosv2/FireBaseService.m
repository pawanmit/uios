//
//  FireBaseDelegate.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/17/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "FireBaseService.h"

@implementation FireBaseService

NSString *const FireBaseURL = @"https://popping-fire-3020.firebaseIO.com/";

-(void) observeLocation:(NSString *) location
     withSuccessHandler: (FireBaseSuccessHandler) successHandler
     withFailureHandler: (FireBaseFailureHandler) failureHandler
{

    NSLog(@"Observing firebase location %@", location);
    Firebase *firebase = [self getFireBaseReferenceForLocation:location];
    [firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        //NSLog(@"%@", snapshot);
        self.fireBaseData = snapshot.value;
        successHandler();
        
    }];
}

-(void) appendValue: (NSDictionary *) message
           ToLocation:(NSString *) location
            withSuccessHandler: (FireBaseSuccessHandler) successHandler
            withFailureHandler: (FireBaseFailureHandler) failureHandler
{
 
    Firebase *firebase = [self getFireBaseReferenceForLocation:location];
    [firebase setValue:message];
    successHandler();
}

-(Firebase *) getFireBaseReferenceForLocation:(NSString *) location
{
    NSMutableString *fireBaseUrl = [NSMutableString stringWithCapacity:100];
    [fireBaseUrl appendString:FireBaseURL];
    [fireBaseUrl appendFormat:location];
    NSLog(@"Firebase Ref created for URL %@", fireBaseUrl);
    Firebase *firebase = [[Firebase alloc] initWithUrl:fireBaseUrl];
    return firebase;
}


-(void) removeValueFromLocation:(NSString *) location
             withSuccessHandler: (FireBaseSuccessHandler) successHandler
             withFailureHandler: (FireBaseFailureHandler) failureHandler
{
    NSLog(@"Removing values from location %@", location );
    Firebase *firebase = [self getFireBaseReferenceForLocation:location];
    [firebase removeValue];
}

@end
