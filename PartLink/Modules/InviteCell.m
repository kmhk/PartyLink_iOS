//
//  InviteCell.m
//  Millania
//
//  Created by RB on 6/30/14.
//  Copyright (c) 2014 Meng Hu. All rights reserved.
//

#import "InviteCell.h"

@implementation InviteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onInviteButton:(id)sender {
    [self.delegate sendEmail:self.emailAddress];
}
@end
