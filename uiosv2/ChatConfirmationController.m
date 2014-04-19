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

@end

@implementation ChatConfirmationController


- (void)viewDidLoad
{
    NSLog(@"Received chat request from %@", self.chatRequestSenderId );
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
    [self.userMenuButton setBackgroundImage:[UIImage imageNamed:@"Umanly_app_Hamburger_Button.png"] forState:UIControlStateNormal];
    self.logoLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Umanly_Logo_Top.png"]];
    
}


@end
