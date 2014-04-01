//
//  DisplayUsersOnMapViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "DisplayUsersOnMapViewController.h"
#import "AFNetworking.h"
#import "UserAnnotationView.h"
#import "ViewUtility.h"

@interface DisplayUsersOnMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *userMenuButton;

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
    [self prepareView];
    
    [self.map setDelegate: self];
    self.map.showsUserLocation=YES;
    
    //if (nil == self.locationManager)
    //    self.locationManager = [[CLLocationManager alloc] init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
    
    UmanlyClientDelegate *umanlyClientDelegate = [[UmanlyClientDelegate alloc] init];
    self.umanlyClientDelegate = umanlyClientDelegate;
    
    NSLog(@"User Loaded from DisplayUsersOnMapViewController with id %@", self.user.userId );
    
    //[self updateAnnotations];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(locateNearByUsers) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(updateNeayByUsersAnnotations) userInfo:nil repeats:YES];
    
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
                                    NSLog(@"User location updated to Longitude %f and Latitude %f ",  self.user.location.longitude, self.user.location.latitude);
                                    self.map.centerCoordinate = userLocation.location.coordinate;
                                    CLLocationCoordinate2D clLocation;
                                    clLocation.latitude = self.user.location.latitude;
                                    clLocation.longitude =self.user.location.longitude;
                                    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(clLocation, 1000, 1000);
                                    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
                                    [self.map setRegion:adjustedRegion animated:YES];
                                }
                       withFailureHandler:^() {}];
}

-(void) locateNearByUsers
{
    NSLog(@"Finding nearby Users");
    [self.umanlyClientDelegate getUsersNearUser:self.user
                             withSuccessHandler:^{
                                 self.user = self.umanlyClientDelegate.user;
                                 }
                             withFailureHandler:^{}
     ];
}

-(void) updateNeayByUsersAnnotations {
    NSLog(@"updating annotations");
    [self.map removeAnnotations:[self.map annotations]];
    for (User *nearByUser in self.user.nearByUsers) {
        //Don't add annoatation for current user
        if (![nearByUser.userId isEqualToString:self.user.userId]) {
            [self addNearByUserAnnotation:nearByUser];
        }
    }
}

-(void) updateNearByUserFacebookProfileImages
{
    
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
    NSLog(@"Adding annotation with title %@", title);
    [self.map addAnnotation:annotation];
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


@end
