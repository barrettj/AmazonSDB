//
//  SDBCreateDomain.h
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBOperation.h"

@interface SDBCreateDomain : SDBOperation

- (id)initWithDomainName:(NSString *)domainName;

@end
