//
//  User.h
//  ASDF
//
//  Created by Macmafia on 2018/12/23.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property (nonatomic) NSInteger age; //年龄
@property (nonatomic) NSArray *cardArr; //拥有的银行卡
@end

NS_ASSUME_NONNULL_END
