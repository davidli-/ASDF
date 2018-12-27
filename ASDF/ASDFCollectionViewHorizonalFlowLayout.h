//
//  ASDFCollectionViewHorizonalFlowLayout.h
//  ASDF
//
//  Created by Macmafia on 2018/12/27.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDFCollectionViewHorizonalFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) CGFloat mSectionLeftInset; //section 左间距
@property (nonatomic) CGFloat mSectionRightInset;//section 右间距
@property (nonatomic) CGFloat mInteritemSpacing; //item左右之间的间距
@property (nonatomic) CGFloat mLineSpacing; //行间距
@property (nonatomic) CGFloat mCellWidth; //cell的d宽度
@property (nonatomic) CGFloat mCellHeight; //cell的高度
@property (nonatomic) NSInteger mColumn; //适合展示的列数
@property (nonatomic) NSInteger mAllColumn; //全部的列数

@end

NS_ASSUME_NONNULL_END
