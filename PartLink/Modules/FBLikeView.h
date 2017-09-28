//
//  FBLikeView.h
//  PartyLink
//
//  Created by RB on 8/9/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FacebookLikeView.h"
#import "FBConnect.h"

@interface FBLikeView : UIView <FacebookLikeViewDelegate, FBSessionDelegate>

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) FacebookLikeView *fblikeview;

- (void)loadFacebookLikeView:(NSString *)fblink;

@end
