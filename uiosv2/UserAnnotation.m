//
//  UserAnnotation.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/25/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UserAnnotation.h"

@implementation UserAnnotation

- initWithPosition:(CLLocationCoordinate2D)coords {
    if (self = [super init]) {
        self.coordinate = coords;
    }
    return self;
}

@end
