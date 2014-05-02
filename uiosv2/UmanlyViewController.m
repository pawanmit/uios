//
//  UmanlyViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/1/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UmanlyViewController.h"
#import "ChatConfirmationController.h"
#import "UserMenuViewController.h"
#import "UmanlyStoryboardSegue.h"

@interface UmanlyViewController ()

@end

@implementation UmanlyViewController

- (void)viewDidLoad
{
 
    UmanlyClientDelegate *umanlyClientDelegate = [[UmanlyClientDelegate alloc] init];

    if (self.umanlyClientDelegate == nil) {
        self.umanlyClientDelegate = umanlyClientDelegate;
    }
    
    if (self.umanlyChatDelegate == nil) {
        self.umanlyChatDelegate = [[UmanlyChatDelegate alloc] init];
    }
    if (self.viewUtility == nil) {
        self.viewUtility = [[ViewUtility alloc] init];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) startListeningForChatRequests
{
    User *user = [User sharedUser];
    [self.umanlyChatDelegate listenForIncomingChatRequestsForUser:user.userId
                                               withSuccessHandler:^(){
                                                   NSLog(@"Chat request received. Seguing to chat confirmation view");
                                                   [self segueToChatConfirmation];
                                               }
                                               withFailureHandler:^(){
                                                   [self.viewUtility showAlertMessage:@"Error connecting to chat" withTitle:@""];
                                               }];
}


-(void) segueToChatConfirmation
{
    ChatConfirmationController *chatConfirmationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatConfirmationController"];
    chatConfirmationVC.userIdForIncomingChatRequest = self.umanlyChatDelegate.userIdForIncomingChatRequest;
    [self segueToDestinationViewController:chatConfirmationVC
          fromSourceViewController:self];
}

-(void) segueToDestinationViewController:(UmanlyViewController *) destinationViewController
                fromSourceViewController:(UmanlyViewController *) sourceViewController
{
    UmanlyStoryboardSegue *segue = [[UmanlyStoryboardSegue alloc] initWithIdentifier:@"" source:sourceViewController destination:destinationViewController];
    [self prepareSegueForDestinationViewController:destinationViewController];
    //[self prepareForSegue:segue sender:sourceViewController];
    [segue perform];
}

-(void) prepareSegueForDestinationViewController:(UmanlyViewController *) destinationViewController
{
    destinationViewController.sourceViewControllerIdentifier = self.currentViewControllerIdentifier;

}


@end
