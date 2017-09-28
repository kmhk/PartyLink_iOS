//
//  FBLikeView.m
//  PartyLink
//
//  Created by RB on 8/9/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import "FBLikeView.h"

@implementation FBLikeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.facebook = [[Facebook alloc] initWithAppId:@"551216998338753" andDelegate:self];
        [self setFblikeview:[[FacebookLikeView alloc] init]];
        [self.fblikeview setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.fblikeview];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)loadFacebookLikeView:(NSString *)fblink {
    self.fblikeview.href = [NSURL URLWithString:fblink];
    self.fblikeview.layout = @"button";
    self.fblikeview.showFaces = NO;
    self.fblikeview.alpha = 1;
    [self.fblikeview load];
}

#pragma mark FacebookLikeViewDelegate
- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {
    [self.facebook authorize:[NSArray array]];
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
//    [UIView beginAnimations:@"" context:nil];
//    [UIView setAnimationDelay:0.5];
//    self.fblikeview.alpha = 1;
//    [UIView commitAnimations];
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

@end
