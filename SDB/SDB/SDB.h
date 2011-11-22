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

+ (void)selectWithExpression:(NSString *)expression block:(SDBReceivedDataBlock)block;
+ (void)selectWithExpression:(NSString *)expression readMultiValue:(BOOL)multiValue block:(SDBReceivedDataBlock)block;


+ (void)getItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceivedDataBlock)block;
+ (void)getItem:(NSString *)item withAttributes:(NSDictionary *)attributes readMultiValue:(BOOL)multiValue domain:(NSString *)domain block:(SDBReceivedDataBlock)block;


+ (void)putItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (void)putItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (void)deleteItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceivedDataBlock)block;
+ (void)deleteItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (void)listDomainsWithMaximum:(int)max block:(SDBReceivedDataBlock)block;
+ (void)metadataForDomain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (void)createDomain:(NSString *)domain block:(SDBReceivedDataBlock)block;
+ (void)deleteDomain:(NSString *)domain block:(SDBReceivedDataBlock)block;

+ (void)continueOperation:(SDBOperation*)operation block:(SDBReceivedDataBlock)block;

@end