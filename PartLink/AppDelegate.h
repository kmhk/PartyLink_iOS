//
//  AppDelegate.h
//  PartLink
//
//  Created by RB on 8/1/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FBSession.h>

@class RSNetworkClient;
@class LoginViewController;

#define SPONSORURL @"http://www.partylinkevents.com/advertisers.html"

#define SENDISON @"sendNotification"
#define RECEIVEISON @"receiveNotification"
#define MINICOUNTER @"minimumCounter"
#define PHONEGPS @"phonegpsIsChecked"
#define CURRENTCITY @"currentcityIsChecked"

#define LOGINSTATE @"LoginState"

#define DELEGATE (AppDelegate *)[[UIApplication sharedApplication]delegate]

@class ADObject;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    UINavigationController *navController;
    BOOL isStart;
    BOOL isInBackground;
    UIBackgroundTaskIdentifier						_bgTask;
    
    NSDate *prevDate;
    NSTimer *locationTimer;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *viewController;

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) ADObject   *adInfo;
@property (strong, nonatomic) NSString   *cityName;
@property (strong, nonatomic) NSString   *state;
@property (strong, nonatomic) NSString   *countryName;
@property (strong, nonatomic) NSString   *currentAddress;
@property (strong, nonatomic) NSMutableArray *fbFriends;
@property (strong, nonatomic) NSString          *deviceToken;
@property (strong, nonatomic) NSString          *facebookID;
@property (strong, nonatomic) NSString          *facebookAccessToken;

@property (strong, nonatomic) RSNetworkClient   *likeClient;

- (void)openBrowserWithSponsorUrl;
- (void)reloadADInformation;
- (void)loadFacebookLikeView:(NSString *)fblink;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void) foundFBSession;

@end
