//
//  UserMenuViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/28/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UserMenuViewController.h"
#import "ViewUtility.h"
#import "DisplayUsersOnMapViewController.h"

@interface UserMenuViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *messagesButton;
@property (weak, nonatomic) IBOutlet UISwitch *availabilitySwitch;

@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@end

@implementation UserMenuViewController

- (IBAction)availabilitySwiched:(id)sender {
    BOOL isAvailable;
    User *user = [User sharedUser];
    if(self.availabilitySwitch.on) {
        NSLog(@"User id %@ Availability On.", user.userId);
        isAvailable = YES;
    }
    else {
        NSLog(@"User id %@ Availability Off.", user.userId);
        isAvailable = NO;
    }
    [self.umanlyClientDelegate updateUserAvailability:isAvailable
                                   withSuccessHandler:^() {
                                       user.isAvailable = isAvailable;
                                   }
                                   withFailureHandler:^() {
                                       [self.availabilitySwitch setOn:!isAvailable];
                                       [ self.viewUtility showAlertMessage:@"Unable to change your availabilty status. Plese try again"
                                                                withTitle:@"Operation Failed" ];
                                   }

     ];
}


- (void)viewDidLoad
{
    //NSLog(@"UserMenuViewController: User loaded with id %@", self.user.userId);
    [self prepareView];
    self.currentViewControllerIdentifier = @"UserMenuViewController";

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL) animated

{
    self.sourceViewController = self;

    [self startListeningForChatRequests];
    
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareView
{
    UIImage *backgroundImage = [UIImage imageNamed: @"Umanly_app_Menu_Background.png"];
    self.backgroundImageView.image =  backgroundImage;

    [self.profileButton setBackgroundImage:[UIImage imageNamed:@"User_Menu_Profile_Button.png"] forState:UIControlStateNormal];
    [self.mapButton setBackgroundImage:[UIImage imageNamed:@"User_Menu_Map_Button.png"] forState:UIControlStateNormal];
    [self.mapButton addTarget:self
                         action:@selector(segueToMapView)
               forControlEvents:UIControlEventTouchUpInside];
    [self.messagesButton setBackgroundImage:[UIImage imageNamed:@"User_Menu_Messages_Button.png"] forState:UIControlStateNormal];
}

-(void)segueToMapView
{
    DisplayUsersOnMapViewController *userMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DisplayUsersOnMapViewController"];
    [self segueToDestinationViewController:userMapViewController fromSourceViewController:self];
    
}

-(void) prepareSegueForDestinationViewController:(UmanlyViewController *)destinationViewController
{
    [super prepareSegueForDestinationViewController:destinationViewController];
}
@end
