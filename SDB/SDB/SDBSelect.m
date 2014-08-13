//
//  SDBSelect.m
//  SDB
//
//  Created by Brandon Smith on 8/13/11.
//  Copyright 2011 Brandon Smith. All rights reserved.
//

#import "SDBSelect.h"

@implementation SDBSelect
@synthesize selectExpression, isMultiValue, sortedKeys;

- (id)init {
    return [self initWithExpression:nil nextToken:nil];
}

- (id)initWithExpression:(NSString *)expression nextToken:(NSString *)next {
    self = [self initWithExpression:expression readMultiValue:NO nextToken:next];
    return self;
}

- (id)initWithExpression:(NSString *)expression readMultiValue:(BOOL)multiValue nextToken:(NSString *)next {
    self = [super init];
    if (self) {
        [parameters_ setValue:@"Select" forKey:@"Action"];
        [parameters_ setValue:[self urlEncodeString:expression] forKey:@"SelectExpression"];
        if (!multiValue) [parameters_ setValue:@"true" forKey:@"ConsistentRead"];
        if (next) [parameters_ setValue:next forKey:@"NextToken"];
        
        selectExpression = expression;
        isMultiValue = multiValue;
        
        self.sortedKeys = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark - NSXML Parsing delegate

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
    
    // We found a name tag but it belongs to the Item, not the Attribute
    if ([elementName isEqualToString:@"Name"] && !inAttribute_) {
        // Update the current item name
        currentItemName_ = [NSString stringWithString:currentElementString_];
        
        // Create a new dictionary to store this item's data
        currentItemDictionary_ = [NSMutableDictionary dictionary];
        
        // Select statements can be "ordered by", so retain this information
        [self.sortedKeys addObject:currentItemName_];
    }
    
    // We found a name tag that belongs to the attribute
    else if ([elementName isEqualToString:@"Name"]) {
        // Store the name to be used as the key when we get the value
        currentKey_ = [NSString stringWithString:currentElementString_];
    }
    
    // We found an attribute value that needs to be added to the dictionary for the current key
    else if ([elementName isEqualToString:@"Value"]) {
        id currentData = currentItemDictionary_[currentKey_];
        
        if (currentData) {
            // if there's already a value, then we're dealing with multi-valued attributes, so turn the result into an array
            
            if ([currentData isKindOfClass:[NSMutableArray class]]) {
                [currentData addObject:[NSString stringWithString:currentElementString_]];
            }
            else {
                NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:currentData, [NSString stringWithString:currentElementString_], nil];
                [currentItemDictionary_ setValue:array forKey:currentKey_];
            }
        }
        else {
            [currentItemDictionary_ setValue:[NSString stringWithString:currentElementString_] forKey:currentKey_];
        }
    }
    
    // We are done with the item and its attribute dict should be added to the response dictionary
    else if ([elementName isEqualToString:@"Item"]) {
        [responseDictionary_ setValue:[NSDictionary dictionaryWithDictionary:currentItemDictionary_] forKey:currentItemName_];
    }
    
    // There is more data to retrieve
    else if ([elementName isEqualToString:@"NextToken"]) {
        //[responseDictionary_ setValue:[NSString stringWithString:currentElementString_] forKey:@"NextToken"];
        self.nextToken = [self urlEncodeString:[NSString stringWithString:currentElementString_]];
        hasNextToken_ = YES;
    }
}

@end
