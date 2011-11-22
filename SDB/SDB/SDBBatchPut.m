//
//  SDBBatchPut.m
//  SDB
//
//  Created by Brandon Smith on 8/14/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBBatchPut.h"

@interface SDBBatchPut() {
}
- (void)addItems:(NSDictionary *)items;
@end

@implementation SDBBatchPut

- (id)init {
    return [self initWithItems:nil domainName:nil];
}

- (id)initWithItems:(NSDictionary *)items domainName:(NSString *)domain {
    self = [super init];
    if (self) {
        [parameters_ setValue:@"BatchPutAttributes" forKey:@"Action"];
        [parameters_ setValue:domain forKey:@"DomainName"];
        [self addItems:items];
    }
    return self;
}

- (void)addItems:(NSDictionary *)items {
    
    __block NSDictionary *attributes;
    
    [items.allKeys enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL *stop) {
        
        [parameters_ setValue:item forKey:[NSString stringWithFormat:@"Item.%d.ItemName",idx]];
        
        attributes = [items valueForKey:item];
        
        __block NSInteger idy = 0;
        
        [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
  
            if ([obj isKindOfClass:[NSArray class]]) {
                [obj enumerateObjectsUsingBlock:^(id multiValueObj, NSUInteger idz, BOOL *stop) {
                    NSString *stringValue = [self urlEncodeValue:multiValueObj];
                    
                    [parameters_ setValue:key forKey:[NSString stringWithFormat:@"Item.%d.Attribute.%d.Name", idx, idy]];
                    [parameters_ setValue:stringValue forKey:[NSString stringWithFormat:@"Item.%d.Attribute.%d.Value", idx, idy]];
                    [parameters_ setValue:@"false" forKey:[NSString stringWithFormat:@"Item.%d.Attribute.%d.Replace",idx, idy]];
                    
                    ++idy;
                }];
            }
            else {
                NSString *stringValue = [self urlEncodeValue:obj];
                
                [parameters_ setValue:key forKey:[NSString stringWithFormat:@"Item.%d.Attribute.%d.Name", idx, idy]];
                [parameters_ setValue:stringValue forKey:[NSString stringWithFormat:@"Item.%d.Attribute.%d.Value", idx, idy]];
                [parameters_ setValue:@"true" forKey:[NSString stringWithFormat:@"Item.%d.Attribute.%d.Replace",idx, idy]];
                
                ++idy;
            }
        }];
        
    }];
}

@end
