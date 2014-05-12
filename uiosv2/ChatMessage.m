//
//  ChatMessage.m
//  UmanlyChatUI
//
//  Created by Mittal, Pawan on 5/8/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

const UIEdgeInsets textInsetsMine = {5, 10, 11, 17};
const UIEdgeInsets textInsetsSomeone = {5, 15, 11, 10};


+ (id)initWithText:(NSString *)text date:(NSDate *)timeStamp type:(MessageType)type
{
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(220, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    
    UIEdgeInsets insets = (type == TypeMine ? textInsetsMine : textInsetsSomeone);
    ChatMessage *chatMessage = [[ChatMessage alloc] init];
    chatMessage.text = text;
    chatMessage.view = label;
    chatMessage.timeStamp = timeStamp;
    chatMessage.type = type;
    chatMessage.insets = insets;
    return chatMessage;
}

@end
