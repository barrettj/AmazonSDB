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

- (void)resetTimeoutTimer {
    if (timeoutTimer) {
        [timeoutTimer invalidate];
    }
    
    timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:SECONDS_BEFORE_TIMEOUT target:self selector:@selector(timeoutReached:) userInfo:nil repeats:NO];
}

- (void)startRequest {
    NSURL *sdbUrl = [NSURL URLWithString:currentOperation_.signedUrlString];
    NSURLRequest *sdbReq = [NSURLRequest requestWithURL:sdbUrl];
    NSURLConnection *sdbConn = [NSURLConnection connectionWithRequest:sdbReq delegate:self];
    if (!sdbConn) NSLog(@"Unable to initialize connection; check action parameters");
    
    [self resetTimeoutTimer];
    
    /**
    if (sdbConn)
        NSLog(@"Performing %@ Operation on %@ endpoint with version %@",[currentOperation_ class], currentOperation_.regionEndPoint, currentOperation_.version);
    else 
        NSLog(@"Unable to initialize connection; check action parameters");
     */
}

#pragma mark - Identity Handling

static NSString* accessKey;
static NSString* secretKey;

+ (void)setAccessKey:(NSString*)access andSecretKey:(NSString*)secret {
    accessKey = [access copy];
    secretKey = [secret copy];
}

+ (BOOL)accessKeysSet {
    if (accessKey == nil || secretKey == nil)
        return NO;
    
    if ([accessKey isEqualToString:@""] || [secretKey isEqualToString:@""])
        return NO;
    
    return YES;
}

#pragma mark - Operation Factory Methods

+ (void)listDomainsWithMaximum:(int)max block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBListDomains alloc] initWithMaxNumberOfDomains:max nextToken:nil];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)metadataForDomain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBDomainMetadata alloc] initWithDomainName:[NSString stringWithString:domain]];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)createDomain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBCreateDomain alloc] initWithDomainName:[NSString stringWithString:domain]];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)deleteDomain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBDeleteDomain alloc] initWithDomainName:[NSString stringWithString:domain]];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}


+ (void)selectWithExpression:(NSString *)expression block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBSelect alloc] initWithExpression:[NSString stringWithString:expression] nextToken:nil]; 
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)selectWithExpression:(NSString *)expression readMultiValue:(BOOL)multiValue block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBSelect alloc] initWithExpression:[NSString stringWithString:expression] readMultiValue:multiValue nextToken:nil]; 
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)putItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBPut alloc] initWithItemName:item attributes:attributes domainName:domain];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)putItem:(NSString *)item withAttributes:(NSDictionary *)attributes multiValue:(NSArray*)multiValue domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBPut alloc] initWithItemName:item attributes:attributes multiValue:multiValue domainName:domain];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}


+ (void)putItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBBatchPut alloc] initWithItems:items domainName:domain];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)putMultiItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBPutMulti alloc] initWithItemName:item attributes:attributes domainName:domain];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)getItem:(NSString *)item withAttributes:(NSArray *)attributes readMultiValue:(BOOL)multiValue  domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBGet alloc] initWithItemName:item attributes:attributes readMultiValue:multiValue domainName:domain];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)getItem:(NSString *)item withAttributes:(NSArray *)attributes domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBGet alloc] initWithItemName:item attributes:attributes domainName:domain];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}


+ (void)deleteItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBDelete alloc] initWithItemName:item attributes:attributes domainName:domain];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)deleteItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceiveDataBlock)block {
    SDBOperation *operation = [[SDBBatchDelete alloc] initWithItems:items domainName:domain];
    operation.accessKey = accessKey;
    operation.secretKey = secretKey;
    SDB *sdb = [[SDB alloc] initWithOperation:operation andBlock:block];
    [sdb startRequest];
}

+ (void)continueOperation:(SDBOperation*)operation block:(SDBReceiveDataBlock)block {
    if (!operation.hasNextToken)
        return;
    
    NSString *token = [operation.responseDictionary objectForKey:@"NextToken"];
    
    token = [token stringByReplacingOccurrencesOfString:@"\n" withString:@"%0A"];
    token = [token stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    
    SDBOperation *newOp;
    
    if ([operation isKindOfClass:[SDBSelect class]]) {
        SDBSelect *oldOp = (SDBSelect*)operation;
        
        newOp = [[SDBSelect alloc] initWithExpression:oldOp.selectExpression readMultiValue:oldOp.isMultiValue nextToken:token]; 
        newOp.accessKey = accessKey;
        newOp.secretKey = secretKey;
    }
    else {
        NSLog(@"Unknown Operation to Continue");
        return;
    }
    
    SDB *sdb = [[SDB alloc] initWithOperation:newOp andBlock:block];
    [sdb startRequest];   
}


#pragma mark - Connection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [self resetTimeoutTimer];
    
    if (!responseData_)
        responseData_ = [NSMutableData data];
    [responseData_ setLength:0];
    //NSLog(@"SDB has responded to the request and is sending %lld bytes of data", response.expectedContentLength);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self resetTimeoutTimer];
    
    [responseData_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [timeoutTimer invalidate];
    timeoutTimer = nil;
    
    // The operation object parses the xml
    [currentOperation_ parseResponseData:responseData_];
    //NSLog(@"%@",[[NSString alloc] initWithData:responseData_ encoding:NSUTF8StringEncoding]);
    
    currentOperation_.failed = NO;
    
    // The parsed data dictionary is sent to the block
    if (self.onReceivedData)
        self.onReceivedData([NSDictionary dictionaryWithDictionary:currentOperation_.responseDictionary], currentOperation_);
}

#pragma mark - Timeout Handler

- (void)timeoutReached:(NSTimer*)timer {
    
    currentOperation_.failed = YES;
    
    if (self.onReceivedData) {
        self.onReceivedData(nil, currentOperation_);
        self.onReceivedData = nil; // nil the block so if for some reason we do get data after the timeout, nothing will happen
    }
    
    timeoutTimer = nil;
}

@end