//
//  SDBPut.m
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBPut.h"

@interface SDBPut() {
}
- (void)addAttributes:(NSDictionary *)attributes;
@end

@implementation SDBPut

- (id)init {
    return [self initWithItemName:nil attributes:nil domainName:nil];
}

- (id)initWithItemName:(NSString *)item attributes:(NSDictionary *)attributes domainName:(NSString *)domain {
    self = [super init];
    if (self) {
        [parameters_ setValue:@"PutAttributes" forKey:@"Action"];
        [parameters_ setValue:item forKey:@"ItemName"];
        [parameters_ setValue:domain forKey:@"DomainName"];
        [self addAttributes:attributes];
    }
    return self;
}

- (void)addAttributes:(NSDictionary *)attributes {
    __block NSInteger idx = 0;
    
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [obj enumerateObjectsUsingBlock:^(id multiValueObj, NSUInteger idz, BOOL *stop) {
                NSString *stringValue = [self getObjectValueToSaveToSDB:multiValueObj];
                
                [parameters_ setValue:key forKey:[NSString stringWithFormat:@"Attribute.%d.Name",idx]];
                [parameters_ setValue:stringValue forKey:[NSString stringWithFormat:@"Attribute.%d.Value",idx]];
                [parameters_ setValue:@"false" forKey:[NSString stringWithFormat:@"Attribute.%d.Replace",idx]];
                
                ++idx;
            }];
        }
        else {
            NSString *stringValue = [self getObjectValueToSaveToSDB:obj];
            
            [parameters_ setValue:key forKey:[NSString stringWithFormat:@"Attribute.%d.Name",idx]];
            [parameters_ setValue:stringValue forKey:[NSString stringWithFormat:@"Attribute.%d.Value",idx]];
            [parameters_ setValue:@"true" forKey:[NSString stringWithFormat:@"Attribute.%d.Replace",idx]];
            
            ++idx;
        }
    }];
}



@end
