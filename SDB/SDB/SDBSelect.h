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

- (id)initWithExpression:(NSString *)expression readMultiValue:(BOOL)multiValue nextToken:(NSString *)next;

@property (nonatomic, copy, readonly) NSString* selectExpression;
@property (nonatomic, assign, readonly) BOOL isMultiValue;

@end
