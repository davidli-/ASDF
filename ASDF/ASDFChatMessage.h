//
//  ASDFChatMessage.h
//  ASDF
//
//  Created by Macmafia on 2019/5/3.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YYKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDFChatMessage : NSObject

//存储属性
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *link;

//计算属性
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic, copy) NSMutableAttributedString *attributedText;
@property (nonatomic, strong) YYTextLayout *layout;
@property (nonatomic, strong) YYTextContainer *container;

- (NSMutableAttributedString *)createAttributedText;
- (CGFloat)calHight;

@end

NS_ASSUME_NONNULL_END
