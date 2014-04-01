//
//  UmanlyViewController.h
//  uiosv2
//
//  Created by Mittal, Pawan on 4/1/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserLocation.h"
#import "ViewUtility.h"
#import "UmanlyClientDelegate.h"

@interface UmanlyViewController : UIViewController

@property NSString *sourceView;
@property User *user;
@property UmanlyClientDelegate *umanlyClientDelegate;

@end
