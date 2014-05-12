//
//  ChatUITableView.m
//  UmanlyChatUI
//
//  Created by Mittal, Pawan on 5/9/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "ChatUITableView.h"

@implementation ChatUITableView

- (void)initializator
{
    // UITableView properties
    
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    assert(self.style == UITableViewStylePlain);
    
    self.delegate = self;
    ChatUIDataSource *chatUIDataSource = [ChatUIDataSource sharedChatUIDataSource];
    self.chatUIDataSource = chatUIDataSource;
    
    // UIBubbleTableView default properties
    
    self.snapInterval = 120;
}

- (void)reloadData
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    // Cleaning up
	self.chatUIDataSource.chatSections = nil;
    
    // Loading new data
    int count = 0;

    self.chatUIDataSource.chatSections = [[NSMutableArray alloc] init];
    
    if (self.chatUIDataSource && (count = [self.chatUIDataSource rowsCountForMessageTable]) > 0)
    {

        NSMutableArray *chatData = [[NSMutableArray alloc] initWithCapacity:count];
        
        for (int i = 0; i < count; i++)
        {
            NSObject *object = [self.chatUIDataSource getMessageAtRow:i];
            assert([object isKindOfClass:[ChatMessage class]]);
            [chatData addObject:object];
        }
        
        [chatData sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             ChatMessage *message1 = (ChatMessage *)obj1;
             ChatMessage *message2 = (ChatMessage *)obj2;
             
             return [message1.timeStamp compare:message2.timeStamp];
         }];
        
        NSDate *last = [NSDate dateWithTimeIntervalSince1970:0];
        NSMutableArray *currentSection = nil;
        
        for (int i = 0; i < count; i++)
        {
            ChatMessage *message = (ChatMessage *)[chatData objectAtIndex:i];
            
            if ([message.timeStamp timeIntervalSinceDate:last] > self.snapInterval)
            {
                currentSection = [[NSMutableArray alloc] init];
                [self.chatUIDataSource.chatSections addObject:currentSection];
            }
            
            [currentSection addObject:message];
            last = message.timeStamp;
        }
    }
    
    [super reloadData];
}

- (id)init
{
    self = [super init];
    if (self) [self initializator];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) [self initializator];
    return self;
}


@end
