//
//  ContinetObject.h
//  Geocery
//
//  Created by RB on 4/8/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    ADNONE          = 0,
    ADDEFAULT       = 1,
    ADNANTIONWIDE   = 2,
    ADVERTISER      = 3
    
} ADType;

@interface ADObject: NSObject

@property ADType        adType;

@property (strong, nonatomic) NSString *adName;
@property (strong, nonatomic) NSString *adAddress;

@property (strong, nonatomic) NSString *adDefaultImagePath;
@property (strong, nonatomic) NSString *adDefaultLink;
@property (strong, nonatomic) NSString *adPaidImagePath;
@property (strong, nonatomic) NSString *adPaidLink;

@property (strong, nonatomic) NSString *blastOffer;
@property (strong, nonatomic) NSString *blastOfferImagePath;
@property (strong, nonatomic) NSString *blastStartHour;
@property (strong, nonatomic) NSString *blastStartPeriod;
@property (strong, nonatomic) NSString *blastEndHour;
@property (strong, nonatomic) NSString *blastEndPeriod;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *facebookLink;
@property (strong, nonatomic) NSString *partyStartHour;
@property (strong, nonatomic) NSString *partyStartPeriod;
@property (strong, nonatomic) NSString *partyEndHour;
@property (strong, nonatomic) NSString *partyEndPeriod;
@property (strong, nonatomic) NSString *streetAddress;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zipcode;

- (id)init;

@end
