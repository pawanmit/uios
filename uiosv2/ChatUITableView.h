//
//  ChatUITableView.h
//  UmanlyChatUI
//
//  Created by Mittal, Pawan on 5/9/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatUIDataSource.h"

@interface ChatUITableView : UITableView <UITableViewDelegate>

@property ChatUIDataSource *chatUIDataSource;
@property (nonatomic) NSTimeInterval snapInterval;

@end
