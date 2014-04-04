//
//  DisplayUserProfileViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/3/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *labelForBasicInfo;

@property (weak, nonatomic) IBOutlet UILabel *labelForGeneralInterests;

@property (weak, nonatomic) IBOutlet UILabel *labelForChatInterests;
@end

@implementation UserProfileViewController


- (void)viewDidLoad
{
    User *currentUser = [self.user.nearByUsers objectForKey:self.currentUserId];
    NSLog(@"DisplayUserProfileViewController: Loading user %@", currentUser.firstName);
    [self prepareView];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareView
{
    UIImage *backgroundImage = [UIImage imageNamed: @"User_Profile_Background.png"];
    self.backgroundImageView.image =  backgroundImage;
    
    self.labelForBasicInfo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"User_Profile_Basic_Info_Icon.png"]];
    self.labelForGeneralInterests.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"User_Profile_General_Interests_Icon.png"]];
    self.labelForChatInterests.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"User_Profile_Chat_Interests_Icon.png"]];

}

@end
