//
//  XMLTool.h
//  ASDF
//
//  Created by Macmafia on 2019/5/19.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Food.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMLTool : NSObject

+ (instancetype)shareInstance;

//开始解析
- (void)start;
- (Food*)dataAtIndexPath:(NSIndexPath*)indexPath;
- (NSUInteger)numOfDatasource;

@end

NS_ASSUME_NONNULL_END
