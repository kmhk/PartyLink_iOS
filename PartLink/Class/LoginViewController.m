//
//  LoginViewController.m
//  PartLink
//
//  Created by RB on 8/2/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import "LoginViewController.h"
#import "RSLoadingView.h"
#import "DashboardViewController.h"
#import "AppDelegate.h"
#import "ADObject.h"
#import "NSString+SBJSON.h"

#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    
    loadingView = [[RSLoadingView alloc] init];
    [loadingView setFrame:self.view.bounds];
    [loadingView setAlpha:0];
    [loadingView.titleLabel setText:@"Logging in..."];
    [self.view addSubview:loadingView];
    

    NSString *loginState = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINSTATE];
    if((loginState != nil) && ([loginState isEqualToString:@"Success"])) {
            [self onLoginWithFacebook:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 ** get facebook account
 */
- (void)onFbLogin
{
    [loadingView setAlpha:1];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", @"user_friends", @"public_profile", nil];
    
    // If the session state is any of the two "open" states when the button is clicked
    NSLog(@"FBsession ActiveSession state =  %i", FBSession.activeSession.state);
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        [ FBRequestConnection startForMeWithCompletionHandler: ^( FBRequestConnection* _connection, id < FBGraphUser > _facebookUser, NSError* _error ) {
            if( _error )
            {
                // Hide ;
                [loadingView setAlpha:0];
                return;
            }
            
            NSString *accessToken = [[FBSession activeSession] accessToken];
            NSDate *expirationDate = [[FBSession activeSession] expirationDate];
            [DELEGATE setFacebookAccessToken:accessToken];
            
            NSString *fullName = [_facebookUser objectForKey:@"name"];
            NSString *email = [_facebookUser objectForKey:@"email"];
            NSString *birthDay = [_facebookUser objectForKey:@"birthday"];
            NSString *userID = [_facebookUser objectForKey:@"id"];
            
            [DELEGATE setFacebookID:userID];
            
            
            [loadingView setAlpha:1];
            if([DELEGATE cityName].length > 0) {
                
            } else {
                [DELEGATE setCityName:@"Unknown"];
            }
            
            if(birthDay.length > 0) {
                
            } else {
                birthDay = @"1990/01/01";
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
            [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:@"expirationDate"];
            [[NSUserDefaults standardUserDefaults] setObject:fullName forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"useremail"];
            [[NSUserDefaults standardUserDefaults] setObject:birthDay forKey:@"userbirthday"];
            [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self registerUserInfo:fullName :email :birthDay :userID :accessToken];
            
        } ] ;
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else if(FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
        NSString *fullName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"useremail"];
        NSString *birthDay = [[NSUserDefaults standardUserDefaults] objectForKey:@"userbirthday"];
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        
        [self registerUserInfo:fullName :email :birthDay :userID :accessToken];
        
    } else {
        [FBSession openActiveSessionWithPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          [self sessionStateChanged:session state:status error:error];
                                      }];
    }
}

- (void)registerUserInfo:(NSString *)fullName :(NSString *)email :(NSString *)birthDay :(NSString *)userID :(NSString *)accessToken {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ipartypal.com/api/trunk/user"]];
    // create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    
    //Pass The String to server
    NSString *userUpdate =[NSString stringWithFormat:@"name=%@&email=%@&city=%@&birth_date=%@&facebookID=%@&facebookToken=%@", fullName, email, [DELEGATE cityName], birthDay, userID, accessToken];
    userUpdate = [userUpdate stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //Check The Value what we passed
    NSLog(@"the data Details is = %@", userUpdate);
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"the data Details is = %@", data1);
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *resp = nil;
    resp = [NSJSONSerialization
            JSONObjectWithData:urlData
            
            options:kNilOptions
            error:&error];
    
    NSString *message = @"";
    if(error){
        NSLog(@"could not parse response %@",error);
    } else {
        NSLog(@"Response : %@", resp);
        
        if([resp objectForKey:@"error"]) {
            int error = [[resp objectForKey:@"error"] integerValue];
            BOOL isSuccess = NO;
            
            if(error == 0) {
                isSuccess = YES;
            } else {
                if([resp objectForKey:@"message"]) {
                    message = [resp objectForKey:@"message"];
                }
            }
        }
    }
    NSLog(@"Response of register User : %@", message);
    [loadingView setAlpha:0];
    [[NSUserDefaults standardUserDefaults] setObject:@"Success" forKey:LOGINSTATE];
    DashboardViewController *mainView = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
    [self.navigationController pushViewController:mainView animated:YES];
}

- (void)faceboookLogoutAction {
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)showError:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"Sorry"
                                message:message
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
        [loadingView setAlpha:0];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showError:alertText];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                [self showError:@"User cancelled login"];
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showError:alertText];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showError:alertText];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
        [loadingView setAlpha:0];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    NSLog(@"User logged out");
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    [self onFbLogin];
}

- (NSMutableDictionary *)postGetMethod:(NSString *)url {
    
    NSMutableURLRequest *loginRequest = [[NSMutableURLRequest alloc] init];
    [loginRequest setHTTPMethod:@"GET"];
    [loginRequest setURL:[NSURL URLWithString:url]];
    
    NSError *loginError = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *loginurlData = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&responseCode error:&loginError];
    NSString *responseString = [[NSString alloc] initWithData:loginurlData encoding:NSUTF8StringEncoding];
    NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
    NSLog(@"Response String = %@", responseString);
    
    if([responseCode statusCode] != 200) {
        [loadingView setAlpha:0];
        [self showError:responseString];
        return nil;
    }
    
    return [responseString JSONValue];
}

- (IBAction)onLoginWithFacebook:(id)sender {
    [loadingView setAlpha:1];
    [self performSelectorOnMainThread:@selector(onFbLogin) withObject:nil waitUntilDone:NO];
}


@end
