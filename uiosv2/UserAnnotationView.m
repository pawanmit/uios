//
//  UserAnnotationView.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/27/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UserAnnotationView.h"
#import "UserAnnotation.h"

@implementation UserAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if ( [annotation isKindOfClass:[UserAnnotation class]] ) {
        UserAnnotation *userAnnotation = (UserAnnotation *)annotation;
        UIImageView *annotationImageView = [[UIImageView alloc] initWithImage:userAnnotation.annotationImage];
        self.image = [UIImage imageNamed:@"Umanly_app_annotation_pin.png"];
        self.enabled = YES;
        self.canShowCallout = YES;
        self.leftCalloutAccessoryView = annotationImageView;
    }
    
    return self;
}

@end
