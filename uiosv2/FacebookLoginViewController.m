//
//  FacebookLoginViewController.m
//  uiosv2
//
//  Created by Mittal, Pawan on 3/21/14.
//  Copyright (c) 2014 umanly. All rights reserved.
//

#import "FacebookLoginViewController.h"
#import "DisplayUsersOnMapViewController.h"

@interface FacebookLoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;

@end

@implementation FacebookLoginViewController

- (void)viewDidLoad
{
    UIImage *background = [UIImage imageNamed: @"Umanly_app_background_320x480.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view addSubview: imageView];
    
    [self setupFbLoginViewToUIView];
    
    [super viewDidLoad];
    NSLog(@"viewDidLoad");

    self.objectID= nil;
    
}

-(void) setupFbLoginViewToUIView
{
    FBLoginView *loginView = [[FBLoginView alloc] init];
    [self.view addSubview:loginView];
    
    
    // TODO: Update FB Login view with custome image
    [self updateFbLoginView:loginView];
    
    // Ask for basic permissions on login
    [loginView setReadPermissions:@[@"basic_info", @"birthday"]];
    [loginView setDelegate:self];
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"User logged in");
    [self requestUserInfo];
}

-(void) updateFbLoginView:(FBLoginView *)loginView
{
    loginView.frame = CGRectMake(10, 330, 300, 46);
    for (id obj in loginView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *facebookLoginViewImage = [UIImage imageNamed: @"Umanly_app_Facebook_300x46.png"];
            [loginButton setBackgroundImage:facebookLoginViewImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            loginLabel.textAlignment = UITextAlignmentCenter;
            loginLabel.frame = CGRectMake(10, 330, 300, 46);
        }
    }
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"User logged out");
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (NSString*)requestUserInfo
{
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"basic_info", @"email"];
    __block NSString *output;
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // These are the current permissions the user has
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted, we can request the user information
                                               [self makeRequestForUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               NSLog([NSString stringWithFormat:@"error %@", error.description]);
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog([NSString stringWithFormat:@"error %@", error.description]);
                              }
                          }];
    return output;
}

- (void) makeRequestForUserData
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            //NSLog([NSString stringWithFormat:@"user info: %@", result]);
            User *user = [[User alloc] init];
            user.birthday = [result objectForKey:@"birthday"];
            user.firstName = [result objectForKey:@"first_name"];
            user.lastName = [result objectForKey:@"last_name"];
            user.email = [result objectForKey:@"email"];
            user.gender = [result objectForKey:@"gender"];
            user.hometown = [[result objectForKey:@"hometown"] objectForKey:@"name"];
            user.facebookProfileLink = [result objectForKey:@"link"];
            user.facebookUsername = [result objectForKey:@"username"];
            //user.employer = [[[result objectForKey:@"work"] objectForKey:@"employer"] objectForKey:@"name"] ;

            [self.umanlyClientDelegate saveOrUpdateUser:user
                                    withSuccessHandler:^(){
                                        self.user = self.umanlyClientDelegate.user;
                                        NSLog(@"User retrived with id %@ and availability %i", self.user.userId, self.user.isAvailable );
                                    [self performSegueWithIdentifier:@"segueToMapView" sender:self];
                                 }
                                withFailureHandler:^(){
                                    [self.viewUtility showAlertMessage:@"Error connecting to umanly. Please try later."
                                                                 withTitle:@"Umanly Connection Error"];
                                }];
            //[umanlyClientDelegate getUsers];
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog([NSString stringWithFormat:@"error %@", error.description]);
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToMapView"])
    {
        DisplayUsersOnMapViewController *nextVC = [segue destinationViewController];
        nextVC.user = self.user;
        nextVC.sourceView = @"FacebookLoginView";
    }

}

@end
