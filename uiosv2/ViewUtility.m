//
//  ViewUtility.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/28/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "ViewUtility.h"

@implementation ViewUtility

-(void) showAlertMessage:(NSString *) message
               withTitle:(NSString *) title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
