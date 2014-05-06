//
//  DisplayUsersOnMapViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "DisplayUsersOnMapViewController.h"
#import "UserAnnotationView.h"
#import "AFNetworking.h"

#include "UserMenuViewController.h"
#include "UserProfileViewController.h"

@interface DisplayUsersOnMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *userMenuButton;

@property NSTimer *locateNearByUsersTimer;
@property NSTimer *updateNeayByUsersAnnotationsTimer;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;

@end

@implementation DisplayUsersOnMapViewController


- (void)viewDidLoad
{
    [self prepareView];
    
    [self.map setDelegate: self];
    self.map.showsUserLocation=YES;
        
    //NSLog(@"User Loaded from DisplayUsersOnMapViewController with id %@", self.user.userId );
    
    
    [self scheduleTimers];
    
    User *user = [User sharedUser];
    [self showUserOnMap:user.location];
    self.currentViewControllerIdentifier = @"DisplayUsersOnMapViewController";

    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL) animated

{

    [self startListeningForChatRequests];
    
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView
    didUpdateUserLocation: (MKUserLocation *)userLocation
{
    if (userLocation.location.horizontalAccuracy > 1) {
        UserLocation *currentLocation = [[UserLocation alloc] init];
        currentLocation.longitude = userLocation.location.coordinate.longitude;
        currentLocation.latitude = userLocation.location.coordinate.latitude;
        User *user = [User sharedUser];
        [self.umanlyClientDelegate updateUser:user
                                    withLocation:currentLocation
                                    withSuccessHandler: ^()
                                    {
                                        [self showUserOnMap:user.location];
                                    }
                           withFailureHandler:^() {}];
    } else {
        NSLog(@"skipping location update. horizontalAccuracy < 1");
    }
}

-(void) locateNearByUsers
{
    NSLog(@"Finding nearby Users");
    User *user = [User sharedUser];
    [self.umanlyClientDelegate getUsersNearUser:user
                             withSuccessHandler:^{
                                 if ([self.locateNearByUsersTimer isValid]) {
                                     [self updateNearByUsers:self.umanlyClientDelegate.nearByUsers];
                                    }
                                 }
                             withFailureHandler:^{}
     ];
}

-(void) updateNearByUsers:(NSArray *) nearByUsers
{
    User *currentUser = [User sharedUser];
    for (id user in nearByUsers) {
        User *nearByUser = (User *) user;
        User *existingNearByUser = [currentUser.nearByUsers objectForKey:nearByUser.userId];
        if ( existingNearByUser ) {
            //update user location
            existingNearByUser.location = nearByUser.location;
        } else{
            NSLog(@"Adding near by user with id %@", currentUser.userId);
            [currentUser.nearByUsers setValue:user forKey:nearByUser.userId];
            [self getFacebookProfileImageForUser:nearByUser];
        }
    }
}


-(void) updateNeayByUsersAnnotations
{
    NSLog(@"updating annotations");
    [self.map removeAnnotations:[self.map annotations]];
    User *user = [User sharedUser];
    for (id userId in user.nearByUsers) {
        User *nearByUser = [user.nearByUsers objectForKey:userId];
        //Don't add annoatation for current user and users with availabilty off
        if ( (![nearByUser.userId isEqualToString:user.userId]) && nearByUser.isAvailable) {
            [self addNearByUserAnnotation:nearByUser];
        }
    }
    //[self unscheduleTimers];

}


-(void) addNearByUserAnnotation:(User *) nearByUser
{
    CLLocationCoordinate2D clLocation;
    clLocation.latitude = [nearByUser.location latitude];
    clLocation.longitude = nearByUser.location.longitude;
    NSString *title = [NSString stringWithFormat:@"%@ %@", nearByUser.firstName, nearByUser.lastName];
    UserAnnotation *annotation = [[UserAnnotation alloc] initWithPosition:clLocation];
    annotation.title = title;
    annotation.facebookUsername = nearByUser.facebookUsername;
    UIButton *annotationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationButton.tag = [nearByUser.userId integerValue];
    [annotationButton addTarget:self
                         action:@selector(segueToDisplayUserProfile:)
                     forControlEvents:UIControlEventTouchUpInside];
    annotation.annotationButton = annotationButton;
    NSLog(@"Adding annotation with title %@", title);
    annotation.annotationImage = nearByUser.facebookProfileImage;
    [self.map addAnnotation:annotation];
}

-(void) segueToDisplayUserProfile:(id)sender
{
    UserProfileViewController *userProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    UIButton *buttonClicked = (UIButton*) sender;
    userProfileViewController.userIdOfProfiledUser = [NSString stringWithFormat:@"%d",(int)buttonClicked.tag];
    [self segueToDestinationViewController:userProfileViewController fromSourceViewController:self];
}

-(void) segueToUserMenu
{
    UserMenuViewController *userMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserMenuViewController"];
    [self segueToDestinationViewController:userMenuVC fromSourceViewController:self];
}

-(void) prepareSegueForDestinationViewController:(UmanlyViewController *) destinationViewController
{
    [self unscheduleTimers];
    [super prepareSegueForDestinationViewController:destinationViewController];
}

-(void) scheduleTimers
{
    //[self updateAnnotations];
    self.locateNearByUsersTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(locateNearByUsers) userInfo:nil repeats:YES];
    self.updateNeayByUsersAnnotationsTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(updateNeayByUsersAnnotations) userInfo:nil repeats:YES];
    
}

-(void) unscheduleTimers
{
    if (self.locateNearByUsersTimer != nil) {
        [self.locateNearByUsersTimer invalidate];
         self.locateNearByUsersTimer = nil;
    }
    
    if (self.updateNeayByUsersAnnotationsTimer != nil) {
        [self.updateNeayByUsersAnnotationsTimer invalidate];
        self.updateNeayByUsersAnnotationsTimer = nil;
    }
}

- (void)prepareView
{
    [self.userMenuButton setBackgroundImage:[UIImage imageNamed:@"Umanly_app_Hamburger_Button.png"] forState:UIControlStateNormal];
    [self.userMenuButton addTarget:self
                            action:@selector(segueToUserMenu)
                  forControlEvents:UIControlEventTouchUpInside];
    self.logoLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Umanly_Logo_Top.png"]];
}


- (void) showUserOnMap: (UserLocation *) location
{
    User *user = [User sharedUser];
    NSLog(@"User location: Longitude %f and Latitude %f ",  user.location.longitude, user.location.latitude);
    //self.map.centerCoordinate = userLocation.location.coordinate;
    CLLocationCoordinate2D clLocation;
    clLocation.latitude = location.latitude;
    clLocation.longitude = location.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(clLocation, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
    [self.map setRegion:adjustedRegion animated:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    static NSString *identifier = @"pin";
    UserAnnotationView *view = (UserAnnotationView *)[self.map dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (view == nil) {
        view = [[UserAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    return view;
}

-(void) setImageForAnnotation:(UserAnnotation *) annotation
     withSuccessHandler: (void(^)(void))successHandler
     withFailureHandler: (void(^)(void))failureHander

{
    NSString *facebookProfileImageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", annotation.facebookUsername];
    NSURL *imageURL = [NSURL URLWithString:facebookProfileImageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success getting facebook profile image for  %@" ,  annotation.facebookUsername);
        annotation.annotationImage = responseObject;
        successHandler();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error getting facebook profile image for  %@" ,  annotation.facebookUsername);
        UIImage *annotationImage = [UIImage imageNamed:@"test_annotation.png"];
        failureHander();
        annotation.annotationImage = annotationImage;
        NSLog(@"error: %@" , error);
    }];
    [operation start];
}

-(void) getFacebookProfileImageForUser:(User *) user
{
    NSString *facebookProfileImageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", user.facebookUsername];
    NSURL *imageURL = [NSURL URLWithString:facebookProfileImageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success getting facebook profile image for  %@" ,  user.facebookUsername);
        user.facebookProfileImage = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error getting facebook profile image for  %@" ,  user.facebookUsername);
        UIImage *annotationImage = [UIImage imageNamed:@"test_annotation.png"];
        user.facebookProfileImage = annotationImage;
        NSLog(@"error: %@" , error);
    }];
    [operation start];
}

@end
