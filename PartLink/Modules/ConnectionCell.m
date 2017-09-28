//
//  ConnectionCell.m
//  Millania
//
//  Created by RB on 6/29/14.
//  Copyright (c) 2014 Meng Hu. All rights reserved.
//

#import "ConnectionCell.h"
#import "AsyncImageView.h"

@implementation ConnectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.isSelected = NO;
        self.user = nil;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
}

@end
