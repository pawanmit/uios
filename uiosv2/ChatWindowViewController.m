//
//  ChatMessagingViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 5/1/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "ChatWindowViewController.h"
#import "NSBubbleData.h"
#import "UIBubbleTableView.h"

@interface ChatWindowViewController ()
@property (strong, nonatomic) IBOutlet UIBubbleTableView *bubbleTable;
@property (weak, nonatomic) IBOutlet UITextView *myChatMessage;
@property (weak, nonatomic) IBOutlet UIButton *sendChatMessageButton;

@end

@implementation ChatWindowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.bubbleData = [[NSMutableArray alloc] init];
    self.bubbleTable.bubbleDataSource = self;
    self.bubbleTable.snapInterval = 120;
    self.bubbleTable.showAvatars = NO;
    self.bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    [self.bubbleTable reloadData];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendMessage:(id)sender {
    self.bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:self.myChatMessage.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    [self.bubbleData addObject:sayBubble];
    [self.bubbleTable reloadData];
    
    self.myChatMessage.text = @"";
    [self.myChatMessage resignFirstResponder];
}

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [self.bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [self.bubbleData objectAtIndex:row];
}

//- (void)keyboardWasShown:(NSNotification*)aNotification
//{
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    [UIView animateWithDuration:0.2f animations:^{
//        
//        CGRect frame = self.myChatMessage.frame;
//        frame.origin.y -= kbSize.height;
//        self.myChatMessage.frame = frame;
//        
//        frame = self.bubbleTable.frame;
//        frame.size.height -= kbSize.height;
//        self.bubbleTable.frame = frame;
//    }];
//}
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    [UIView animateWithDuration:0.2f animations:^{
//        
//        CGRect frame = self.myChatMessage.frame;
//        frame.origin.y += kbSize.height;
//        self.myChatMessage.frame = frame;
//        
//        frame = self.bubbleTable.frame;
//        frame.size.height += kbSize.height;
//        self.bubbleTable.frame = frame;
//    }];
//}

@end
