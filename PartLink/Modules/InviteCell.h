//
//  InviteCell.h
//  Millania
//
//  Created by RB on 6/30/14.
//  Copyright (c) 2014 Meng Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageView;

@protocol InviteCell_delegate <NSObject>

- (void)sendEmail:(NSString *)email;

@end

@interface InviteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet AsyncImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@property (strong, nonatomic) NSString *emailAddress;

@property (assign, nonatomic) id<InviteCell_delegate> delegate;

- (IBAction)onInviteButton:(id)sender;
@end
