//
//  RACTableViewModel.m
//  ASDF
//
//  Created by Macmafia on 2019/5/26.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "RACTableViewModel.h"
#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
#import "RACNetworker.h"

@interface RACTableViewModel ()

//属性对内可读可写
@property (nonatomic) BOOL isRefresh;
@property (nonatomic, readwrite) BOOL shouldReload;
@property (nonatomic, readwrite, strong) NSMutableArray *mDataArr;

@end

@implementation RACTableViewModel

- (NSUInteger)numOfRows{
    return 20;
}

- (RACModel *)dataAtIndexPath:(NSIndexPath *)indexPath{
    RACModel *model = [[RACModel alloc] init];
    model.title = [NSString stringWithFormat:@"%ld",indexPath.row];
    return model;
}

- (RACCommand *)fetchCommand{
    //创建指令
    @weakify(self)
    if (!_fetchCommand) {
        _fetchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *paramsTuple) {
            @strongify(self)
            self.isRefresh = YES;
            int page = [paramsTuple.first intValue];
            int size = [paramsTuple.second intValue];
            NSLog(@"++请求页码：%d,每页数量:%d~",page,size);
            RACSignal* fetchSignal = [[RACNetworker shareIns] fetchRequestWithPage:page size:size];
            return fetchSignal;
        }];
        
        //订阅指令
        [[_fetchCommand.executionSignals switchToLatest] subscribeNext:^(NSMutableArray *dataArr) {
            @strongify(self)
            if (dataArr) {
                self.mDataArr = dataArr;
                self.shouldReload = YES;//通知V层更新TableView
                self.isRefresh = NO;
            }
        } error:^(NSError * error) {
            //Http error
        } completed:^{
            //finished
        }];
    }
    return _fetchCommand;
}
@end
