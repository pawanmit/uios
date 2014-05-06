//
//  DisplayUserProfileViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/3/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserMenuViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *userMenuButton;

@property (weak, nonatomic) IBOutlet UILabel *labelForBasicInfo;

@property (weak, nonatomic) IBOutlet UILabel *labelForGeneralInterests;

@property (weak, nonatomic) IBOutlet UILabel *labelForChatInterests;
@property (weak, nonatomic) IBOutlet UIButton *greetUserButton;
@property (weak, nonatomic) IBOutlet UILabel *labelForTopBar;
@property (weak, nonatomic) IBOutlet UILabel *labelForBasicInfoData;
@property (weak, nonatomic) IBOutlet UILabel *labelForHeadingData;
@end

@implementation UserProfileViewController


- (void)viewDidLoad
{
    User *currentUser = [User sharedUser];
    User *profiledUser = [currentUser.nearByUsers objectForKey:self.userIdOfProfiledUser];
    NSLog(@"UserProfileViewController: Loading user %@", profiledUser.firstName);
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
    
    [self.userMenuButton setBackgroundImage:[UIImage imageNamed:@"Umanly_app_Hamburger_Button.png"] forState:UIControlStateNormal];
    [self.userMenuButton addTarget:self
                            action:@selector(segueToUserMenu)
                  forControlEvents:UIControlEventTouchUpInside];
    
    self.labelForBasicInfo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"User_Profile_Basic_Info_Icon.png"]];
    self.labelForGeneralInterests.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"User_Profile_General_Interests_Icon.png"]];
    self.labelForChatInterests.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"User_Profile_Chat_Interests_Icon.png"]];
    self.labelForTopBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"User_Profile_Top_Bar.png"]];

    [self.greetUserButton setBackgroundImage:[UIImage imageNamed:@"Greetings_Button.png"] forState:UIControlStateNormal];
    [self.greetUserButton setTitle:@"Say Hello" forState:UIControlStateNormal];
    [self.greetUserButton addTarget:self
                         action:@selector(greetUser)
                        forControlEvents:UIControlEventTouchUpInside];
    User *currentUser = [User sharedUser];
    User *profiledUser = [currentUser.nearByUsers objectForKey:self.userIdOfProfiledUser];
    self.labelForHeadingData.text = [NSString stringWithFormat:@"%@ %@\r%@", profiledUser.firstName, profiledUser.lastName, profiledUser.hometown];
    
    if ( (profiledUser.birthday != nil) && (profiledUser.birthday != [NSNull null]) ) {
        int age = [self calculateAge:profiledUser.birthday];
        self.labelForBasicInfoData.text = [NSString stringWithFormat:@"AGE: %d\rGENDER: %@", age, profiledUser.gender];
    }
}

-(void) segueToUserMenu
{
    UserMenuViewController *userMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserMenuViewController"];
    [self segueToDestinationViewController:userMenuVC fromSourceViewController:self];
}

-(void) greetUser
{
    NSLog(@"Greeting user: %@", self.userIdOfProfiledUser );
    //check if profiled user chat_status is available.
    [self.umanlyClientDelegate getUserById:self.userIdOfProfiledUser
                        withSuccessHandler:^{
                            User *profiledUser = self.umanlyClientDelegate.user;
                            NSLog(@"User chat status %@", profiledUser.chatStatus );
                            if ( [profiledUser.chatStatus isEqualToString:@"available"] ) {
                                User *currentUser = [User sharedUser];
                                [self.umanlyChatDelegate sendChatRequestToUser:profiledUser.userId
                                      withSuccessHandler:^(){
                                    }
                                     withFailureHandler:^{
                                         
                                     }];
                            } else {
                                NSString *message = [NSString stringWithFormat:@"%@ not available for chat right now", profiledUser.firstName];
                                [self.viewUtility showAlertMessage:message withTitle:@""];
                            }
                        }
                        withFailureHandler:^{
                            [self.viewUtility showAlertMessage:@"Please try again" withTitle:@""];
                        }];
}

-(void) sendChatRequestToUser:(NSString *) userId
{
    NSLog(@"Requesting chat with user %@", userId);
    
}

- (NSInteger)calculateAge:(NSString *)birthday {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"LL/d/yyyy"];
    NSDate *dateOfBirth = [dateFormat dateFromString:birthday];
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:dateOfBirth
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}
@end
