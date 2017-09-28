//
//  LoginViewController.h
//  PartLink
//
//  Created by RB on 8/2/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSLoadingView;

@interface LoginViewController : UIViewController {
    RSLoadingView *loadingView;
}

- (IBAction)onLoginWithFacebook:(id)sender;

@end
