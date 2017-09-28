//
//  ConnectionCell.h
//  Millania
//
//  Created by RB on 6/29/14.
//  Copyright (c) 2014 Meng Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageView;

@interface ConnectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet AsyncImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *readStateView;

@property (strong, nonatomic) NSDictionary *user;
@property (strong, nonatomic) NSString     *uName;

@property BOOL isSelected;

@end
