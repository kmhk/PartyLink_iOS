//
//  AsyncImageView.h
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


//
//

#import <UIKit/UIKit.h>

@class albumObject;
@class AsyncImageView;

@protocol AsyncImageView_Delegate <NSObject>

//- (void)touchUpInSide;
//- (void)showFullScreen:(AsyncImageView *)imageView;

@end


@interface AsyncImageView : UIImageView {
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
}

@property (nonatomic, assign) id<AsyncImageView_Delegate> delegate;
@property (nonatomic, strong) albumObject *albumImage;
@property (nonatomic, assign) BOOL hasTouchEvent;

-(void)loadImageFromURL:(NSURL*)url;
-(void)drawImage:(UIImage*)image;

@end
