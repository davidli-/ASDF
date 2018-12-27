//
//  NSObject+JsonToModel.h
//  ASDF
//
//  Created by Macmafia on 2017/8/26.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JsonToModel)

- (instancetype)initModelWithDictionary:(NSDictionary *)jsonDic;

@end
