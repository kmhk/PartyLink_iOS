//
//  GrowViewController.m
//  PartLink
//
//  Created by RB on 8/1/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import "GrowViewController.h"
#import "AppDelegate.h"
#import "SBJsonWriter.h"

#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface GrowViewController () <MFMessageComposeViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, FBFriendPickerDelegate> {
    FBFriendPickerViewController *friendPickerController;
}

@end

@implementation GrowViewController

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
    // Do any additional setup after loading the view from its nib.
    self.fbView.layer.masksToBounds = YES;
    self.contactView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (void)sendRequest {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:@{
                                             @"social_karma": @"5",
                                             @"badge_of_awesomeness": @"1",
                                             @"user_message_prompt": @"Hey, Now we can have an epic party every night! Download the PartyLink app at http://www.ipartypal.com so that we can find the secret party for tonight and get $1 drinks all night!" }
                        options:0
                        error:&error];
    if (!jsonData) {
        NSLog(@"JSON error: %@", error);
        return;
    }
    
    NSString *giftStr = [[NSString alloc]
                         initWithData:jsonData
                         encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* params = [@{@"data" : giftStr} mutableCopy];
    
    // Display the requests dialog
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:@"Hey, Now we can have an epic party every night! Download the PartyLink app at http://www.ipartypal.com so that we can find the secret party for tonight and get $1 drinks all night!"
     title:nil
     parameters:params
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
             } else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 } else {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                 }
             }
         }
     }];
}

- (void)FBShare {
    if( NSClassFromString(@"SLComposeViewController") != nil){
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
        {
            SLComposeViewController *mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            
            [mySLComposerSheet setInitialText:@"Hey, Now we can have an epic party every night! Download the PartyLink app at http://www.ipartypal.com so that we can find the secret party for tonight and get $1 drinks all night!"]; //the message you want to post
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                NSString *output;
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        // The cancel button was tapped.
                        output = @"Facebook cancelled.";
                        break;
                    case SLComposeViewControllerResultDone:
                        // The tweet was sent.
                        output = @"Facebook done.";
                        break;
                    default:
                        break;
                }
                // Dismiss the tweet composition view controller.
                [self dismissModalViewControllerAnimated:YES];
            }];
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
    }
}

- (void)sendSmsInvite:(NSString *)contact {
    
    MFMessageComposeViewController *MsgComposer = [[MFMessageComposeViewController alloc] init];
#if 0
    MsgComposer.recipients = @[contact];
#endif
    if([MFMessageComposeViewController canSendText])
    {
        MsgComposer.messageComposeDelegate = self;
        MsgComposer.toolbarHidden= YES;
        MsgComposer.body = @"Hey, Now we can have an epic party every night! Download the PartyLink app at http://www.ipartypal.com so that we can find the secret party for tonight and get $1 drinks all night!";
        
        [self presentModalViewController:MsgComposer animated:YES];
    } else {
        
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Application" message:@"Unknown Error"
														   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			break;}
		case MessageComposeResultSent:
			
			break;
		default:
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender {
}

- (IBAction)onFacebookInvite:(id)sender {
    [self sendRequest];
}

-(void)showFriendsList
{
    friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    friendPickerController.delegate = self;
    [friendPickerController loadData];
}

- (IBAction)onContactInvite:(id)sender {

#if 1
    [self sendSmsInvite:@"contact"];
#else
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init ];
    picker.peoplePickerDelegate = self;
    picker.addressBook = ABAddressBookCreate();
    [self presentViewController:picker animated:YES completion:^{
        
    }];
#endif
}

- (IBAction)onSponsor:(id)sender {
    [DELEGATE openBrowserWithSponsorUrl];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef phones = (ABMultiValueRef)ABRecordCopyValue(person, property);
    NSString* mobile=@"";
    NSString* mobileLabel;
    for (int i=0; i < ABMultiValueGetCount(phones); i++) {
        //NSString *phone = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        //NSLog(@"%@", phone);
        mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
        if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
            NSLog(@"mobile:");
        } else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel]) {
            NSLog(@"iphone:");
        } else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhonePagerLabel]) {
            NSLog(@"pager:");
        }

        mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
        NSLog(@"%@", mobile);
    }
    
    NSLog(@"Name = %@, Value = %@, Mobile Number = %@", mobile, phones, mobile);
    
    if(property == 3) {
        [peoplePicker dismissViewControllerAnimated:YES completion:^{
            [self sendSmsInvite:mobile];
        }];
    } else {
        [peoplePicker dismissViewControllerAnimated:YES completion:^{
        }];
    }
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
