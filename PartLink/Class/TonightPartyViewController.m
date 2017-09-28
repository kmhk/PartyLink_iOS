//
//  TonightPartyViewController.m
//  PartLink
//
//  Created by RB on 8/1/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import "TonightPartyViewController.h"
#import "AsyncImageView.h"
#import "AppDelegate.h"
#import "FBConnect.h"
#import "FacebookLikeView.h"

@interface TonightPartyViewController () <FacebookLikeViewDelegate, FBSessionDelegate>

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) IBOutlet FacebookLikeView *facebookLikeView;

@end

@implementation TonightPartyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.facebook = [[Facebook alloc] initWithAppId:@"258974730962988" andDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.adImageView setBackgroundColor:[UIColor blackColor]];
    fbLink = @"https://www.facebook.com/partylinkapp";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideAllADView];
    
    adDic = [DELEGATE adInfo];
//    adDic.adType = ADDEFAULT;
    if(adDic.adType == ADNANTIONWIDE) {
        [self configureNationWideAD];
    } else if(adDic.adType == ADDEFAULT) {
        [self configureDefaultAD];
    } else if(adDic.adType == ADVERTISER){
        [self configureVertiserAD];
    } else {
        [self configureNoneAD];
    }
    
    NSLog(@"Facebook Link : %@", fbLink);
    self.facebookLikeView.href = [NSURL URLWithString:fbLink];
    self.facebookLikeView.layout = @"button_count";
    self.facebookLikeView.showFaces = NO;
    self.facebookLikeView.alpha = 1;
    [self.facebookLikeView load];
}

#pragma mark FacebookLikeViewDelegate
- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {
    [self.facebook authorize:[NSArray array]];
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    self.facebookLikeView.alpha = 1;
    [UIView commitAnimations];
}

- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked"
                                                    message:@"You liked PartyLink. Thanks!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unliked"
                                                    message:@"You unliked PartyLink. Where's the love?"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)hideAllADView {
    [self.defaultView setHidden:YES];
    [self.nationView setHidden:YES];
    [self.noneView setHidden:YES];
}

- (void)configureDefaultAD {
    [self.defaultView setHidden:NO];
    [self.logoImageView setHidden:NO];
    [self.blastHourView setHidden:YES];
    [self.defaultBlastImage loadImageFromURL:[NSURL URLWithString:adDic.blastOfferImagePath]];
    [self.titleLabel setText:[adDic.adName uppercaseString]];
    [self.addressLabel setText:adDic.adAddress];
    [self.descriptionLabel setText:adDic.description];
    [self.partyTimeLabel setText:[NSString stringWithFormat:@"Open from %@%@ to %@%@", adDic.partyStartHour, adDic.partyStartPeriod, adDic.partyEndHour, adDic.partyEndPeriod]];

}

- (void)configureNationWideAD {
    [self.nationView setHidden:NO];
    [self.titleLabel setText:@""];
    [self.adImageView loadImageFromURL:[NSURL URLWithString:adDic.adPaidImagePath]];
}

- (void)configureVertiserAD {
    
    [self.defaultView setHidden:NO];
    if(adDic.blastOfferImagePath.length == 0)
        [self.logoImageView setHidden:NO];
    else
        [self.logoImageView setHidden:YES];

    [self.blastHourView setHidden:NO];
    [self.titleLabel setText:[adDic.adName uppercaseString]];
    /*
    NSArray *priceArray = [adDic.blastOffer componentsSeparatedByString:@" "];
    NSString *price  = [priceArray objectAtIndex:0];
    
    NSString *productName = @"";
    for(int i = 1; i < priceArray.count; i++) {
        productName = [NSString stringWithFormat:@"%@ %@", productName, [priceArray objectAtIndex:i]];
    }*/
    
    if(adDic.blastOfferImagePath.length > 0)
        [self.offerImage loadImageFromURL:[NSURL URLWithString:adDic.blastOfferImagePath]];
    
//    [self.validLabel setText:[NSString stringWithFormat:@"%@ Special Valid", price]];
    if (adDic.blastStartHour == nil || adDic.blastStartPeriod == nil || adDic.blastEndHour == nil || adDic.blastEndPeriod == nil ||
        [adDic.blastStartHour isEqualToString:@""] || [adDic.blastStartPeriod isEqualToString:@""] || [adDic.blastEndHour isEqualToString:@""] || [adDic.blastEndPeriod isEqualToString:@""]) {
        [self.blastTimeLabel setText:@""];
        [self.partyTimeView setAlpha:1];
        [self.blastTimeView setAlpha:0];
    } else {
        [self.blastTimeLabel setText:[NSString stringWithFormat:@"%@%@ to %@%@", adDic.blastStartHour, adDic.blastStartPeriod, adDic.blastEndHour, adDic.blastEndPeriod]];
        [self.partyTimeView setAlpha:0];
        [self.blastTimeView setAlpha:1];
    }

    [self.descriptionLabel setText:adDic.description];
    [self.partyTimeLabel setText:[NSString stringWithFormat:@"Open from %@%@ to %@%@", adDic.partyStartHour, adDic.partyStartPeriod, adDic.partyEndHour, adDic.partyEndPeriod]];
    [self.partyTimeNoBlastLabel setText:[NSString stringWithFormat:@"Open from %@%@ to %@%@", adDic.partyStartHour, adDic.partyStartPeriod, adDic.partyEndHour, adDic.partyEndPeriod]];
    if (adDic.streetAddress == nil || adDic.city == nil || adDic.state == nil || adDic.zipcode == nil)
    {
        if (adDic.adAddress == nil)
            [self.addressLabel setText:@""];
        else
            [self.addressLabel setText:adDic.adAddress];
    }
    else
        [self.addressLabel setText:[NSString stringWithFormat:@"%@\n%@, %@ %@", adDic.streetAddress, adDic.city, adDic.state, adDic.zipcode]];
    
    fbLink = adDic.facebookLink;
}

- (void)configureNoneAD {
    [self.noneView setHidden:NO];
    [self.titleLabel setText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender {
}

- (IBAction)onLike:(id)sender {
    NSURL *url = [[NSURL alloc] initWithString:fbLink];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)onSendGPS:(id)sender {
    NSString* address;
    if(adDic.adType == ADDEFAULT) {
        address = adDic.adAddress;
    } else if(adDic.adType == ADNANTIONWIDE) {
        
    } else if(adDic.adType == ADVERTISER) {
        address = [NSString stringWithFormat:@"%@, %@, %@ %@", adDic.streetAddress, adDic.city, adDic.state, adDic.zipcode];
    }

    NSString* currentLocation = [DELEGATE currentAddress];
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%@", [DELEGATE currentLocation].coordinate.latitude, [DELEGATE currentLocation].coordinate.longitude, [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL: [NSURL URLWithString: url]];
}



- (IBAction)onSponsor:(id)sender {
    [DELEGATE openBrowserWithSponsorUrl];
}

- (IBAction)onPaidLink:(id)sender {
    NSURL *url = [[NSURL alloc] initWithString:adDic.adPaidLink];
    [[UIApplication sharedApplication] openURL:url];
}
@end
