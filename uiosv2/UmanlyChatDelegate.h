//
//  UmanlyChatDelegate.h
//  uiosv2
//
//  Created by Mittal, Pawan on 5/6/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UmanlyChatDelegate

- (void) chatRequestReceived;

- (void) chatRequestDeclined;

- (void) chatRequestAccepted;

- (void) chatMessageReceived:(NSString *) chatMessage;

- (void) chatTerminated;

@end
