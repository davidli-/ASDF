//
//  Food.h
//  ASDF
//
//  Created by Macmafia on 2019/5/19.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Food : NSObject

@property (nonatomic, copy) NSString *name; //名字
@property (nonatomic, copy) NSString *descript; //描述
@property (nonatomic, copy) NSString *price; //美元价格
@property (nonatomic, copy) NSString *calories; //卡路里

- (void)f_setValue:(nullable id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
