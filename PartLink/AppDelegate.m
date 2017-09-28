//
//  AppDelegate.m
//  PartLink
//
//  Created by RB on 8/1/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+SBJSON.h"
#import "ADObject.h"
#import "LoginViewController.h"
#import "SplashViewController.h"
#import "RSNetworkClient.h"
#import <AddressBook/AddressBook.h>
#import "Global.h"
#import <FacebookSDK/FBSession.h>
#import <FacebookSDK/FBError.h>
#import <FacebookSDK/FBAppCall.h>

#define SavedHTTPCookiesKey @"SavedHTTPCookies"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Restore cookies
    NSData *cookiesData = [[NSUserDefaults standardUserDefaults] objectForKey:SavedHTTPCookiesKey];
    if (cookiesData) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesData];
        for (NSHTTPCookie *cookie in cookies)
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
    //PUSH Notification
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.adInfo = [[ADObject alloc] init];
    self.facebookID = nil;
    
    //get location
    self.currentLocation = nil;
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = 3;
    [locationManager startUpdatingLocation];
    
    isStart = NO;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            self.viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        }
        else
        {
            self.viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController_4s" bundle:nil];
        }
    }
    navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [navController setNavigationBarHidden:YES];
    
#if 0
    navController = [[UINavigationController alloc] initWithRootViewController:self.window.rootViewController];
    [navController setNavigationBarHidden:YES];
    
    SplashViewController *splashView;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            splashView = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
        }
        else
        {
            splashView = [[SplashViewController alloc] initWithNibName:@"SplashViewController_4s" bundle:nil];
        }
    }
#endif
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    prevDate = [NSDate date];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // Save cookies
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    [[NSUserDefaults standardUserDefaults] setObject:cookiesData
                                              forKey:SavedHTTPCookiesKey];
    
    [self enterBackgroundMode];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
    [self leaveBackgroundMode];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}


//Push Notification
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Device Token=> %@",dt);
    
    [self setDeviceToken:dt];
}

- (void)enterBackgroundMode
{
	NSLog(@"enter background mode");
    isInBackground = YES;
    [self reloadADInformation];
    
    _bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
		
		//[[UIApplication sharedApplication] endBackgroundTask:_bgTask];
		[locationManager startMonitoringSignificantLocationChanges];
	}];
    
    [locationTimer invalidate];
    locationTimer = nil;
}

- (void)leaveBackgroundMode
{
	NSLog(@"leave from background mode");
    isInBackground = NO;
	[locationManager stopMonitoringSignificantLocationChanges];
    
    if(self.facebookID) [self reloadADInformation];
    if (_bgTask != UIBackgroundTaskInvalid) {
		[[UIApplication sharedApplication] endBackgroundTask:_bgTask];
		_bgTask = UIBackgroundTaskInvalid;
	}
    
    locationTimer = [NSTimer scheduledTimerWithTimeInterval:600
                                                     target:self
                                                   selector:@selector(reloadADInformation)
                                                   userInfo:nil
                                                    repeats:YES];
}

/* Get Location */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    self.currentLocation = newLocation;

    if(newLocation) {
        // Reverse Geocoding
        NSLog(@"Resolving the Address");
        [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            
            if (error == nil && [placemarks count] > 0) {
                
                NSString *placemarksStr = [NSString stringWithFormat:@"%@", placemarks];
                NSArray *a = [placemarksStr componentsSeparatedByString:@"@"];
                if(a.count > 0)
                    self.currentAddress = [a objectAtIndex:0];
                placemark = [placemarks lastObject];
                
                if(placemark.locality) {
                    self.cityName = placemark.locality;
                } else {
                    if(placemark.administrativeArea) {
                        self.cityName = placemark.administrativeArea;
                    } else {
                        self.cityName = placemark.subAdministrativeArea;
                    }
                }
                
                self.countryName = placemark.country;
                self.currentAddress = [NSString stringWithFormat:@"%@, %@, %@", placemark.subLocality, placemark.administrativeArea, self.countryName];
                
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
#if 0
        
        if(!isStart) {
            isStart = YES;
            if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
            {
                if ([[UIScreen mainScreen] bounds].size.height == 568)
                {
                    self.viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                }
                else
                {
                    self.viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController_4s" bundle:nil];
                }
            }
            [navController pushViewController:self.viewController animated:NO];
        }
#endif
    }
    
    if (isInBackground) {
		NSLog(@"tracking on background mode");
#if 0
        [self reloadADInformation];
#else
        if ([[NSDate date] timeIntervalSinceDate:prevDate] >= 60) {
            prevDate = [NSDate date];
            [self reloadADInformation];
        }
#endif
	}
}

- (void)reloadADInformation {
    CLLocation *currentLocation = self.currentLocation;
    if(currentLocation) {
        
        prevDate = [NSDate date];
        
        NSLog(@"Currentloaction : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        
        NSString *url = [NSString stringWithFormat:@"http://ipartypal.com/api/trunk/user/updatelocation?facebookID=%@&latitude=%f&longitude=%f", self.facebookID, currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
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
            return;
        }
        
        NSMutableDictionary *adDictionary = [responseString JSONValue];
        NSLog(@"Dictionanry = %@", adDictionary);
        
//        NSString *testurl;
//        if(isInBackground) {
//            testurl = [NSString stringWithFormat:@"http://188.121.37.148/mobApi/uploadPlan.php?userID=4&countryID=1024&authToken=445999188865926-aSitauZE1OFwT-p4IwIbDiGoxfs&fromDate=InBackground : %f:%f&toDate=2014-09-12", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
//        } else {
//            testurl = [NSString stringWithFormat:@"http://188.121.37.148/mobApi/uploadPlan.php?userID=4&countryID=1024&authToken=445999188865926-aSitauZE1OFwT-p4IwIbDiGoxfs&fromDate=InForground : %f:%f&toDate=2014-09-12", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
//        }
//        
//        testurl = [testurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//        NSMutableURLRequest *testloginRequest = [[NSMutableURLRequest alloc] init];
//        [testloginRequest setHTTPMethod:@"GET"];
//        [testloginRequest setURL:[NSURL URLWithString:testurl]];
//        
//        NSError *testloginError = [[NSError alloc] init];
//        NSHTTPURLResponse *testresponseCode = nil;
//        
//        NSData *testloginurlData = [NSURLConnection sendSynchronousRequest:testloginRequest returningResponse:&testresponseCode error:&testloginError];
//        NSString *testresponseString = [[NSString alloc] initWithData:testloginurlData encoding:NSUTF8StringEncoding];
//        NSLog(@"Error getting %@, HTTP status code %i", testurl, [testresponseCode statusCode]);
//        NSLog(@"Response String = %@", testresponseString);
//        
//        if([testresponseCode statusCode] != 200) {
//            return;
//        }
//        
//        NSMutableDictionary *testadDictionary = [testresponseString JSONValue];
//        NSLog(@"Dictionanry = %@", testadDictionary);
    }
}

- (void)openBrowserWithSponsorUrl {
    NSURL *url = [[NSURL alloc] initWithString:SPONSORURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)loadFacebookLikeView:(NSString *)fblink {
    fblikeview = [[FBLikeView alloc] initWithFrame:CGRectMake(0, 0, 90, 35)];
    [fblikeview loadFacebookLikeView:fblink];
}

@end
