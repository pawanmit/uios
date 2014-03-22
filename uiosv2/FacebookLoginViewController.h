//
//  FacebookLoginViewController.h
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookLoginViewController : UIViewController <FBLoginViewDelegate>

@property (strong, nonatomic) NSString *objectID;

@end
