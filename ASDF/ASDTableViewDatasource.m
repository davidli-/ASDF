//
//  ASDTableViewDatasource.m
//  ASDF
//
//  Created by Macmafia on 2019/5/13.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDTableViewDatasource.h"

@interface ASDTableViewDatasource ()

@property (nonatomic, strong) NSMutableArray<ASDTableViewModel *> *mDataArr;

@end

@implementation ASDTableViewDatasource

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initions];
    }
    return self;
}


//MARK:-数据初始化
- (void)initions{
    
    _mDataArr = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < 10; i++) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"苏小艾" withExtension:@"mp3"];
        AVAsset *asset = [AVAsset assetWithURL:url];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset automaticallyLoadedAssetKeys:@[@"status",@"duration"]];
        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
        
        ASDTableViewModel *model = [[ASDTableViewModel alloc] init];
        model.player = player;
        model.index = i;
        
        [_mDataArr addObject:model];
    }
}


- (BOOL)valideIndex:(NSUInteger)index
{
    NSUInteger count = _mDataArr.count;
    if (count) {
        return index >= 0 && index < count;
    }
    return NO;
}


//MARK:-API
- (NSUInteger)countOfDatasource
{
    return _mDataArr.count;
}

- (ASDTableViewModel*)modelAtIndex:(NSUInteger)index
{
    if ([self valideIndex:index]) {
        return _mDataArr[index];
    }
    return nil;
}

@end
