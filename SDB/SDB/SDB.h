//
//  SDB.h
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBOperation.h"
#import "SDBListDomains.h"
#import "SDBDomainMetadata.h"
#import "SDBCreateDomain.h"
#import "SDBDeleteDomain.h"
#import "SDBSelect.h"
#import "SDBPut.h"
#import "SDBPutConditional.h"
#import "SDBGet.h"
#import "SDBDelete.h"
#import "SDBBatchPut.h"
#import "SDBBatchDelete.h"

#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    // only OS X needs this
    @protocol NSURLConnectionDataDelegate <NSURLConnectionDelegate>
    @optional
    - (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;
    - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

    - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

    - (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request;
    - (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
     totalBytesWritten:(NSInteger)totalBytesWritten
    totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

    - (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;

    - (void)connectionDidFinishLoading:(NSURLConnection *)connection;
    @end

#endif

#define SECONDS_BEFORE_TIMEOUT 45

typedef void (^SDBReceivedDataBlock)(NSDictionary* data, SDBOperation* op);

@interface SDB : NSObject <NSURLConnectionDataDelegate> {
    NSTimer *timeoutTimer;
}

@property (readwrite, copy) SDBReceivedDataBlock onReceivedData;

+ (void)setAccessKey:(NSString*)access andSecretKey:(NSString*)secret;
+ (BOOL)accessKeysSet;

+ (SDBSelect*)selectWithExpression:(NSString *)expression block:(SDBReceivedDataBlock)block;
+ (SDBSelect*)selectWithExpression:(NSString *)expression readMultiValue:(BOOL)multiValue block:(SDBReceivedDataBlock)block;


+ (SDBGet*)getItem:(NSString *)item withAttributes:(NSArray *)attributes domain:(NSString *)domain block:(SDBReceivedDataBlock)block;
+ (SDBGet*)getItem:(NSString *)item withAttributes:(NSDictionary *)attributes readMultiValue:(BOOL)multiValue domain:(NSString *)domain block:(SDBReceivedDataBlock)block;


+ (SDBPut*)putItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (SDBPutConditional*)putItemConditional:(NSString *)item withAttributes:(NSDictionary *)attributes conditions:(NSDictionary *)conditions domain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (SDBBatchPut*)putItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (SDBDelete*)deleteItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceivedDataBlock)block;
+ (SDBBatchDelete*)deleteItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (SDBListDomains*)listDomainsWithMaximum:(int)max block:(SDBReceivedDataBlock)block;
+ (SDBDomainMetadata*)metadataForDomain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (SDBCreateDomain*)createDomain:(NSString *)domain block:(SDBReceivedDataBlock)block;
+ (SDBDeleteDomain*)deleteDomain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (SDBOperation*)continueOperation:(SDBOperation*)operation block:(SDBReceivedDataBlock)block;

@end