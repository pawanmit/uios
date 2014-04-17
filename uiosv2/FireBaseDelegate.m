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

-(void) observeEndPoint:(NSString *)endPointUrl {
    NSMutableString *fireBaseUserUrl = [NSMutableString stringWithCapacity:100];
    [fireBaseUserUrl appendString:FireBaseURL];
    [fireBaseUserUrl appendFormat:endPointUrl];
    NSLog(@"Initializing firebase with URL %@", fireBaseUserUrl);
    Firebase *firebase = [[Firebase alloc] initWithUrl:fireBaseUserUrl];    
    [firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot);
        
    }];
}
@end
