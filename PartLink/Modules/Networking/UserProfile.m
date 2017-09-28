//
//  ContinetObject.m
//  Geocery
//
//  Created by RB on 4/8/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

- (id)init {
    self.userEmail = nil;
    self.userID = nil;
    self.userName = nil;
    self.firstName = @"";
    self.lastName = @"";
    self.isMen = YES;
    self.isLiked = YES;
    self.likeMe = NO;
    
    self.photos = [NSMutableArray array];
    self.flames = [NSMutableArray array];
    self.friends = [NSMutableArray array];
    self.likedUsers = [NSMutableArray array];
    self.likedMeUsers = [NSMutableArray array];
    self.nearyByPeoples = [NSMutableArray array];
    
    self.connectionCounter = 0;
    self.flag = 0;
    return self;
}

@end
