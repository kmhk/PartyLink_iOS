//
//  GrowViewController.h
//  PartLink
//
//  Created by RB on 8/1/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrowViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UIView *fbView;
@property (weak, nonatomic) IBOutlet UIView *contactView;

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onFacebookInvite:(id)sender;
- (IBAction)onContactInvite:(id)sender;
- (IBAction)onSponsor:(id)sender;

@end
