//
//  UmanlyChatDelegate.h
//  uiosv2
//
//  Created by Mittal, Pawan on 4/17/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FireBaseDelegate.h"

@interface UmanlyChatDelegate : NSObject

@property FireBaseDelegate *fireBaseDelegate;

-(void) requestChatWithUser:(NSString *) userId;

-(void) listenForIncomingChatRequestsForUser:(NSString *) userId;

@end
