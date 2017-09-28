#import "RSNetworkClient.h"
#import "AFNetworking.h"

#import "CJSONDeserializer.h"
#import "CJSONDataSerializer.h"

@interface RSNetworkClient()

-(void)doSendRequest;
- (void)cancelConnection;
@end



@implementation RSNetworkClient



@synthesize selector;
@synthesize delegate    = _delegate;
@synthesize additionalData;
@synthesize username    = _username;
@synthesize password    = _password;
@synthesize receivedData    = _receivedData;
@synthesize connection      = _connection;
@synthesize progressSelector    = _progressSelector;
@synthesize bytesWritten    = _bytesWritten;
@synthesize expectedToWrite = _expectedToWrite;

+(NSString*)serverURL {
    return @"http://amicorazon.com/millam_api";
}
+(RSNetworkClient *)client {
	return [[RSNetworkClient alloc]init];
}

-(id)init{
	if(self==[super init]) {
		self.additionalData = [NSMutableDictionary  dictionary];
        self.receivedData  = [[NSMutableData alloc] init];
	}
	return self;
}

-(void)doSendRequest {
    [self cancelConnection];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://amicorazon.com/"]];
//    [client setParameterEncoding:AFJSONParameterEncoding];
    [client postPath:@"millam_api/index.php" parameters:self.additionalData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200) {
            
            NSError *error = nil;
            NSDictionary *resp = nil;
            resp = [NSJSONSerialization
                    JSONObjectWithData:operation.responseData
                    
                    options:kNilOptions
                    error:&error];
            
            if(error){
                NSLog(@"could not parse response %@",error);
            } else {
                NSLog(@"Response : %@", resp);
            }
            [self.delegate performSelectorOnMainThread:self.selector withObject:resp waitUntilDone:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate performSelectorOnMainThread:self.selector withObject:nil waitUntilDone:NO];
    }];
}

- (void)cancelConnection {
	[self.connection cancel];
    self.connection = nil;
}

- (void)sendRequest {
	[self.additionalData setObject:@"%@" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

@end
