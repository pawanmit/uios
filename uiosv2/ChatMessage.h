//
//  ChatMessage.h
//  UmanlyChatUI
//
//  Created by Mittal, Pawan on 5/8/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _MessageType
{
    TypeMine = 0,
    TypeSomeoneElse = 1
} MessageType;

@interface ChatMessage : NSObject

@property  NSString *text;
@property UIImage *avatar;
@property NSDate *timeStamp;
@property MessageType type;
@property UIView *view;
@property UIEdgeInsets insets;

+ (id)initWithText:(NSString *)text date:(NSDate *)date type:(MessageType)type;

@end
