//
//  UmanlyViewController.h
//  uiosv2
//
//  Created by Mittal, Pawan on 4/1/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserLocation.h"
#import "ViewUtility.h"
#import "UmanlyClientDelegate.h"
#import "UmanlyChatService.h"

@interface UmanlyViewController : UIViewController

@property NSString *sourceView;
@property UmanlyClientDelegate *umanlyClientDelegate;
@property ViewUtility *viewUtility;
@property UmanlyChatService *umanlyChatService;
@property UmanlyViewController *sourceViewController;
@property NSString *sourceViewControllerIdentifier;
@property NSString *currentViewControllerIdentifier;


-(void) startListeningForChatRequests;

-(void) segueToDestinationViewController:(UmanlyViewController *) destinationViewController
                fromSourceViewController:(UmanlyViewController *) sourceViewController;

-(void) prepareSegueForDestinationViewController:(UmanlyViewController *) destinationViewController;

-(void) prepareView;

@end
