//
//  RACTableViewModel.h
//  ASDF
//
//  Created by Macmafia on 2019/5/26.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACModel.h"
#import "RACCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACTableViewModel : NSObject

//属性对外只读
@property (nonatomic, readonly) BOOL isRefresh;
@property (nonatomic, readonly) BOOL shouldReload;
@property (nonatomic, readonly, strong) NSMutableArray *mDataArr;

@property (nonatomic, strong) RACCommand *fetchCommand;

- (NSUInteger)numOfRows;
- (RACModel*)dataAtIndexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
