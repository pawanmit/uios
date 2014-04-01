//
//  ViewUtility.h
//  uiosv2
//
//  Created by Mittal, Pawan on 3/28/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewUtility : NSObject

-(void) showAlertMessage:(NSString *) message
               withTitle:(NSString *) title;

-(void) changButtonSize:(UIButton *) button
              withWidth: (int) width
             withHeight: (int) height;

@end
