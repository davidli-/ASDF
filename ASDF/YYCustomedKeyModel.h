//
//  YYCustomedKeyModel.h
//  ASDF
//
//  Created by Macmafia on 2019/10/25.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN
// 自定义属性映射数据交换
@interface YYCustomedKeyModel : YYModel
@property (copy, nonatomic) NSString *sex; // 对应字典中的gender字段
@property (nonatomic, assign) int ID; // 对应字典中的ID字段
@property (nonatomic, assign) int number; // 对应字典中的子字典的number字段
@end

NS_ASSUME_NONNULL_END
