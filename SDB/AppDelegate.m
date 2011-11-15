
#import "AppDelegate.h"
#import "APIKey.h"

@interface AppDelegate() {
    //SDBOperation *currentOperation;
    int selectorIndex;
    NSArray *selectors_;
}
@end

@implementation AppDelegate

@synthesize window = _window;

#pragma mark - Example Code

- (NSDictionary *)exampleItem {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:@"1" forKey:@"Attribute1"];
    [attributes setValue:@"2" forKey:@"Attribute2"];
    [attributes setValue:@"three" forKey:@"Attribute3"];
    return [NSDictionary dictionaryWithDictionary:attributes];
}

- (NSDictionary *)exampleItems {
    NSMutableDictionary *items = [NSMutableDictionary dictionary];
    [items setValue:[self exampleItem] forKey:@"Item4"];
    [items setValue:[self exampleItem] forKey:@"Item5"];
    [items setValue:[self exampleItem] forKey:@"Item6"];
    return [NSDictionary dictionaryWithDictionary:items];
}

- (void)doNext {
    selectorIndex++;

    if (selectorIndex <= selectors_.count) {
        SEL nextOperation = [[selectors_ objectAtIndex:selectorIndex-1] pointerValue];
        [self performSelector:nextOperation];
    }
}

- (void)createNewDomain {
    [SDB createDomain:@"Tester" block:^(NSDictionary *sdbData, SDBOperation* operation) {
        NSLog(@"Got data from %@:\n%@", operation.class, sdbData);
        [self doNext];
    }];
}

- (void)deleteDomain {
    [SDB deleteDomain:@"Tester" block:^(NSDictionary *sdbData, SDBOperation* operation) {
        NSLog(@"Got data from %@:\n%@", operation.class, sdbData);
        [self doNext];
    }];
}

- (void)putItem1 {
    [SDB putItem:@"Item1" withAttributes:[self exampleItem] domain:@"Tester" block:^(NSDictionary *sdbData, SDBOperation* operation) {
        NSLog(@"Got data from %@:\n%@", operation.class, sdbData);
        [self doNext];
    }];
}

- (void)putItem2 {
    [SDB putItem:@"Item2" withAttributes:[self exampleItem] domain:@"Tester" block:^(NSDictionary *sdbData, SDBOperation* operation) {
        NSLog(@"Got data from %@:\n%@", operation.class, sdbData);
        [self doNext];
    }];
}

- (void)putItem3 {
    [SDB putItem:@"Item3" withAttributes:[self exampleItem] domain:@"Tester" block:^(NSDictionary *sdbData, SDBOperation* operation) {
        NSLog(@"Got data from %@:\n%@", operation.class, sdbData);
        [self doNext];
    }];
}

- (void)batchPutItems {
    [SDB putItems:[self exampleItems] domain:@"Tester" block:^(NSDictionary *sdbData, SDBOperation* operation) {
        NSLog(@"Got data from %@:\n%@", operation.class, sdbData);
        [self doNext];
    }];
}

- (void)listItems {
    [SDB selectWithExpression:@"select * from Tester" block:^(NSDictionary *sdbData, SDBOperation* operation) {
        NSLog(@"Got data from %@:\n%@", operation.class, sdbData);
        [self doNext];
    }];
}

- (void)getItem {
    [SDB getItem:@"Item1" withAttributes:[NSArray arrayWithObjects:@"Attribute1", @"Attribute2", nil] domain:@"Tester" block:^(NSDictionary *sdbData, SDBOperation* operation) {
        NSLog(@"Got data from %@:\n%@", operation.class, sdbData);
        [self doNext];
    }];
}

- (void)deleteItem {
    [SDB deleteItem:@"Item1" withAttributes:nil domain:@"Tester" block:^(NSDictionary *sdbData, SDBOperation* operation) {
        NSLog(@"Got data from %@:\n%@", operation.class, sdbData);
        [self doNext];
    }];
}

- (void)batchDeleteItems {
    [SDB deleteItems:[self exampleItems] domain:@"Tester" block:^(NSDictionary *sdbData, SDBOperation* operation) {
        NSLog(@"Got data from %@:\n%@", operation.class, sdbData);
        [self doNext];
    }];
}

/**
 Example/Test for all SDBOperations
 */

- (void)sdbExample {
    if ([SECRET_KEY isEqualToString:@""] || [ACCESS_KEY isEqualToString:@""]) {
        NSLog(@"Add your API keys to APIKey.h");
        exit(0);
    }
    selectorIndex = 0;
    selectors_ = [NSArray arrayWithObjects:
                  [NSValue valueWithPointer:@selector(createNewDomain)], 
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
                  nil];
    [self deleteDomain];
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