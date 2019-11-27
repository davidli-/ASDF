//
//  CoreDataSourse.m
//  ASDF
//
//  Created by Macmafia on 2019/8/7.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "CoreDataSourse.h"
#import <UIKit/UIKit.h>
#import "ASDFDataBaseHelper.h"
#import "CoreDataStack.h"
#import "Student.h"

#define kLimiteSize 2;

@interface CoreDataSourse ()
@property (nonatomic, strong) NSMutableArray *mDatasourceArr;
@property (nonatomic, strong) NSManagedObjectContext *viewContext;
// YES时使用iOS10之后新出的NSPersistentContainer管理coredata堆栈，否则使用我自己的CoreDataStack类手动管理
@property (nonatomic, assign) BOOL useNewCoreDataStack; 
@end

@implementation CoreDataSourse

- (instancetype)init
{
    self = [super init];
    if (self) {
        _useNewCoreDataStack = YES;
        [self fetchAllDatas];
    }
    return self;
}

- (NSManagedObjectContext *)viewContext{
    if (!_viewContext) {
        if (_useNewCoreDataStack) {
            //使用iOS10之后的NSPersistentContainer
            // NSPersistentContainer提供的MOC默认是NSMainQueueConcurrencyType类型的
            _viewContext = [ASDFDataBaseHelper shareInstance].persistentContainer.viewContext;
        }else{
            // 使用老版本 自己写CoreData堆栈
            _viewContext = [CoreDataStack shareInstance].managedObjectContext;
        }
    }
    return _viewContext;
}






#pragma mark -Getter
- (NSMutableArray *)mDatasourceArr{
    if (!_mDatasourceArr) {
        _mDatasourceArr = [NSMutableArray array];
    }
    return _mDatasourceArr;
}






#pragma mark -Interface/Api
- (NSUInteger)dataNumberOfDataArr{
    return _mDatasourceArr.count;
}

- (NSArray*)dataSources{
    return [_mDatasourceArr copy];
}

- (Course*)modelAtIndex:(NSUInteger)index{
    return _mDatasourceArr[index];
}





#pragma mark -增删改查

- (void)insertData{
    // 1.从数据库中删除
    int32_t index = (int32_t)self.mDatasourceArr.count;
    
    Student *s1 = [[Student alloc] init];
    s1.sID = 101;
    s1.name = @"学生甲";
    
    Student *s2 = [[Student alloc] init];
    s2.sID = 102;
    s2.name = @"学生乙";
    
    Teacher *t = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.viewContext];
    t.id = index;
    t.name = [NSString stringWithFormat:@"老师%d",index];
    t.avator = [UIImage imageNamed:@"1"];
    t.descript = @"省级优秀教师";
    
    Course *c = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.viewContext];
    c.id = index;
    c.name = [NSString stringWithFormat:@"课程%d",index];
    c.url = @"https://www.baidu.com";
    c.teachers = [NSSet setWithObject:t]; // 1->N，直接设置course对应的关系“teachers”字段
    c.students = [NSSet setWithObjects:s1, s2, nil]; // 数组，transformable类型，数组中的元素student需要实现NSCoding协议
    
    [self save];
    
    // 2.从内存数据源中删除
    [self.mDatasourceArr addObject:c];
    
    index = MAX(0, index-1);
    if ([_delegate respondsToSelector:@selector(dataSourcesDidInsertDataAtIndex:)]) {
        [_delegate dataSourcesDidInsertDataAtIndex:index];
    }
}


- (void)removeDataAtIndex:(NSUInteger)index{
    if (index < 0 || (index >=0 && index >= self.mDatasourceArr.count)) {
        return;
    }

    // 1.从数据库中删除
    NSFetchRequest *fetchRequest = [Course fetchRequest];
    /*相当于上面的代码
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
     NSEntityDescription *desription = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.viewContext];
     [fetchRequest setEntity:desription];
     */
    
    Course *indexedCourse = _mDatasourceArr[index];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"id = %d",indexedCourse.id];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.viewContext executeFetchRequest:fetchRequest error:&error];
    for (Course *c in fetchedObjects) {
        [self.viewContext deleteObject:c];
    }
    [self save];
    
    // 2.从内存数据源中删除
    [self.mDatasourceArr removeObjectAtIndex:index];
    
    if ([_delegate respondsToSelector:@selector(dataSourcesDidDeleteDataAtIndex:)]) {
        [_delegate dataSourcesDidDeleteDataAtIndex:index];
    }
}

- (void)updateDataAtIndex:(NSUInteger)index{
    
    NSFetchRequest *request = [Course fetchRequest];
    
    // 条件
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"id = %d",index];
    [request setPredicate:predicate];
    
    // 排序
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    request.sortDescriptors = @[descriptor];
    // 查询
    NSError *error;
    NSArray *matchArr = [self.viewContext executeFetchRequest:request error:&error];
    NSInteger count = matchArr.count;
    for (NSInteger i = 0; i < count; i++) {
        Course *c = matchArr[i];
        c.name = [c.name stringByAppendingString:@"X"]; //managed object对象，更新到内存中
    }
    [self save]; // 同步到数据库
    
    if ([_delegate respondsToSelector:@selector(dataSourcesDidUpdateDataAtIndex:)]) {
        [_delegate dataSourcesDidUpdateDataAtIndex:index]; //刷新UI，cell使用的model指向的就是内存中这个已更新的managed object对象，所以可以直接重新取值
    }
}

- (void)fetchAllDatas{
    
    NSFetchRequest *request = [Course fetchRequest];
    [self.viewContext executeRequest:request error:nil];
    
    // 排序
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    request.sortDescriptors = @[descriptor];
    // 查询
    NSError *error;
    NSArray *matchArr = [self.viewContext executeFetchRequest:request error:&error];
    
    [self.mDatasourceArr removeAllObjects];
    
    if (matchArr.count) {
        [self.mDatasourceArr addObjectsFromArray:matchArr];
    }
    if ([_delegate respondsToSelector:@selector(dataSourcesDidReceiveAllData:)]) {
        [_delegate dataSourcesDidReceiveAllData:self.mDatasourceArr];
    }
}


- (void)loadDataAtPage:(NSUInteger)page{
    NSFetchRequest *request = [Course fetchRequest];
    // 排序
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
    // 分页
    request.fetchOffset = (page - 1) * kLimiteSize;
    request.fetchLimit = kLimiteSize;
    
    // 查询
    NSError *error;
    NSArray *matchArr = [self.viewContext executeFetchRequest:request error:&error];
    
    [_mDatasourceArr removeAllObjects];
    [_mDatasourceArr addObjectsFromArray:matchArr];
    
    if ([_delegate respondsToSelector:@selector(dataSourcesLoadLimitedData)]) {
        [_delegate dataSourcesLoadLimitedData];
    }
}

- (void)fetchWithRequestInDatamodeldFile{
    
    // 使用.xcdatamodeld中预先定义好的NSFetchRequest
//    NSManagedObjectModel *model = [ASDFDataBaseHelper shareInstance].persistentContainer.managedObjectModel;
    NSManagedObjectModel *model = [CoreDataStack shareInstance].managedObjectModel;
    NSFetchRequest *request = [model fetchRequestTemplateForName:@"Fetch1"];
    NSError *error;
    NSArray *matchArr = [self.viewContext executeFetchRequest:request error:&error];
    
    [self.mDatasourceArr removeAllObjects];
    
    if (matchArr.count) {
        [self.mDatasourceArr addObjectsFromArray:matchArr];
    }
    if ([_delegate respondsToSelector:@selector(dataSourcesDidReceiveAllData:)]) {
        [_delegate dataSourcesDidReceiveAllData:self.mDatasourceArr];
    }
}


- (void)fetchFilter
{
    NSFetchRequest *fetchRequest = [Course fetchRequest];
    
    // 设置过滤条件
    
    // 查找以“X”开头的数据
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@",@"X"]; // 等价于@"name LIKE 'X*'"
    
    // 查找以“X”结尾的数据
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name ENDSWITH %@", @"X"]; // 等价于@"name LIKE '*X'"
    
    // 查找包含“X”的数据
    //NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name CONTAINS %@",@"X"]; // 等价于@"name LIKE '*X*'"
    
    // 模糊查询
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE %@", @"X*"];
    
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSArray *matchArr = [self.viewContext executeFetchRequest:fetchRequest error:&error];
    
    [self.mDatasourceArr removeAllObjects];
    
    if (matchArr.count) {
        [self.mDatasourceArr addObjectsFromArray:matchArr];
    }
    if ([_delegate respondsToSelector:@selector(dataSourcesDidReceiveAllData:)]) {
        [_delegate dataSourcesDidReceiveAllData:self.mDatasourceArr];
    }
}


- (void)asynchronousFetchRequest{
    
    // 1.创建fetch对象
    NSFetchRequest *fetchRequest = [Course fetchRequest];

    /*A fetch request that retrieves results asynchronously and supports progress notification.
     *异步地在moc所在线程上执行fetch任务；
     *[context executeRequest:error:]时，不阻塞其后行的任务；
     *异步!=子线程!!!! 异步只强调不阻塞后续任务，具体在子线程还是主线程fetch，须根据moc使用的队列而定；
     */
    
    // 2.创建异步任务
    NSAsynchronousFetchRequest *asyncFetch = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult * fetchResult) {
        
        NSLog(@"++++执行路径 4");
        NSLog(@"++++主线程? %d",[NSThread isMainThread]);
        
        // 5.返回异步查询的结果
        NSArray *resultArr = fetchResult.finalResult;
        [self.mDatasourceArr removeAllObjects];
        if (resultArr.count) {
            [self.mDatasourceArr addObjectsFromArray:resultArr];
        }
        if ([_delegate respondsToSelector:@selector(dataSourcesDidReceiveAllData:)]) {
            [_delegate dataSourcesDidReceiveAllData:self.mDatasourceArr];
        }
        
        // 移除对进度的监听
        [fetchResult.progress removeObserver:self forKeyPath:@"fractionCompleted" context:nil];
    }];
    
    // 3.开始执行fetch任务
    NSLog(@"++++开始 1~~");
    [self.viewContext performBlock:^{
    /* asynchronously performs the block on the context's queue
     */
        // 4.进度监听
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:1];
        [progress becomeCurrentWithPendingUnitCount:1];
        
        NSError *error = nil;
        NSPersistentStoreAsynchronousResult *result = [self.viewContext executeRequest:asyncFetch error:&error];
        //[result cancel];
        [result.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
        [progress resignCurrent];
        NSLog(@"++++执行路径 3");
    }];
    NSLog(@"+++执行路径 2~~");
}

- (void)batchUpdate
{
    // 指定修改的e实体
    NSBatchUpdateRequest *request = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:@"Course"];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"id > 0"];
    [request setPredicate:predicate];
    // 指定修改的字段
    request.propertiesToUpdate = @{@"name":@"课程S",@"url":@"www.xxx.com"};
    request.resultType = NSUpdatedObjectIDsResultType;
    NSError *error;
    NSBatchUpdateResult *batchResult = [self.viewContext executeRequest:request error:&error];
    NSArray<NSManagedObjectID*> *updatedObjectIDs = batchResult.result;
    
    // 同步数据的变化到MOC中 方式1（推荐）
    NSDictionary *updatedDict = @{NSUpdatedObjectsKey : updatedObjectIDs};
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:updatedDict intoContexts:@[self.viewContext]];
    
    // 同步数据的变化到MOC中 方式2
//    [updatedObjectIDs enumerateObjectsUsingBlock:^(NSManagedObjectID *objID, NSUInteger idx, BOOL *stop) {
//        NSManagedObject *obj = [self.viewContext objectWithID:objID];
//        if (![obj isFault]) {
//            [self.viewContext refreshObject:obj mergeChanges:YES];
//        }
//    }];
    
    // 刷新数据源和UI
    [self fetchAllDatas];
}

- (void)batchDelete
{
    // 创建fetchRequest
    NSFetchRequest *fetch = [Course fetchRequest];
    // 设置过滤条件
    fetch.predicate = [NSPredicate predicateWithFormat:@"id > 0"];
    // 创建删除request
    NSBatchDeleteRequest *delReqest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetch];
    delReqest.resultType = NSBatchDeleteResultTypeObjectIDs;
    
    // 开始批量删除
    NSError *error;
    NSBatchDeleteResult *deleteResult = [self.viewContext executeRequest:delReqest error:&error];
    NSArray<NSManagedObjectID*> *deletedObjectIDs = deleteResult.result;
    
    //同步数据到MOC
    NSDictionary *deletedDict = @{NSDeletedObjectsKey : deletedObjectIDs};
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:deletedDict intoContexts:@[self.viewContext]];
    
    // 刷新数据源和UI
    [self fetchAllDatas];
}

- (void)save{
    if (_useNewCoreDataStack) {
        [[ASDFDataBaseHelper shareInstance] saveContext];
    }else{
        [[CoreDataStack shareInstance] saveContext];
    }
}

#pragma mark -观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = object;
        float fraction = [change[NSKeyValueChangeNewKey] floatValue];
        NSLog(@"++++进度：%f, localizedDescription：%@, localizedAdditionalDescription：%@", fraction, progress.localizedDescription, progress.localizedAdditionalDescription);
    }
}
@end
