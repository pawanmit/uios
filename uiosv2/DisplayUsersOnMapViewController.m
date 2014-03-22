//
//  DisplayUsersOnMapViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "DisplayUsersOnMapViewController.h"
#import "User.h"
#import "UmanlyClientDelegate.h";
#import "AppDelegate.h"

@interface DisplayUsersOnMapViewController ()

@end

@implementation DisplayUsersOnMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"User Loaded from DisplayUsersOnMapViewController with id %@", appDelegate.user.userId );
	// Do any additional setup after loading the view.
    //Get user location
    //Update user object with location and save it to the database.
    //Display user location on the map.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
