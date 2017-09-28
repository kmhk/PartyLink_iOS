//
//  SettingsViewController.m
//  PartLink
//
//  Created by RB on 8/1/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import "SettingsViewController.h"
#import "NSString+SBJSON.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    
    sendIsOn = [[NSUserDefaults standardUserDefaults] boolForKey:SENDISON];
    receiveIsOn = [[NSUserDefaults standardUserDefaults] boolForKey:RECEIVEISON];
    miniCounter = [[NSUserDefaults standardUserDefaults] integerForKey:MINICOUNTER];
    isPhoneChecked = [[NSUserDefaults standardUserDefaults] boolForKey:PHONEGPS];
    isCityChecked = [[NSUserDefaults standardUserDefaults] boolForKey:CURRENTCITY];
    
    if(sendIsOn) {
        self.sendOnBg.alpha = 1.0;
        self.sendOffBg.alpha = 0.0;
        [self.sendNobBg setCenter:CGPointMake(268, 25)];
    } else {
        self.sendOnBg.alpha = 0.0;
        self.sendOffBg.alpha = 1.0;
        [self.sendNobBg setCenter:CGPointMake(240, 25)];
    }
    
    if(receiveIsOn) {
        self.receiveOnBg.alpha = 1.0;
        self.receiveOffBg.alpha = 0.0;
        [self.receiveNobBg setCenter:CGPointMake(268, 25)];
    } else {
        self.receiveOnBg.alpha = 0.0;
        self.receiveOffBg.alpha = 1.0;
        [self.receiveNobBg setCenter:CGPointMake(240, 25)];
    }
    
    if(miniCounter < 2 || miniCounter > 10) {
        miniCounter = 2;
        
        [[NSUserDefaults standardUserDefaults] setInteger:miniCounter forKey:MINICOUNTER];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.miniCounterLabel setText:[NSString stringWithFormat:@"%i", miniCounter]];
    
    if(isPhoneChecked) {
        [self.gpsImageView setImage:[UIImage imageNamed:@"check_on.png"]];
    } else {
        [self.gpsImageView setImage:[UIImage imageNamed:@"check_off.png"]];
    }
    
    if(isCityChecked) {
        [self.cityImageView setImage:[UIImage imageNamed:@"check_on.png"]];
    } else {
        [self.cityImageView setImage:[UIImage imageNamed:@"check_off.png"]];
    }
    
//    [self.cityNameLabel setText:[DELEGATE cityName]];
    
    [self addGestures];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    increaseState = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(controlCounter)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addGestures {
    sendSwipeToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(sendSwipe:)];
    sendSwipeToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(sendSwipe:)];
    
    [sendSwipeToLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [sendSwipeToRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.sendNobBg addGestureRecognizer:sendSwipeToLeft];
    [self.sendNobBg addGestureRecognizer:sendSwipeToRight];
    
    receiveSwipeToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(receiveSwipe:)];
    receiveSwipeToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(receiveSwipe:)];
    
    [receiveSwipeToLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [receiveSwipeToRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.receiveNobBg addGestureRecognizer:receiveSwipeToLeft];
    [self.receiveNobBg addGestureRecognizer:receiveSwipeToRight];
    
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(controllImageTouchup:)];
    [self.controlImage addGestureRecognizer:panRecognizer];
}

- (void)sendSwipe:(UISwipeGestureRecognizer *)swipeGesture
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         if (sendIsOn) {
                             if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
                                 self.sendOnBg.alpha = 0.0;
                                 self.sendOffBg.alpha = 1.0;
                                 [self.sendNobBg setCenter:CGPointMake(240, 25.5)];
                                 sendIsOn = NO;
                             }
                         } else {
                             if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight) {
                                 self.sendOnBg.alpha = 1.0;
                                 self.sendOffBg.alpha = 0.0;
                                 [self.sendNobBg setCenter:CGPointMake(269, 25.5)];
                                 sendIsOn = YES;
                             }
                         }
                     }
                     completion:^(BOOL finished) {
                         [[NSUserDefaults standardUserDefaults] setBool:sendIsOn forKey:SENDISON];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                     }];
}

- (void)receiveSwipe:(UISwipeGestureRecognizer *)swipeGesture
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         if (receiveIsOn) {
                             if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
                                 self.receiveOnBg.alpha = 0.0;
                                 self.receiveOffBg.alpha = 1.0;
                                 [self.receiveNobBg setCenter:CGPointMake(240, 25.5)];
                                 receiveIsOn = NO;
                             }
                         } else {
                             if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight) {
                                 self.receiveOnBg.alpha = 1.0;
                                 self.receiveOffBg.alpha = 0.0;
                                 [self.receiveNobBg setCenter:CGPointMake(269, 25.5)];
                                 receiveIsOn = YES;
                             }
                         }
                     }
                     completion:^(BOOL finished) {
                         [[NSUserDefaults standardUserDefaults] setBool:receiveIsOn forKey:RECEIVEISON];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                     }];
}

#pragma UIPanGeustureRecorgnize
-(void)controllImageTouchup:(id)sender {
    
    increaseState = 0;
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.miniView];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
        
    } else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        
        if(translatedPoint.y > 0) {
            increaseState = 2;
        } else {
            increaseState = 1;
        }
        
    } else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        increaseState = 0;
    }
}

- (void)controlCounter {
    if(increaseState == 1) {
        if(miniCounter < 10)
            miniCounter++;
    } else if(increaseState == 2){
        if(miniCounter > 2)
            miniCounter--;
    } else {
        return;
    }
    
    [self.miniCounterLabel setText:[NSString stringWithFormat:@"%i", miniCounter]];
    [[NSUserDefaults standardUserDefaults] setInteger:miniCounter forKey:MINICOUNTER];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        return nil;
    }
    
    return [responseString JSONValue];
}

- (IBAction)onBack:(id)sender {
    NSString *sendParty = @"no";
    if(sendIsOn) sendParty = @"yes";
    
    NSString *receiveParty = @"no";
    if(receiveIsOn) receiveParty = @"yes";
    
    NSString *notificationGPS = @"no";
    if(isPhoneChecked) notificationGPS = @"yes";
    
    NSString *notificationCity = @"no";
    if(isCityChecked) notificationCity = @"yes";
    
    NSString *updateSettingInfoUrl = [NSString stringWithFormat:@"http://ipartypal.com/api/trunk/user/updatesetting?facebookID=%@&sendparty=%@&recvparty=%@&notifyongps=%@&notifyoncity=%@&preferredcity=%@&minnumber=%i", [DELEGATE facebookID] ,sendParty, receiveParty, notificationGPS, notificationCity, [DELEGATE cityName], miniCounter];
    updateSettingInfoUrl = [updateSettingInfoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *response = [self postGetMethod:updateSettingInfoUrl];
    if(response == nil) {
        NSLog(@"update setting failed");
    }
    NSLog(@"Update Response : %@", response);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender {
}

- (IBAction)onSponsor:(id)sender {
    [DELEGATE openBrowserWithSponsorUrl];
}

- (IBAction)onPhoneGPS:(id)sender {
    isPhoneChecked = !isPhoneChecked;
    if(isPhoneChecked) {
        [self.gpsImageView setImage:[UIImage imageNamed:@"check_on.png"]];
    } else {
        [self.gpsImageView setImage:[UIImage imageNamed:@"check_off.png"]];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:isPhoneChecked forKey:PHONEGPS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)onCurrentCity:(id)sender {
    isCityChecked = !isCityChecked;
    if(isCityChecked) {
        [self.cityImageView setImage:[UIImage imageNamed:@"check_on.png"]];
    } else {
        [self.cityImageView setImage:[UIImage imageNamed:@"check_off.png"]];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:isCityChecked forKey:CURRENTCITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)onCityName:(id)sender {
    [self.cityNameLabel setText:[DELEGATE cityName]];
}
@end
