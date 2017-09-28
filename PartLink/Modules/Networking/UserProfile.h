//
//  ContinetObject.h
//  Geocery
//
//  Created by RB on 4/8/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *jabberID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *aboutMe;
@property (strong, nonatomic) NSString *mainProfilePath;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *flames;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *likedUsers;
@property (strong, nonatomic) NSMutableArray *likedMeUsers;
@property (strong, nonatomic) NSMutableArray *likedPlaces;
@property (strong, nonatomic) NSMutableArray *nearyByPeoples;


@property int year;
@property int month;
@property int date;
@property int age;
@property int flag;
@property BOOL status;
@property BOOL isMen;
@property BOOL isLiked;
@property BOOL likeMe;

@property double latitude;
@property double longitude;
@property double distance;

@property int connectionCounter;

- (id)init;

@end
