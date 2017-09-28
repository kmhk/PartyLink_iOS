//
//  ContinetObject.m
//  Geocery
//
//  Created by RB on 4/8/14.
//  Copyright (c) 2014 RB. All rights reserved.
//

#import "ADObject.h"

@implementation ADObject

- (id)init {
    self.adType = ADNONE;
    
    self.adName = nil;
    self.adAddress = nil;
    
    self.adDefaultLink = nil;
    self.adDefaultImagePath = nil;
    self.adPaidLink = nil;
    self.adPaidImagePath = nil;

    return self;
}

@end
