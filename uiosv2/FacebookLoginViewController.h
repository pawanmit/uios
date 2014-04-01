//
//  FacebookLoginViewController.h
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "UmanlyViewController.h"

@interface FacebookLoginViewController : UmanlyViewController <FBLoginViewDelegate>

@property (strong, nonatomic) NSString *objectID;

@end
