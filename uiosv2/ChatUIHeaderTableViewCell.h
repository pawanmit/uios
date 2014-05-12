//
//  ChatUIHeaderTableViewCell.h
//  UmanlyChatUI
//
//  Created by Mittal, Pawan on 5/9/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatUIHeaderTableViewCell : UITableViewCell

+ (CGFloat)height;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, retain) UILabel *label;

@end
