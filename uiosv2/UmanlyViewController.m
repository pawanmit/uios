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
    [self.umanlyChatDelegate listenForIncomingChatRequestsForUser:self.user.userId
                                               withSuccessHandler:^(){
                                                   NSLog(@"Chat request received. Seguing to chat confirmation view");
                                                   [self segueToChatConfirmation];
                                               }
                                               withFailureHandler:^(){
                                                   [self.viewUtility showAlertMessage:@"Error connecting to chat" withTitle:@""];
                                               }];
}


-(void) segueToUserMenu

{
    UserMenuViewController *userMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserMenuViewController"];
    userMenuVC.user = self.user;
    [self segueToViewController:userMenuVC];
}

-(void) segueToChatConfirmation
{
    ChatConfirmationController *chatConfirmationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatConfirmationController"];
    chatConfirmationVC.userIdForIncomingChatRequest = self.umanlyChatDelegate.userIdForIncomingChatRequest;
    chatConfirmationVC.user = self.user;
    [self segueToViewController:chatConfirmationVC];
}

-(void) segueToViewController:(UmanlyViewController *) nextVC
{
    UmanlyStoryboardSegue *segue = [[UmanlyStoryboardSegue alloc] initWithIdentifier:@"" source:self.currentController destination:nextVC];
    [self prepareForSegue:segue sender:self];
    [segue perform];
}
@end
