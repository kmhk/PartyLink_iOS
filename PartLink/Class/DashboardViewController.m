//
//  DashboardViewController.m
//  PartLink
//
//  Created by RB on 8/1/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import "DashboardViewController.h"
#import "TonightPartyViewController.h"
#import "SettingsViewController.h"
#import "GrowViewController.h"
#import "NSString+SBJSON.h"
#import "AppDelegate.h"

//#import <FacebookSDK/FacebookSDK.h>

@interface DashboardViewController ()

@end

@implementation DashboardViewController

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
    
    [DELEGATE reloadADInformation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getADInformation {
    CLLocation *currentLocation = [DELEGATE currentLocation];
    if(currentLocation) {
        NSLog(@"Currentloaction : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        
        NSDateFormatter *formatter;
        NSString        *dateString;

        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        dateString = [formatter stringFromDate:[NSDate date]];
        NSLog(@"Current Time = %@", dateString);

        NSString *url = [NSString stringWithFormat:@"http://ipartypal.com/api/trunk/mobile/ad?latitude=%f&longitude=%f&facebookID=%@&date=%@", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, [DELEGATE facebookID], dateString];
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

        NSMutableDictionary *adDictionary = [self postGetMethod:url];
        
        if(adDictionary == nil) {
            return;
        }
        
        NSLog(@"Dictionanry = %@", adDictionary);
        
        NSString *adTypeString = [adDictionary objectForKey:@"ad_type"];
        ADType adType;
        if([adTypeString isEqualToString:@"nationwide"]) {
            adType = ADNANTIONWIDE;
        } else if([adTypeString isEqualToString:@"defaultad"]) {
            adType = ADDEFAULT;
        } else if([adTypeString isEqualToString:@"advertiser"]) {
            adType = ADVERTISER;
        } else {
            adType = ADNONE;
        }

        ADObject *adObject = [[ADObject alloc] init];
        NSString *SERVERURL = @"http://ipartypal.com";
        NSString *fbLink = @"https://www.facebook.com/partylinkapp";
        adObject.adType = adType;
        if(adType == ADDEFAULT) {
            adObject.adName = [adDictionary objectForKey:@"name"];
            adObject.adAddress = [adDictionary objectForKey:@"address"];
            adObject.blastOfferImagePath = [adDictionary objectForKey:@"blast_image"];
            adObject.description = [adDictionary objectForKey:@"description"];
            adObject.partyStartHour = [adDictionary objectForKey:@"party_start_hour"];
            adObject.partyStartPeriod = [adDictionary objectForKey:@"party_start_period"];
            adObject.partyEndHour = [adDictionary objectForKey:@"party_end_hour"];
            adObject.partyEndPeriod = [adDictionary objectForKey:@"party_end_period"];
        } else if(adType == ADNANTIONWIDE) {
            adObject.adDefaultImagePath = [NSString stringWithFormat:@"%@%@", SERVERURL, [adDictionary objectForKey:@"default_image"]];
            adObject.adDefaultLink = [adDictionary objectForKey:@"default_link"];
            adObject.adPaidImagePath = [NSString stringWithFormat:@"%@%@", SERVERURL, [adDictionary objectForKey:@"paid_image"]];
            adObject.adPaidLink = [adDictionary objectForKey:@"paid_link"];
        } else if(adType == ADVERTISER) {
            adObject.adName = [adDictionary objectForKey:@"name"];
            adObject.adAddress = [adDictionary objectForKey:@"address"];
            adObject.blastOfferImagePath = [adDictionary objectForKey:@"blast_image"];
            adObject.blastStartHour = [adDictionary objectForKey:@"blast_start_hour"];
            adObject.blastStartPeriod = [adDictionary objectForKey:@"blast_start_period"];
            adObject.blastEndHour = [adDictionary objectForKey:@"blast_end_hour"];
            adObject.blastEndPeriod = [adDictionary objectForKey:@"blast_end_period"];
            adObject.description = [adDictionary objectForKey:@"description"];
            adObject.facebookLink = [adDictionary objectForKey:@"facebook_page"];
            adObject.partyStartHour = [adDictionary objectForKey:@"party_start_hour"];
            adObject.partyStartPeriod = [adDictionary objectForKey:@"party_start_period"];
            adObject.partyEndHour = [adDictionary objectForKey:@"party_end_hour"];
            adObject.partyEndPeriod = [adDictionary objectForKey:@"party_end_period"];
            adObject.streetAddress = [adDictionary objectForKey:@"street_address"];
            adObject.zipcode = [adDictionary objectForKey:@"zip_code"];
            adObject.city = [adDictionary objectForKey:@"city"];
            adObject.state = [adDictionary objectForKey:@"state"];
            fbLink = adObject.facebookLink;
        }
        
        [DELEGATE setAdInfo:adObject];
        
        NSString *registerDT = [NSString stringWithFormat:@"http://ipartypal.com/api/trunk/user/setapntoken?facebookID=%@&deviceToken=%@", [DELEGATE facebookID], [DELEGATE deviceToken]];
        NSMutableDictionary *registerDTResponse = [self postGetMethod:registerDT];
        if(registerDTResponse == nil) {
            NSLog(@"Register Device token failed");
        }
        
        NSString *getSettingInfo = [NSString stringWithFormat:@"http://ipartypal.com/api/trunk/user/getsetting?facebookID=%@", [DELEGATE facebookID]];
        NSMutableDictionary *getSettingInfoResponse = [self postGetMethod:getSettingInfo];
        if(getSettingInfoResponse == nil) {
            NSLog(@"SettingInfo is null");
        }
        NSLog(@"Get settinginfo Response : %@", getSettingInfo);
    } else {
        ADObject *adObject = [[ADObject alloc] init];
        [DELEGATE setAdInfo:adObject];
    }
    
//    if([DELEGATE adInfo].adType == ADVERTISER) {
//
//        NSDateFormatter *formatter;
//        NSString        *dateString;
//        
//        formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        
//        dateString = [formatter stringFromDate:[NSDate date]];
//        NSLog(@"Current Time = %@", dateString);
        
//        NSString *registerDT = [NSString stringWithFormat:@"http://ipartypal.com/api/trunk/user/getblastimage?facebookID=%@&date=%@", [DELEGATE facebookID], dateString];
//        registerDT = [registerDT stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//        
//        NSMutableDictionary *registerDTResponse = [self postGetMethod:registerDT];
//        if(registerDTResponse == nil) {
//            NSLog(@"Register Device token failed");
//        } else {
//            if([registerDTResponse objectForKey:@"image"]) {
//                NSString *imagePath = [registerDTResponse objectForKey:@"image"];
//                if(imagePath.length > 0) {
//                    [DELEGATE adInfo].blastOfferImagePath = imagePath;
//                } else {
//                    [DELEGATE adInfo].blastOfferImagePath = nil;
//                }
//            } else {
//                [DELEGATE adInfo].blastOfferImagePath = nil;
//            }
//        }
//        NSLog(@"Device Token Response : %@", registerDTResponse);
 //   }
    
}

- (NSMutableDictionary *)postGetMethod:(NSString *)url {
    
    NSMutableURLRequest *loginRequest = [[NSMutableURLRequest alloc] init];
    [loginRequest setHTTPMethod:@"GET"];
    [loginRequest setURL:[NSURL URLWithString:url]];
    
    NSError *loginError = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *loginurlData = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&responseCode error:&loginError];
    NSString *responseString = [[NSString alloc] initWithData:loginurlData encoding:NSUTF8StringEncoding];
    
    if([responseCode statusCode] != 200) {
        return nil;
    }
    
    return [responseString JSONValue];
}


- (IBAction)onTonightParty:(id)sender {
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized || [DELEGATE currentLocation] == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"PartyLink requires device location to be turned on to use this feature." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [self getADInformation];
    
    TonightPartyViewController *tonightView;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            tonightView = [[TonightPartyViewController alloc] initWithNibName:@"TonightPartyViewController" bundle:nil];
        }
        else
        {
            tonightView = [[TonightPartyViewController alloc] initWithNibName:@"TonightPartyViewController_4s" bundle:nil];
        }
    }
    [self.navigationController pushViewController:tonightView animated:YES];

}

- (IBAction)onHotEvents:(id)sender {
    NSURL *url = [[NSURL alloc] initWithString:@"http://partylinkevents.com"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)onGrowParty:(id)sender {
    GrowViewController *growView;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            growView = [[GrowViewController alloc] initWithNibName:@"GrowViewController" bundle:nil];
        }
        else
        {
            growView = [[GrowViewController alloc] initWithNibName:@"GrowViewController_4s" bundle:nil];
        }
    }
    [self.navigationController pushViewController:growView animated:YES];
}

- (IBAction)onSettins:(id)sender {
    SettingsViewController *settingView = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:settingView animated:YES];
}

- (IBAction)onSponsor:(id)sender {
    [DELEGATE openBrowserWithSponsorUrl];
}

@end
