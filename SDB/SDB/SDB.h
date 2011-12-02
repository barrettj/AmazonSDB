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
#import "SDBGet.h"
#import "SDBDelete.h"
#import "SDBBatchPut.h"
#import "SDBBatchDelete.h"

#define SECONDS_BEFORE_TIMEOUT 45

typedef void (^SDBReceivedDataBlock)(NSDictionary*, SDBOperation*);

@interface SDB : NSObject <NSURLConnectionDataDelegate> {
    NSTimer *timeoutTimer;
}

@property (readwrite, copy) SDBReceivedDataBlock onReceivedData;

+ (void)setAccessKey:(NSString*)access andSecretKey:(NSString*)secret;
+ (BOOL)accessKeysSet;

+ (SDBSelect*)selectWithExpression:(NSString *)expression block:(SDBReceivedDataBlock)block;
+ (SDBSelect*)selectWithExpression:(NSString *)expression readMultiValue:(BOOL)multiValue block:(SDBReceivedDataBlock)block;


+ (SDBGet*)getItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceivedDataBlock)block;
+ (SDBGet*)getItem:(NSString *)item withAttributes:(NSDictionary *)attributes readMultiValue:(BOOL)multiValue domain:(NSString *)domain block:(SDBReceivedDataBlock)block;


+ (SDBPut*)putItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (SDBBatchPut*)putItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (SDBDelete*)deleteItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceivedDataBlock)block;
+ (SDBBatchDelete*)deleteItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (SDBListDomains*)listDomainsWithMaximum:(int)max block:(SDBReceivedDataBlock)block;
+ (SDBDomainMetadata*)metadataForDomain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (SDBCreateDomain*)createDomain:(NSString *)domain block:(SDBReceivedDataBlock)block;
+ (SDBDeleteDomain*)deleteDomain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (SDBOperation*)continueOperation:(SDBOperation*)operation block:(SDBReceivedDataBlock)block;

@end