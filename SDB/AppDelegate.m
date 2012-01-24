#define RESET_DOMAIN_EACH_TIME YES

#import "AppDelegate.h"
#import <objc/message.h>

@interface AppDelegate() {
    //SDBOperation *currentOperation;
    int selectorIndex;
    NSMutableArray *selectors_;
}

- (void)doNext;

@end

@implementation AppDelegate

@synthesize window = _window;

#pragma mark - Example Code

- (void)startTest {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doNext) name:@"ReadyForNext" object:nil];
    
    if (defaultHandler == nil) {
        defaultHandler = ^(NSDictionary *sdbData, SDBOperation* operation) {
            if (operation.failed) {
                NSLog(@"Operation Failed %@:\n%@", operation.class, sdbData);
                NSLog(@"Operation Failed, check above.");
            }
            else {
                if ([[sdbData allKeys] count] > 0) {
                    NSLog(@"Got data from %@:\n%@", operation.class, sdbData);
                }
                else {
                    NSLog(@"Call to %@ finished successfully.", operation.class);
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadyForNext" object:nil];
        };

    }
    
    if (RESET_DOMAIN_EACH_TIME) {
        [selectors_ insertObject:[NSValue valueWithPointer:@selector(createNewDomain)] atIndex:0];
        [selectors_ insertObject:[NSValue valueWithPointer:@selector(deleteDomain)] atIndex:0];
    }
    
    [self doNext];
}

- (void)doNext {
    selectorIndex++;
    
    if (selectorIndex <= selectors_.count) {
        SEL nextOperation = [[selectors_ objectAtIndex:selectorIndex-1] pointerValue];
        
        [self performSelector:nextOperation withObject:nil afterDelay:0.1];
    }
    else {
        NSLog(@"All Tests Complete!");
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (NSDictionary *)exampleItem {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:@"1" forKey:@"Attribute1"];
    [attributes setValue:@"2" forKey:@"Attribute2"];
    [attributes setValue:@"three'" forKey:@"Attribute3"];
    return [NSDictionary dictionaryWithDictionary:attributes];
}

- (NSDictionary *)multiData {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    NSString *timestamp1 = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
    NSString *timestamp2 = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
    
    [attributes setValue:[NSArray arrayWithObjects:timestamp1, timestamp2, nil] forKey:@"Timestamp"];
    return [NSDictionary dictionaryWithDictionary:attributes];
}


- (NSDictionary *)exampleItems {
    NSMutableDictionary *items = [NSMutableDictionary dictionary];
    [items setValue:[self exampleItem] forKey:@"Item4"];
    [items setValue:[self exampleItem] forKey:@"Item5"];
    [items setValue:[self exampleItem] forKey:@"Item6"];
    [items setValue:[self multiData] forKey:@"MultiItemInBatch"];
    return [NSDictionary dictionaryWithDictionary:items];
}


- (void)createNewDomain {
    [SDB createDomain:@"Tester" block:defaultHandler];
}

- (void)deleteDomain {
    [SDB deleteDomain:@"Tester" block:defaultHandler];
}

- (void)putItem1 {
    [SDB putItem:@"Item1" withAttributes:[self exampleItem] domain:@"Tester" block:defaultHandler];
}

- (void)putItem2 {
    [SDB putItem:@"Item2" withAttributes:[self exampleItem] domain:@"Tester" block:defaultHandler];
}

- (void)putItem3 {
    [SDB putItem:@"Item3" withAttributes:[self exampleItem] domain:@"Tester" block:defaultHandler];
}

- (void)putMulti {
    [SDB putItem:@"MultiItem" withAttributes:[self multiData] domain:@"Tester" block:defaultHandler];
}

- (void)getMulti {
    [SDB getItem:@"MultiItem" withAttributes:[NSArray arrayWithObjects:nil] readMultiValue:YES domain:@"Tester" block:defaultHandler];}

- (void)batchPutItems {
    [SDB putItems:[self exampleItems] domain:@"Tester" block:defaultHandler];
}

- (void)listItems {
    [SDB selectWithExpression:@"select * from Tester" block:defaultHandler];
}

- (void)getItem {
    [SDB getItem:@"Item1" withAttributes:[NSArray arrayWithObjects:@"Attribute1", @"Attribute2", nil] domain:@"Tester" block:defaultHandler];
}

- (void)deleteItem {
    [SDB deleteItem:@"Item1" withAttributes:nil domain:@"Tester" block:defaultHandler];
}

- (void)batchDeleteItems {
    [SDB deleteItems:[self exampleItems] domain:@"Tester" block:defaultHandler];
}

- (void)selectTest {
    // Continues until no more results (should be three items total at this point)
    
    __block SDBReceivedDataBlock handler = ^(NSDictionary *sdbData, SDBOperation* operation) {
        if (operation.failed) {
            NSLog(@"Operation Failed %@:\n%@", operation.class, sdbData);    
        }
        else {
            NSLog(@"Result from Select Test (hasNextToken = %i): %@", operation.hasNextToken, sdbData);
            
            if (operation.hasNextToken) {
                [SDB continueOperation:operation block:handler];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadyForNext" object:nil];
            }
        }
    };
    
    [SDB selectWithExpression:@"select * from Tester where doesntexist is null or doesntexist = '' limit 1" block:handler];
}

/**
 Example/Test for all SDBOperations
 */

- (void)sdbExample {
    [SDB setAccessKey:ACCESS_KEY andSecretKey:SECRET_KEY];
    
    if (![SDB accessKeysSet]) {
        NSLog(@"Add your API keys!");
        exit(0);
    }
    
    selectorIndex = 0;
    selectors_ = [NSMutableArray arrayWithObjects:
                  [NSValue valueWithPointer:@selector(putItem1)],
                  [NSValue valueWithPointer:@selector(putItem2)],
                  [NSValue valueWithPointer:@selector(putItem3)],
                  [NSValue valueWithPointer:@selector(batchPutItems)],
                  [NSValue valueWithPointer:@selector(listItems)], 
                  [NSValue valueWithPointer:@selector(getItem)], 
                  [NSValue valueWithPointer:@selector(deleteItem)], 
                  [NSValue valueWithPointer:@selector(listItems)],
                  [NSValue valueWithPointer:@selector(batchDeleteItems)],
                  [NSValue valueWithPointer:@selector(listItems)],
                  [NSValue valueWithPointer:@selector(putMulti)],
                  [NSValue valueWithPointer:@selector(getMulti)],
                  [NSValue valueWithPointer:@selector(selectTest)],

                  nil];
    
    [self startTest];
}

#pragma mark - SDB Delegate

- (void)didReceiveSDBData:(NSDictionary *)sdbData fromOperation:(SDBOperation *)operation {

}

#pragma mark - App Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self sdbExample];
    return YES;
}

@end