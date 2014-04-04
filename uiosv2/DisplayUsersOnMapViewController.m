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
#include "DisplayUserProfileViewController.h"


@interface DisplayUsersOnMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *userMenuButton;

@property NSTimer *locateNearByUsersTimer;
@property NSTimer *updateNeayByUsersAnnotationsTimer;

@end

@implementation DisplayUsersOnMapViewController


- (void)viewDidLoad
{
    [self prepareView];
    
    [self.map setDelegate: self];
    self.map.showsUserLocation=YES;
        
    NSLog(@"User Loaded from DisplayUsersOnMapViewController with id %@", self.user.userId );
    
    
    [self scheduleTimers];
    
    if ([self.sourceView isEqualToString:@"UserMenuView"]) {
        [self showUserOnMap:self.user.location];
        [self updateNeayByUsersAnnotations];
    }
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView
    didUpdateUserLocation: (MKUserLocation *)userLocation
{
    UserLocation *currentLocation = [[UserLocation alloc] init];
    currentLocation.longitude = userLocation.location.coordinate.longitude;
    currentLocation.latitude = userLocation.location.coordinate.latitude;
    [self.umanlyClientDelegate updateUser:self.user
                                withLocation:currentLocation
                                withSuccessHandler: ^()
                                {
                                    self.user.location = self.umanlyClientDelegate.user.location;
                                    [self showUserOnMap:self.user.location];
                                }
                       withFailureHandler:^() {}];
}

-(void) locateNearByUsers
{
    NSLog(@"Finding nearby Users");
    [self.umanlyClientDelegate getUsersNearUser:self.user
                             withSuccessHandler:^{
                                 if ([self.locateNearByUsersTimer isValid]) {
                                        self.user = self.umanlyClientDelegate.user;
                                    }
                                 }
                             withFailureHandler:^{}
     ];
}

-(void) updateNeayByUsersAnnotations
{
    NSLog(@"updating annotations");
    [self.map removeAnnotations:[self.map annotations]];
    for (User *nearByUser in self.user.nearByUsers) {
        //Don't add annoatation for current user and users with availabilty off
        if ( (![nearByUser.userId isEqualToString:self.user.userId]) && nearByUser.isAvailable) {
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
    [self setImageForAnnotation:annotation
             withSuccessHandler:^(){
                 [self.map addAnnotation:annotation];
             }
             withFailureHandler:^(){
                 [self.map addAnnotation:annotation];
             }
     ];
}

-(void) segueToDisplayUserProfile:(id)sender
{
    UIButton *buttonClicked = (UIButton *)sender;
    NSLog(@"Seguing to user profile with id %d", buttonClicked.tag);
    NSLog(@"Seguing to DisplayUserProfileView");
    [self performSegueWithIdentifier:@"segueToDisplayUserProfile" sender:self];
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


- (void)prepareView
{
    ViewUtility *viewUtility = [[ViewUtility alloc] init];

    [self.userMenuButton setBackgroundImage:[UIImage imageNamed:@"Umanly_app_Hamburger_Button.png"] forState:UIControlStateNormal];
    [viewUtility changButtonSize:self.userMenuButton withWidth:49 withHeight:39];
}


- (void) showUserOnMap: (UserLocation *) location
{
    NSLog(@"User location: Longitude %f and Latitude %f ",  self.user.location.longitude, self.user.location.latitude);
    //self.map.centerCoordinate = userLocation.location.coordinate;
    CLLocationCoordinate2D clLocation;
    clLocation.latitude = location.latitude;
    clLocation.longitude = location.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(clLocation, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
    [self.map setRegion:adjustedRegion animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToUserMenu"])
    {
        UserMenuViewController *nextVC = [segue destinationViewController];
        nextVC.sourceView = @"DisplayUsersOnMapView";
        nextVC.user = self.user;
    } else if ([[segue identifier] isEqualToString:@"segueToDisplayUserProfile"]) {
        DisplayUserProfileViewController *nextVC = [segue destinationViewController];
        nextVC.sourceView = @"DisplayUsersOnMapView";
        nextVC.user = self.user;
        //UIButton *button = (UIButton*) sender;
        //NSLog(@"Loading profile for near by user %i", (int)button.tag);
    }
    
    [self unscheduleTimers];
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

@end
