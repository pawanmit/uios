//
//  UmanlyStoryboardSegue.m
//  uiosv2
//
//  Created by Mittal, Pawan on 4/18/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UmanlyStoryboardSegue.h"

@implementation UmanlyStoryboardSegue

- (void)perform
{
    // Add your own animation code here.
    
    [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
}

@end
