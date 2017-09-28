//
//  ContinetObject.h
//  Geocery
//
//  Created by RB on 4/8/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceObject : NSObject

@property (strong, nonatomic) NSString *placeID;
@property (strong, nonatomic) NSString *placeName;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *aboutPlace;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *likedUsers;

@property (strong, nonatomic) NSString *venderName;
@property (strong, nonatomic) NSString *venderEmail;
@property (strong, nonatomic) NSString *venderID;

@property BOOL status;
@property BOOL isLiked;

@property double latitude;
@property double longitude;
@property double distance;

@property int vendorAge;

- (id)init;

@end
