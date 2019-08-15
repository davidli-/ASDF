//
//  CoreDataSourse.h
//  ASDF
//
//  Created by Macmafia on 2019/8/7.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course+CoreDataClass.h"
#import "Section+CoreDataClass.h"
#import "Teacher+CoreDataClass.h"

@protocol CoreDataSourseDelegate <NSObject>

- (void)dataSourcesDidReceiveAllData:(NSArray*_Nonnull)dataArr;
- (void)dataSourcesDidInsertDataAtIndex:(NSUInteger)index;
- (void)dataSourcesDidDeleteDataAtIndex:(NSUInteger)index;
- (void)dataSourcesDidUpdateDataAtIndex:(NSUInteger)index;
- (void)dataSourcesLoadLimitedData;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataSourse : NSObject

@property (nonatomic, weak) id<CoreDataSourseDelegate>delegate;

- (Course*)modelAtIndex:(NSUInteger)index;

// 数据库操作
- (void)insertData;
- (void)removeDataAtIndex:(NSUInteger)index;
- (void)updateDataAtIndex:(NSUInteger)index;
- (NSArray*)dataSources;
- (NSUInteger)dataNumberOfDataArr;
- (void)fetchAllDatas;
- (void)loadDataAtPage:(NSUInteger)page;
- (void)fetchWithRequestInDatamodeldFile;
- (void)fetchFilter;
- (void)asynchronousFetchRequest;
- (void)batchUpdate;
- (void)batchDelete;

@end

NS_ASSUME_NONNULL_END
