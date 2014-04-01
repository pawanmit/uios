//
//  UserMenuViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/28/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UserMenuViewController.h"
#import "ViewUtility.h"

@interface UserMenuViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *messagesButton;

@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@end

@implementation UserMenuViewController

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

    [self.profileButton setBackgroundImage:[UIImage imageNamed:@"Umanly_app_Profile_Button.png"] forState:UIControlStateNormal];
    //[viewUtility changButtonSize:self.profileButton withWidth:154 withHeight:35];
    [self.mapButton setBackgroundImage:[UIImage imageNamed:@"Umanly_app_Map_Button.png"] forState:UIControlStateNormal];
    //[viewUtility changButtonSize:self.mapButton withWidth:154 withHeight:35];
    [self.messagesButton setBackgroundImage:[UIImage imageNamed:@"Umanly_app_Messages_Button.png"] forState:UIControlStateNormal];
    //[viewUtility changButtonSize:self.messagesButton withWidth:154 withHeight:35];

    
}

@end
