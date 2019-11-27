//
//  CoreDataStack.m
//  ASDF
//
//  Created by Macmafia on 2019/8/12.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "CoreDataStack.h"
#import "Course+CoreDataClass.h"
#import "Section+CoreDataClass.h"
#import "Teacher+CoreDataClass.h"


@interface CoreDataStack ()

@end


@implementation CoreDataStack


+ (instancetype)shareInstance
{
    static CoreDataStack *mStack;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mStack = [[CoreDataStack alloc] init];
    });
    
    return mStack;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "D.XMix" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ASDF.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    // 数据库做轻量迁移时 传入此options字典
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, 
                              NSInferMappingModelAutomaticallyOption: @YES};
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                                   configuration:nil 
                                                             URL:storeURL 
                                                         options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark -BUSINESS

- (void)initMulMocWithParentMoc
{
    // 主队列使用的MOC
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    // 私有队列MOC，处理耗时任务
    _backgroudnContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _backgroudnContext.parentContext = _mainContext;
    
    // 开始测试
    
    // 增加
    Course *c = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.mainContext];
    c.id = 1;
    c.name =@"A1";
    [self.mainContext save:nil];
    
    Course *c2 = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.backgroudnContext];
    c2.id = 2;
    c2.name =@"A2";
    
    [self.backgroudnContext performBlock:^{
        [self.backgroudnContext save:nil];
        
        // 必须执行[parentContext save]，否则backgroudnContext所做修改不会被持久化
        [self.mainContext performBlock:^{
            [self.mainContext save:nil];
        }];
    }];
    
    // 修改
    NSFetchRequest *request = [Course fetchRequest];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"id = %d",1];
    [request setPredicate:predicate];
    
    // mainMOC查询
    NSError *error;
    NSArray *matchArr = [self.mainContext executeFetchRequest:request error:&error];
    NSInteger count = matchArr.count;
    for (NSInteger i = 0; i < count; i++) {
        Course *c = matchArr[i];
        c.name = [c.name stringByAppendingString:@"X"];
    }
    NSError *error1;
    [self.mainContext save:&error1];
    
    // backgroundMOC 查询
    NSError *errorBack;
    NSArray *matchArr2 = [self.backgroudnContext executeFetchRequest:request error:&errorBack];
    NSInteger count2 = matchArr2.count;
    for (NSInteger i = 0; i < count2; i++) {
        Course *c = matchArr[i];
        c.name = [c.name stringByAppendingString:@"X"];
    }
    
    [self.backgroudnContext performBlock:^{
        NSError *error2;
        [self.backgroudnContext save:&error2];
        
        // 必须执行[parentContext save]，否则backgroudnContext所做修改不会被持久化
        [self.mainContext performBlock:^{
            [self.mainContext save:nil];
        }];
    }];
}


- (void)initMulMOCWithOnePSC
{
    // 主队列使用的MOC
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    // 私有队列MOC，处理耗时任务
    _backgroudnContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _backgroudnContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdate:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    // 开始测试
    
    // 增加
    Course *c = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.mainContext];
    c.id = 1;
    c.name =@"A1";
    [self.mainContext save:nil];
    
    Course *c2 = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.backgroudnContext];
    c2.id = 2;
    c2.name =@"A2";
    [self.backgroudnContext save:nil];
    
    // 修改
    NSFetchRequest *request = [Course fetchRequest];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"id = %d",1];
    [request setPredicate:predicate];
    
    // mainMOC查询
    NSError *error;
    NSArray *matchArr = [self.mainContext executeFetchRequest:request error:&error];
    NSInteger count = matchArr.count;
    for (NSInteger i = 0; i < count; i++) {
        Course *c = matchArr[i];
        c.name = [c.name stringByAppendingString:@"X"];
    }
    NSError *error1;
    [self.mainContext save:&error1];
    
    // backgroundMOC 查询
    NSError *errorBack;
    NSArray *matchArr2 = [self.backgroudnContext executeFetchRequest:request error:&errorBack];
    NSInteger count2 = matchArr2.count;
    for (NSInteger i = 0; i < count2; i++) {
        Course *c = matchArr[i];
        c.name = [c.name stringByAppendingString:@"X"];
    }
    NSError *error2;
    [self.backgroudnContext save:&error2];
}

- (void)onUpdate:(NSNotification *)notification{
    
    NSLog(@"++++通知所在线程:%@",[NSThread currentThread]);
    
    // 区分通知中context是哪个，将其中的变化合并到别的context中
    NSManagedObjectContext *context = notification.object;
    if ([context isEqual:_mainContext]) {
        [_backgroudnContext performBlock:^{
            NSLog(@"++++_backgroudnContext performBlock 所在线程:%@",[NSThread currentThread]);
            [_backgroudnContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
    else if ([context isEqual:_backgroudnContext]){
        [_mainContext performBlock:^{
            NSLog(@"++++_mainContext performBlock 所在线程:%@",[NSThread currentThread]);
            [_mainContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}


@end
