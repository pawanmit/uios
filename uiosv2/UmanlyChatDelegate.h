//
//  UmanlyChatDelegate.h
//  uiosv2
//
//  Created by Mittal, Pawan on 5/6/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UmanlyChatDelegate

@required
- (void) chatRequestReceived;

@required
- (void) chatRequestDeclined;

@required
- (void) chatRequestAccepted;

@required
- (void) chatMessageReceived;

@required
- (void) chatTerminated;

@end
