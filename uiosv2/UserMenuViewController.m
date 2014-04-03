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
    if(self.availabilitySwitch.on) {
        NSLog(@"User id %@ Availability On.", self.user.userId);
        isAvailable = YES;
    }
    else {
        NSLog(@"User id %@ Availability Off.", self.user.userId);
        isAvailable = NO;
    }
    self.umanlyClientDelegate.user = self.user;
    [self.umanlyClientDelegate updateUserAvailability:isAvailable
                                   withSuccessHandler:^() {self.user.isAvailable = isAvailable;}
                                   withFailureHandler:^() {
                                       [self.availabilitySwitch setOn:!isAvailable];
                                       [ self.viewUtility showAlertMessage:@"Unable to change your availabilty status. Plese try again"
                                                                withTitle:@"Operation Failed" ];
                                   }

     ];
}


- (void)viewDidLoad
{
    NSLog(@"UserMenuViewController: User loaded with id %@", self.user.userId);
    [self prepareView];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareView
{
    ViewUtility *viewUtility = [[ViewUtility alloc] init];
    UIImage *backgroundImage = [UIImage imageNamed: @"Umanly_app_Menu_Background.png"];
    self.backgroundImageView.image =  backgroundImage;

    [self.profileButton setBackgroundImage:[UIImage imageNamed:@"User_Menu_Profile_Button.png"] forState:UIControlStateNormal];
    //[viewUtility changButtonSize:self.profileButton withWidth:154 withHeight:35];
    [self.mapButton setBackgroundImage:[UIImage imageNamed:@"User_Menu_Map_Button.png"] forState:UIControlStateNormal];
    //[viewUtility changButtonSize:self.mapButton withWidth:154 withHeight:35];
    [self.messagesButton setBackgroundImage:[UIImage imageNamed:@"User_Menu_Messages_Button.png"] forState:UIControlStateNormal];
    //[viewUtility changButtonSize:self.messagesButton withWidth:154 withHeight:35];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToMapView"])
    {
        DisplayUsersOnMapViewController *nextVC = [segue destinationViewController];
        nextVC.sourceView = @"UserMenuView";
        nextVC.user = self.user;
    }
}

@end
