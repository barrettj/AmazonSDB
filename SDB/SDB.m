//
//  SDB.m
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDB.h"

@interface SDB() {
    SDBOperation *currentOperation_;
    NSMutableData *responseData_;
}

- (void)startRequest;

@end

@implementation SDB
@synthesize onReceivedData;

- (id)initWithOperation:(SDBOperation *)operation andBlock:(SDBReceiveDataBlock)block {
    self = [super init];
    if (self) {
        currentOperation_ = operation;
        self.onReceivedData = block;
    }
    return self;
}


- (void)startRequest {
    NSURL *sdbUrl = [NSURL URLWithString:currentOperation_.signedUrlString];
    NSURLRequest *sdbReq = [NSURLRequest requestWithURL:sdbUrl];
    NSURLConnection *sdbConn = [NSURLConnection connectionWithRequest:sdbReq delegate:self];
    if (!sdbConn) NSLog(@"Unable to initialize connection; check action parameters");
    /**
    if (sdbConn)
        NSLog(@"Performing %@ Operation on %@ endpoint with version %@",[currentOperation_ class], currentOperation_.regionEndPoint, currentOperation_.version);
    else 
        NSLog(@"Unable to initialize connection; check action parameters");
     */
}

#pragma mark - Operation Factory Methods

+ (void)listDomainsWithMaximum:(int)max block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBListDomains alloc] initWithMaxNumberOfDomains:max nextToken:nil]; 
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)metadataForDomain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBDomainMetadata alloc] initWithDomainName:[NSString stringWithString:domain]];
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)createDomain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBCreateDomain alloc] initWithDomainName:[NSString stringWithString:domain]];
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)deleteDomain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBDeleteDomain alloc] initWithDomainName:[NSString stringWithString:domain]];
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}


+ (void)selectWithExpression:(NSString *)expression block:(SDBReceiveDataBlock)block {
    
    SDBOperation *operation = [[SDBSelect alloc] initWithExpression:[NSString stringWithString:expression] nextToken:nil]; 
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)putItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    
    SDBOperation *operation = [[SDBPut alloc] initWithItemName:item attributes:attributes domainName:domain];
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)putItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBBatchPut alloc] initWithItems:items domainName:domain];
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)getItem:(NSString *)item withAttributes:(NSArray *)attributes domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBGet alloc] initWithItemName:item attributes:attributes domainName:domain];
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)deleteItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBDelete alloc] initWithItemName:item attributes:attributes domainName:domain];
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)deleteItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBBatchDelete alloc] initWithItems:items domainName:domain];
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}


#pragma mark - Connection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (!responseData_)
        responseData_ = [NSMutableData data];
    [responseData_ setLength:0];
    //NSLog(@"SDB has responded to the request and is sending %lld bytes of data", response.expectedContentLength);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // The operation object parses the xml
    [currentOperation_ parseResponseData:responseData_];
    //NSLog(@"%@",[[NSString alloc] initWithData:responseData_ encoding:NSUTF8StringEncoding]);
    
    // The parsed data dictionary is sent to the block
    if (self.onReceivedData)
        self.onReceivedData([NSDictionary dictionaryWithDictionary:currentOperation_.responseDictionary], currentOperation_);
}

@end