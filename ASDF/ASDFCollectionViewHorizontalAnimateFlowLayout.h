//
//  ASDFCollectionViewHorizontalAnimateFlowLayout.h
//  ASDF
//
//  Created by Macmafia on 2018/12/29.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASDFCollectionViewHorizontalBaseFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDFCollectionViewHorizontalAnimateFlowLayout : ASDFCollectionViewHorizontalBaseFlowLayout
@property (nonatomic) BOOL mDataUpdated;//数据是否发生变化，数据变化就z需要重新计算contentsize和布局数组，否则不重新计算，节省开销
@end

NS_ASSUME_NONNULL_END
