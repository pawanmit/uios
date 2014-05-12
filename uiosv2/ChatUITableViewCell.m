//
//  ChatUITableViewCell.m
//  UmanlyChatUI
//
//  Created by Mittal, Pawan on 5/9/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "ChatUITableViewCell.h"

@implementation ChatUITableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bubbleImage)
    {
        self.bubbleImage = [[UIImageView alloc] init];
        [self addSubview:self.bubbleImage];
    }
    
    MessageType type = self.chatMessage.type;
    
    CGFloat width = self.chatMessage.view.frame.size.width;
    CGFloat height = self.chatMessage.view.frame.size.height;
    
    CGFloat x = (type == TypeSomeoneElse) ? 0 : self.frame.size.width - width - self.chatMessage.insets.left - self.chatMessage.insets.right;
    CGFloat y = 0;
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarImage removeFromSuperview];
        self.avatarImage = [[UIImageView alloc] initWithImage:(self.chatMessage.avatar ? self.chatMessage.avatar : [UIImage imageNamed:@"missingAvatar.png"])];
        self.avatarImage.layer.cornerRadius = 9.0;
        self.avatarImage.layer.masksToBounds = YES;
        self.avatarImage.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        self.avatarImage.layer.borderWidth = 1.0;
        
        CGFloat avatarX = (type == TypeSomeoneElse) ? 2 : self.frame.size.width - 52;
        CGFloat avatarY = self.frame.size.height - 50;
        
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50);
        [self addSubview:self.avatarImage];
        
        CGFloat delta = self.frame.size.height - (self.chatMessage.insets.top + self.chatMessage.insets.bottom + self.chatMessage.view.frame.size.height);
        if (delta > 0) y = delta;
        
        if (type == TypeSomeoneElse) x += 54;
        if (type == TypeMine) x -= 54;
    }
    
    [self.customView removeFromSuperview];
    self.customView = self.chatMessage.view;
    self.customView.frame = CGRectMake(x + self.chatMessage.insets.left, y + self.chatMessage.insets.top, width, height);
    [self.contentView addSubview:self.customView];
    
    if (type == TypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
    }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleMine.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:14];
    }
    
    self.bubbleImage.frame = CGRectMake(x, y, width + self.chatMessage.insets.left + self.chatMessage.insets.right, height + self.chatMessage.insets.top + self.chatMessage.insets.bottom);
}

@end
