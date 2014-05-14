//
//  UmanlyViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/1/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UmanlyViewController.h"
#import "ChatConfirmationController.h"
#import "ChatUIViewConroller.h"
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
    
    if (self.umanlyChatService == nil) {
        self.umanlyChatService = [UmanlyChatService sharedChatService];
        self.umanlyChatService.delegate = self;
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
    [self.umanlyChatService listenForIncomingChatRequests:nil
                                               withSuccessHandler:^(){}
                                               withFailureHandler:^(){
                                                   [self.viewUtility showAlertMessage:@"Error connecting to chat" withTitle:@""];
                                               }];
}

-(void) chatRequestReceived
{
  NSLog(@"Chat request received. Seguing to chat confirmation view");
  [self segueToChatConfirmation];
}

-(void) chatRequestDeclined
{
    [self.viewUtility showAlertMessage:@"Chat Request Declined" withTitle:@""];
}

-(void) chatRequestAccepted
{
    NSLog(@"Chat request accepted. Seguing to chat window view");
    [self segueToChatWindow];
}

-(void) sendNotification
{
    UILocalNotification *chatNotification = [[UILocalNotification alloc] init];
     chatNotification.fireDate = [NSDate date];
    chatNotification.timeZone = [NSTimeZone defaultTimeZone];
    chatNotification.alertBody = @"hello";
    chatNotification.soundName = UILocalNotificationDefaultSoundName;
    chatNotification.applicationIconBadgeNumber = 1;
    chatNotification.alertAction = @"View";
    [[UIApplication sharedApplication] scheduleLocalNotification:chatNotification];
}

-(void) segueToChatWindow
{
    ChatUIViewConroller *chatWindowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatUIViewConroller"];
    chatWindowVC.userIdForIncomingChatRequest = self.umanlyChatService.userIdForIncomingChatRequest;
    [self segueToDestinationViewController:chatWindowVC
                  fromSourceViewController:self];
}


-(void) segueToChatConfirmation
{
    ChatConfirmationController *chatConfirmationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatConfirmationController"];
    chatConfirmationVC.userIdForIncomingChatRequest = self.umanlyChatService.userIdForIncomingChatRequest;
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
