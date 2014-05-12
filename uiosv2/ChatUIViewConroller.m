//
//  ChatUIViewConrollerViewController.m
//  UmanlyChatUI
//
//  Created by Mittal, Pawan on 5/8/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "ChatUIViewConroller.h"
#import "ChatUITableView.h"
#import "ChatUIDataSource.h"

@interface ChatUIViewConroller ()

@property (weak, nonatomic) IBOutlet ChatUITableView *chatView;


@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *chatInputView;

@end

@implementation ChatUIViewConroller
{
    ChatUIDataSource *chatUIDataSource;
}

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
    chatUIDataSource = [ChatUIDataSource sharedChatUIDataSource];
    [self.chatView setDataSource:chatUIDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = self.chatInputView.frame;
        frame.origin.y -= kbSize.height;
        self.chatInputView.frame = frame;
        
        frame = self.chatView.frame;
        frame.size.height -= kbSize.height;
        self.chatView.frame = frame;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendChatMessage:(id)sender {
    NSLog(self.textField.text);
    ChatMessage *newChatMessage = [ChatMessage initWithText:self.textField.text date:[NSDate dateWithTimeIntervalSinceNow:-300]  type:TypeMine];
    [chatUIDataSource addChatMessage:newChatMessage];
    self.textField.text = @"";
    [self.chatView reloadData];
}

@end
