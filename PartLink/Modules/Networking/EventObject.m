//
//  ContinetObject.m
//  Geocery
//
//  Created by RB on 4/8/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import "EventObject.h"

@implementation EventObject

- (id)init {
    self.placeID = nil;
    self.placeName = nil;
    self.location = nil;
    self.aboutPlace = @"";
    
    self.venderEmail = nil;
    self.venderID = nil;
    self.venderName = nil;
    self.isLiked = YES;
    
    self.photos = [NSMutableArray array];
    self.likedUsers = [NSMutableArray array];
    
    self.latitude = 0;
    self.longitude = 0;
    self.distance = 0;

    return self;
}

@end
