//
//  ChatViewDataSource.h
//  UmanlyChatUI
//
//  Created by Mittal, Pawan on 5/8/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessage.h"
#import "ChatUITableViewCell.h"
#import "ChatUIHeaderTableViewCell.h"

@interface ChatUIDataSource : NSObject <UITableViewDataSource>

@property NSMutableArray *chatMessages;

@property NSMutableArray *chatSections;

+ (id)sharedChatUIDataSource;

-(void) addChatMessage:(ChatMessage *) chatMessage;

- (NSInteger)rowsCountForMessageTable;

-(ChatMessage *) getMessageAtRow:(NSInteger *) row;

@end
