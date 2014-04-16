//
//  UmanlyViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/1/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UmanlyViewController.h"

@interface UmanlyViewController ()

@end

@implementation UmanlyViewController

NSString *const FireBaseURL = @"https://popping-fire-3020.firebaseIO.com/";

- (void)viewDidLoad
{
 
    UmanlyClientDelegate *umanlyClientDelegate = [[UmanlyClientDelegate alloc] init];

    if (self.umanlyClientDelegate == nil) {
        self.umanlyClientDelegate = umanlyClientDelegate;
    }
    
    if (self.viewUtility == nil) {
        self.viewUtility = [[ViewUtility alloc] init];
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) listenForIncomingChatRequestsForUser:(NSString *) userId
{
    NSMutableString *fireBaseUserUrl = [NSMutableString stringWithCapacity:100];
    [fireBaseUserUrl appendString:FireBaseURL];
    [fireBaseUserUrl appendFormat:userId];
    NSLog(@"Initializing firebase with URL %@", fireBaseUserUrl);

    self.firebase = [[Firebase alloc] initWithUrl:fireBaseUserUrl];
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot);
        
    }];
}


@end
