//
//  ASDFYYDatasource.m
//  ASDF
//
//  Created by Macmafia on 2019/5/3.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFYYDatasource.h"
#import "ASDFTextMaker.h"
#import <UIKit/UIKit.h>

@interface ASDFYYDatasource()
@property (nonatomic, strong) NSMutableArray *mDataArr;
@property (nonatomic) CGFloat width;
@end

@implementation ASDFYYDatasource

- (instancetype)initWithWidth:(CGFloat)width{
    if (self = [super init]) {
        _mDataArr = [NSMutableArray array];
        _width = width;
    }
    [self createDatas];//模拟数据
    return self;
}

//模拟数据
- (void)createDatas{
    for (NSInteger i = 0; i < 50; i++) {
        ASDFChatMessage *mess = [[ASDFChatMessage alloc] init];
        mess.name = @"昵称：";
        mess.message = @"哈哈哈哈哈哈哈，这里是YYLabel可点击文本~";
        mess.link = @"https://www.baidu.com";
        mess.width = _width;
        mess.attributedText = [mess createAttributedText];
        mess.height = [mess calHight];
        [_mDataArr addObject:mess];
    }
}

//Http请求结果返回后 转换为数据源
- (void)transformHttpData:(id)json{
    //使用YYModel转换实体
}

- (ASDFChatMessage*)chatMessAtIndexPath:(NSIndexPath*)indexPath{
    NSInteger index = indexPath.row;
    if (index >= 0 && index < _mDataArr.count) {
        return _mDataArr[index];
    }
    return nil;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    ASDFChatMessage *mess = [self chatMessAtIndexPath:indexPath];
    if (!mess) {
        return 0;
    }
    return mess.height;
}

- (NSInteger)numberOfRows{
    return _mDataArr.count;
}
@end
