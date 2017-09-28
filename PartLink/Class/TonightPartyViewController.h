//
//  TonightPartyViewController.h
//  PartLink
//
//  Created by RB on 8/1/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADObject.h"

@class AsyncImageView;

@interface TonightPartyViewController : UIViewController {
    ADType adType;
    ADObject *adDic;
    
    NSString *fbLink;
}

@property (weak, nonatomic) IBOutlet UIView *fbview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *defaultView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet UIView *nationView;
@property (weak, nonatomic) IBOutlet AsyncImageView *adImageView;
@property (weak, nonatomic) IBOutlet AsyncImageView *offerImage;
@property (weak, nonatomic) IBOutlet UILabel *validLabel;
@property (weak, nonatomic) IBOutlet UILabel *blastTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *blastHourView;
@property (weak, nonatomic) IBOutlet UIView *blastTimeView;
@property (weak, nonatomic) IBOutlet UIView *partyTimeView;
@property (weak, nonatomic) IBOutlet UILabel *partyTimeNoBlastLabel;
@property (weak, nonatomic) IBOutlet AsyncImageView *defaultBlastImage;

@property (weak, nonatomic) IBOutlet UIWebView *likeWebview;
@property (weak, nonatomic) IBOutlet UIView *noneView;

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onLike:(id)sender;
- (IBAction)onSendGPS:(id)sender;
- (IBAction)onSponsor:(id)sender;
- (IBAction)onPaidLink:(id)sender;

@end
