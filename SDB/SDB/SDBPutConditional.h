//
//  SDBOperation.h
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBOperation.h"

@interface SDBPutConditional : SDBOperation

- (id)initWithItemName:(NSString *)item attributes:(NSDictionary *)attributes conditions:(NSDictionary *)conditions domainName:(NSString *)domain;


@end
