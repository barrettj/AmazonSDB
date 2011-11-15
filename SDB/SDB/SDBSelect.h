//
//  SDBSelect.h
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBOperation.h"

@interface SDBSelect : SDBOperation

- (id)initWithExpression:(NSString *)expression nextToken:(NSString *)next;

@end
