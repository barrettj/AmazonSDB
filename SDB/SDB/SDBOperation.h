
/**
 Created by Brandon Smith on 7/2/11.
 Copyright 2011 Brandon Smith. All rights reserved.

 The SDBOperation class is an abstract superclass for the various SDB Operations.
 Currently available operations: 
 http://docs.amazonwebservices.com/AmazonSimpleDB/latest/DeveloperGuide/index.html?SDB_API_Operations.html
 Each SDBAction is responsible for two things:
 
 - Creating a signed url string to perform the operation
 - Parsing the response data generated by the operation 
 
 A subclass should customize the init method to include
 parameters specific to the operation.  The signedUrlString 
 method compiles these parameters into a url string that can 
 be used as part of an NSURLRequest/Connection.
 
 Each class should also implement the appropriate NSXML parser
 delegate methods such that a dictionary of the response data output.
 */

/**
 Currently available region endpoints
 More info at: 
 http://docs.amazonwebservices.com/AmazonSimpleDB/latest/DeveloperGuide/index.html?Endpoints.html
 */
#define kSDBRegionEndpointDefault @"sdb.amazonaws.com"
#define kSDBRegionEndpointUSEast @"sdb.amazonaws.com"
#define kSDBRegionEndpointUSWest @"sdb.us-west1.amazonaws.com"
#define kSDBRegionEndpointEUWest @"sdb.eu-west1.amazonaws.com"
#define kSDBRegionEndpointAPSouth @"sdb.ap-southeast-1.amazonaws.com"
#define kSDBRegionEndpointAPNorth @"sdb.ap-northeast-1.amazonaws.com"

/**
 AWS API Version
 More info at: 
 http://docs.amazonwebservices.com/AmazonSimpleDB/latest/DeveloperGuide/index.html?SDB_API_WSDL.html
 */
#define kSDBVersion @"2009-04-15"

@interface SDBOperation : NSObject <NSXMLParserDelegate> {
@protected
    NSMutableDictionary *parameters_;
    NSMutableDictionary *currentItemDictionary_;
    NSMutableDictionary *responseDictionary_;
    NSString            *currentElementName_;
    NSMutableString     *currentElementString_;
    BOOL                inAttribute_;
    BOOL                inError_;
    BOOL                hasNextToken_;
    NSString            *currentItemName_;
    NSString            *currentKey_;
    NSString            *accessKey_;
    NSString            *secretKey_;
    BOOL                failed_;
    BOOL                cancelled_;
    BOOL                success;
}

@property (copy, nonatomic)     NSString            *regionEndPoint;
@property (copy, nonatomic)     NSString            *version;
@property (readonly, nonatomic) NSMutableDictionary *responseDictionary;
@property (readonly, nonatomic) BOOL                hasNextToken;

@property (assign, nonatomic)   BOOL                failed;
@property (assign, nonatomic)   BOOL                cancelled;
@property (assign, nonatomic)   BOOL                success;

@property (copy, nonatomic)     NSString            *accessKey;
@property (copy, nonatomic)     NSString            *secretKey;


- (void)addToken:(NSString *)token;
- (NSString *)signedUrlString;
- (void)parseResponseData:(NSData *)data;

- (NSString*)getObjectValueToSaveToSDB:(id)obj;
- (NSString*)urlEncodeString:(NSString*)string;

@end