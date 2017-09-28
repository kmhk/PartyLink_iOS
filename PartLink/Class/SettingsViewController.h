//
//  SettingsViewController.h
//  PartLink
//
//  Created by RB on 8/1/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
    BOOL sendIsOn;
    BOOL receiveIsOn;
    BOOL isPhoneChecked, isCityChecked;
    int  miniCounter, increaseState;
    
    float firstX, firstY;
    UISwipeGestureRecognizer *sendSwipeToLeft, *sendSwipeToRight, *receiveSwipeToLeft, *receiveSwipeToRight;
    UIPanGestureRecognizer *panRecognizer;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UIView *receiveView;
@property (weak, nonatomic) IBOutlet UIImageView *gpsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;
@property (weak, nonatomic) IBOutlet UIImageView *controlImage;
@property (weak, nonatomic) IBOutlet UIImageView *sendOnBg;
@property (weak, nonatomic) IBOutlet UIImageView *sendOffBg;
@property (weak, nonatomic) IBOutlet UIImageView *sendNobBg;
@property (weak, nonatomic) IBOutlet UIImageView *receiveOnBg;
@property (weak, nonatomic) IBOutlet UIImageView *receiveOffBg;
@property (weak, nonatomic) IBOutlet UIImageView *receiveNobBg;
@property (weak, nonatomic) IBOutlet UIView *miniView;
@property (weak, nonatomic) IBOutlet UILabel *miniCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onSponsor:(id)sender;
- (IBAction)onPhoneGPS:(id)sender;
- (IBAction)onCurrentCity:(id)sender;
- (IBAction)onCityName:(id)sender;

@end
