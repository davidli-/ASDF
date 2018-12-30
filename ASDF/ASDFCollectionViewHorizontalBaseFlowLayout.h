//
//  ASDFCollectionViewHorizontalBaseFlowLayout.h
//  ASDF
//
//  Created by Macmafia on 2018/12/29.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDFCollectionViewHorizontalBaseFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) CGFloat mCellWidth; //cell的d宽度
@property (nonatomic) CGFloat mCellHeight; //cell的高度
@property (nonatomic) NSInteger mAllColumn; //全部的列数
@property (nonatomic) CGSize mContentSize;//内容可滑动范围
@property (nonatomic, strong) NSMutableArray *mAttributesArr;//布局对象数组

@end

NS_ASSUME_NONNULL_END
