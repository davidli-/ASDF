//
//  Model.h
//  ASDF
//
//  Created by Macmafia on 2018/11/13.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject<NSCopying,NSMutableCopying>
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
