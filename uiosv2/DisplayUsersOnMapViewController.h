//
//  DisplayUsersOnMapViewController.h
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

#import "UmanlyViewController.h"
#import "UserAnnotation.h"


@interface DisplayUsersOnMapViewController : UmanlyViewController <MKMapViewDelegate>

@property CLLocationManager *locationManager;

@end
