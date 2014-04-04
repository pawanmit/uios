//
//  DisplayUserProfileViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/3/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "DisplayUserProfileViewController.h"

@interface DisplayUserProfileViewController ()

@end

@implementation DisplayUserProfileViewController


- (void)viewDidLoad
{
    User *currentUser = [self.user.nearByUsers objectForKey:self.currentUserId];
    NSLog(@"DisplayUserProfileViewController: Loading user %@", currentUser.firstName);
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
