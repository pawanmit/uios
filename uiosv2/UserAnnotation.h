//
//  UserAnnotation.h
//  uiosv2
//
//  Created by Mittal, Pawan on 3/25/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UserAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property NSString* facebookUsername;
@property UIImage *annotationImage;
@property UIButton *annotationButton;


- initWithPosition:(CLLocationCoordinate2D)coords;


@end
