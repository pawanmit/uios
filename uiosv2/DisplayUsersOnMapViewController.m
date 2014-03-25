//
//  DisplayUsersOnMapViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "DisplayUsersOnMapViewController.h"
#import "UmanlyClientDelegate.h"
#import "AppDelegate.h"

@interface DisplayUsersOnMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;

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
    [self.map setDelegate: self];
    self.map.showsUserLocation=YES;
    
    //if (nil == self.locationManager)
    //    self.locationManager = [[CLLocationManager alloc] init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
    
    UmanlyClientDelegate *umanlyClientDelegate = [[UmanlyClientDelegate alloc] init];
    self.umanlyClientDelegate = umanlyClientDelegate;
    
    NSLog(@"User Loaded from DisplayUsersOnMapViewController with id %@", self.user.userId );
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateAnnotations) userInfo:nil repeats:YES];


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
                                    //self.map setS
                                }];
}

-(void) updateAnnotations {
    NSLog(@"updating annotations");
    [self.umanlyClientDelegate getUsersNearUser:self.user
                             withSuccessHandler:^{} ];
}

@end
