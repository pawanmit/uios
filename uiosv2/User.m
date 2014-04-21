//
//  User.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "User.h"

@implementation User

-(id) init
{
    self = [super init];
    
    if (self)
    {
        self.nearByUsers = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

@end
