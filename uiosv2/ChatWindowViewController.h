//
//  ChatMessagingViewController.h
//  uiosv2
//
//  Created by Mittal, Pawan on 5/1/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "UmanlyViewController.h"
#import "UIBubbleTableViewDataSource.h"

@interface ChatWindowViewController : UmanlyViewController <UIBubbleTableViewDataSource>

@property NSString* userIdForIncomingChatRequest;
@property NSMutableArray *bubbleData;

@end
