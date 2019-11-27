//
//  YYHaveOtherEntityModel.h
//  ASDF
//
//  Created by Macmafia on 2019/10/25.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "YYModel.h"
#import "YYAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYHaveOtherEntityModel : YYModel
@property (nonatomic, strong) YYAccount *account;
@property (nonatomic, strong) NSArray <YYAccount*> *accountsArr;
@property (nonatomic, strong) NSDictionary <NSString*,YYAccount*> *accountsDic;
@end

NS_ASSUME_NONNULL_END
