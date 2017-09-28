//
//  CTLoadingView.m
//  CTweet
//
//  Created by  on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RSLoadingView.h"
#import "QuartzCore/QuartzCore.h"

@implementation RSLoadingView

@synthesize contentView         = _contentView;
@synthesize activityIndicator   = _activityIndicator;
@synthesize titleLabel          = _titleLabel;

-(id)init {
    self = [super init];
    if(self) {
        [self setContentView:[[UIView alloc] init]];
        [self.contentView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.7]];
        CALayer *layer = [self.contentView layer];
        [layer setCornerRadius:5];
        [layer setBorderColor:[UIColor colorWithWhite:200.0/255.0 alpha:1].CGColor];
        [layer setBorderWidth:1];
        [layer setMasksToBounds:YES];
        [self addSubview:self.contentView];
        
        [self setActivityIndicator:[[UIActivityIndicatorView alloc] init]];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator setHidesWhenStopped:NO];
        [self.activityIndicator startAnimating];
        [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.activityIndicator setColor:[UIColor blackColor]];
        [self.contentView addSubview:self.activityIndicator];
        
        [self setTitleLabel:[[UILabel alloc]init]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.titleLabel setMinimumFontSize:10];
        [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self.titleLabel setTextAlignment:UITextAlignmentCenter];
        [self.contentView addSubview:self.titleLabel];
        [self setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGSize minSize = CGSizeMake(200, 200);
    CGSize maxSize = CGSizeMake(220, 170);
    CGSize indicatorSize = CGSizeMake(37, 37);
    
    CGSize actualSize = CGSizeMake(self.frame.size.width-20>minSize.width?self.frame.size.width-20<maxSize.width?self.frame.size.width-20:maxSize.width:minSize.width,
                                   self.frame.size.height-20>minSize.height?self.frame.size.height-20<maxSize.height?self.frame.size.height-20:maxSize.height:minSize.height);
    
    CGRect containerFrame = CGRectMake((self.frame.size.width-actualSize.width)/2,
                                       (self.frame.size.height-actualSize.height)/3,
                                       actualSize.width,
                                       actualSize.height);
    [self.contentView setFrame:containerFrame];
    [self.activityIndicator setFrame:CGRectMake((actualSize.width - indicatorSize.width)/2,
                                                (actualSize.height - indicatorSize.height)/2,
                                                indicatorSize.width,
                                                indicatorSize.height)];
    
    [self.titleLabel setFrame:CGRectMake(10, 
                                         self.activityIndicator.frame.origin.y-self.activityIndicator.frame.size.height/2-30,
                                         actualSize.width-20,
                                         21)];
}
@end
