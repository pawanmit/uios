//
//  UIBubbleTableView.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <UIKit/UIKit.h>

#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleTableViewCell.h"

typedef enum bubbleTypingTypes
{
    NSBubbleTypingTypeNobody,
    NSBubbleTypingTypeMe,
    NSBubbleTypingTypeSomebody
} NSBubbleTypingType;

@interface UIBubbleTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property IBOutlet id<UIBubbleTableViewDataSource> bubbleDataSource;
@property NSTimeInterval snapInterval;
@property NSBubbleTypingType *typingBubble;
@property BOOL showAvatars;

- (void) scrollBubbleViewToBottomAnimated:(BOOL)animated;

@end
