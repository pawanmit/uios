//
//  ChatUITableViewCell.h
//  UmanlyChatUI
//
//  Created by Mittal, Pawan on 5/9/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"
@interface ChatUITableViewCell : UITableViewCell

@property ChatMessage *chatMessage;
@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic) BOOL showAvatar;
@property (nonatomic, retain) UIImageView *avatarImage;

@end
