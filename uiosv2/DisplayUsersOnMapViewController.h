//
//  DisplayUsersOnMapViewController.h
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "User.h"
#import "UmanlyClientDelegate.h"

@interface DisplayUsersOnMapViewController : UIViewController <MKMapViewDelegate>

@property User *user;
@property UmanlyClientDelegate *umanlyClientDelegate;
@property CLLocationManager *locationManager;

@end
