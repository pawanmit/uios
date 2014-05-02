//
//  ChatConfirmationController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/18/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "ChatConfirmationController.h"

@interface ChatConfirmationController ()
@property (weak, nonatomic) IBOutlet UIButton *userMenuButton;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptChatRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *denyChatRequestButton;
@property (weak, nonatomic) IBOutlet UILabel *chatRequestLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfChatRequestSender;

@end

@implementation ChatConfirmationController


- (void)viewDidLoad
{
    //NSLog(@"Received chat request from %@", self.chatRequestSenderId );
    [self prepareView];
    [super viewDidLoad];
    self.currentViewControllerIdentifier = @"ChatConfirmationController";
	// Do any additional setup after loading the view.
    //NSLog(@"Chat request received for user %@ from user %@", self.user.userId, self.userIdForIncomingChatRequest);
}

-(void) viewDidAppear:(BOOL) animated

{
    [super viewDidAppear:animated];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareView
{
    [self.userMenuButton setBackgroundImage:[UIImage imageNamed:@"Umanly_app_Hamburger_Button.png"] forState:UIControlStateNormal];
    self.logoLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Umanly_Logo_Top.png"]];
    [self.userMenuButton addTarget:self
                         action:@selector(segueToUserMenu)
               forControlEvents:UIControlEventTouchUpInside];
    [self.denyChatRequestButton addTarget:self
                                   action:@selector(denyChatRequest)
                         forControlEvents:UIControlEventTouchUpInside];

}

-(void) denyChatRequest
{
    User *user = [User sharedUser];
    NSLog(@"User %@ denied chat request from user %@", user.userId, self.userIdForIncomingChatRequest);
    
    [self.umanlyChatDelegate declineChatRequestFromSender:self.userIdForIncomingChatRequest
                                toReceiver:user.userId
                           withSuccessHandler:^() {
        //code
    }
                           withFailureHandler:^() {
        //code
                           }];
    NSLog(@"Seguing to controller: %@", self.sourceViewControllerIdentifier);
    UmanlyViewController *destinationViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.sourceViewControllerIdentifier];
    [self segueToDestinationViewController:destinationViewController fromSourceViewController:self];
}




@end
