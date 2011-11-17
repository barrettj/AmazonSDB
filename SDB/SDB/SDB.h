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
#import "SDBPutMulti.h"
#import "SDBGet.h"
#import "SDBDelete.h"
#import "SDBBatchPut.h"
#import "SDBBatchDelete.h"

#define SECONDS_BEFORE_TIMEOUT 45

typedef void (^SDBReceiveDataBlock)(NSDictionary*, SDBOperation*);

@interface SDB : NSObject <NSURLConnectionDataDelegate> {
    NSTimer *timeoutTimer;
}

@property (readwrite, copy) SDBReceiveDataBlock onReceivedData;

+ (void)setAccessKey:(NSString*)access andSecretKey:(NSString*)secret;
+ (BOOL)accessKeysSet;

+ (void)selectWithExpression:(NSString *)expression block:(SDBReceiveDataBlock)block;
+ (void)selectWithExpression:(NSString *)expression readMultiValue:(BOOL)multiValue block:(SDBReceiveDataBlock)block;


+ (void)getItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceiveDataBlock)block;
+ (void)getItem:(NSString *)item withAttributes:(NSDictionary *)attributes readMultiValue:(BOOL)multiValue domain:(NSString *)domain block:(SDBReceiveDataBlock)block;


+ (void)putItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceiveDataBlock)block;
+ (void)putItem:(NSString *)item withAttributes:(NSDictionary *)attributes multiValue:(NSArray*)multiValue domain:(NSString *)domain block:(SDBReceiveDataBlock)block;


+ (void)putItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceiveDataBlock)block;

+ (void)putMultiItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceiveDataBlock)block;


+ (void)deleteItem:(NSString *)item withAttributes:(NSDictionary *)attributes domain:(NSString *)domain block:(SDBReceiveDataBlock)block;
+ (void)deleteItems:(NSDictionary *)items domain:(NSString *)domain block:(SDBReceiveDataBlock)block;

+ (void)listDomainsWithMaximum:(int)max block:(SDBReceiveDataBlock)block;
+ (void)metadataForDomain:(NSString *)domain block:(SDBReceiveDataBlock)block;

+ (void)createDomain:(NSString *)domain block:(SDBReceiveDataBlock)block;
+ (void)deleteDomain:(NSString *)domain block:(SDBReceiveDataBlock)block;

+ (void)continueOperation:(SDBOperation*)operation block:(SDBReceiveDataBlock)block;

@end