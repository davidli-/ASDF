//
//  ASDFDataBaseHelper.m
//  ASDF
//
//  Created by Macmafia on 2019/8/2.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFDataBaseHelper.h"

@interface ASDFDataBaseHelper()

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@end


@implementation ASDFDataBaseHelper

+ (instancetype)shareInstance{
    static ASDFDataBaseHelper *mHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mHelper = [[ASDFDataBaseHelper alloc] init];
    });
    return mHelper;
}

- (NSPersistentContainer *)persistentContainer
{
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Model"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"error %@, %@", error, error.userInfo);
                }
            }];
        }
    }
    return _persistentContainer;
}

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"~~error %@, %@", error, error.userInfo);
    }
}

@end
