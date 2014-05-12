//
//  ChatViewDataSource.m
//  UmanlyChatUI
//
//  Created by Mittal, Pawan on 5/8/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "ChatUIDataSource.h"

@implementation ChatUIDataSource

+ (id)sharedChatUIDataSource {
    static ChatUIDataSource *chatUIDataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatUIDataSource = [[self alloc] init];
        chatUIDataSource.chatMessages = [[NSMutableArray alloc] initWithCapacity:1];
    });
    return chatUIDataSource;
}

-(void) addChatMessage:(ChatMessage *) chatMessage
{
    ChatUIDataSource *chatUIDataSource = [ChatUIDataSource sharedChatUIDataSource];
    [chatUIDataSource.chatMessages addObject:chatMessage];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatUIDataSource *chatUIDataSource = [ChatUIDataSource sharedChatUIDataSource];
    if (indexPath.section >= [chatUIDataSource.chatSections count])
    {
        
    }
    // Header with date and time
    if (indexPath.row == 0)
    {
        static NSString *cellId = @"tblBubbleHeaderCell";
        ChatUIHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        ChatMessage *message = [[chatUIDataSource.chatSections objectAtIndex:indexPath.section] objectAtIndex:0];
        if (cell == nil) cell = [[ChatUIHeaderTableViewCell alloc] init];
        cell.date = message.timeStamp;
        
        return cell;
    }
    
    // Standard bubble
    static NSString *cellId = @"tblBubbleCell";
    ChatUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    ChatMessage *message = [[chatUIDataSource.chatSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    
    if (cell == nil) cell = [[ChatUITableViewCell alloc] init];
    
    cell.chatMessage = message;
    cell.showAvatar = NO;
    
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    ChatUIDataSource *chatUIDataSource = [ChatUIDataSource sharedChatUIDataSource];
    int result = [chatUIDataSource.chatSections count];
    return result;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ChatUIDataSource *chatUIDataSource = [ChatUIDataSource sharedChatUIDataSource];
    if (section >= [chatUIDataSource.chatMessages count]) return 1;
    return [[chatUIDataSource.chatSections objectAtIndex:section] count] + 1;
}

-(NSInteger) rowsCountForMessageTable
{
    ChatUIDataSource *chatUIDataSource = [ChatUIDataSource sharedChatUIDataSource];
    return [chatUIDataSource.chatMessages count];
}

-(ChatMessage *) getMessageAtRow:(NSInteger *) row
{
    ChatUIDataSource *chatUIDataSource = [ChatUIDataSource sharedChatUIDataSource];
    return [chatUIDataSource.chatMessages objectAtIndex:row];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Header
    if (indexPath.row == 0)
    {
        return [ChatUIHeaderTableViewCell height];
    }
    ChatUIDataSource *chatUIDataSource = [ChatUIDataSource sharedChatUIDataSource];
    ChatMessage *message = [[chatUIDataSource.chatMessages objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    return MAX(message.insets.top + message.view.frame.size.height + message.insets.bottom, NO ? 52 : 0);
}

@end
