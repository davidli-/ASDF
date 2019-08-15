//
//  CoreDataStack.h
//  ASDF
//
//  Created by Macmafia on 2019/8/12.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


NS_ASSUME_NONNULL_BEGIN

@interface CoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectContext *backgroudnContext;

+ (instancetype)shareInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)initMulMocWithParentMoc;
- (void)initMulMOCWithOnePSC;

@end

NS_ASSUME_NONNULL_END
