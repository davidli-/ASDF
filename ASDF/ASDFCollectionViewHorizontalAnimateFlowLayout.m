//
//  ASDFCollectionViewHorizontalAnimateFlowLayout.m
//  ASDF
//
//  Created by Macmafia on 2018/12/29.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "ASDFCollectionViewHorizontalAnimateFlowLayout.h"

@implementation ASDFCollectionViewHorizontalAnimateFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];//必须调用super
    if (!_mDataUpdated) {
        _mDataUpdated = YES;
        //计算contentsize，即可滑动的范围
        self.mContentSize = CGSizeMake(self.sectionInset.left + self.sectionInset.right + self.mAllColumn * self.mCellWidth + (self.mAllColumn - 1) * self.minimumInteritemSpacing,self.mCellHeight);
        
        //准备布局数据(针对collectionview，数据或布局会变化的collectionview在这里计算并不会节省多少性能)
        if (self.mAttributesArr) {
            [self.mAttributesArr removeAllObjects];
        }else{
            self.mAttributesArr = [NSMutableArray arrayWithCapacity:self.mAllColumn];
        }
        for (int i = 0; i < self.mAllColumn; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.mAttributesArr addObject:att];
        }
    }
}

- (CGSize)collectionViewContentSize{
    return self.mContentSize;
}

//collectionview位置发生变化时是否重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame;
    long column = indexPath.item;
    
    frame.origin.x = self.sectionInset.left + column * (self.minimumInteritemSpacing + self.mCellWidth);
    frame.origin.y = (self.mCellHeight - self.itemSize.height) / 2.0;
    frame.size = self.itemSize;
    
    att.frame = frame;
    
    return att;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //计算collectionview中心点对应的偏移量
    CGFloat offsetX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0;
    NSUInteger count = self.mAttributesArr.count;
    
    for (int i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *att = self.mAttributesArr[i];
        if (!CGRectContainsRect(rect, att.frame) || UICollectionElementCategoryCell != att.representedElementKind){
            continue;
        }
        //当前attj离屏幕中心点的偏移量
        CGFloat deltX = fabs(offsetX - att.center.x);//左右滑动都要动画，所以取绝对值，=0时说明二者重合，缩放比例=1
        //计算缩放比例 在中心点时=1，其他情况下<1
        float scale = (1 - MIN(deltX / (self.collectionView.frame.size.width + self.itemSize.width / 2.0), 1));//防止超出1的情况
        att.transform = CGAffineTransformMakeScale(1, scale);
    }
    
    return self.mAttributesArr;
}

//计算停止滑动时 item的位置 实现item居中显示
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity
{
    CGRect visableRect = CGRectMake(proposedContentOffset.x, 0,
                                    self.collectionView.frame.size.width ,
                                    self.collectionView.frame.size.height);
    // 中心轴x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2.0f;
    NSArray *attrArr = [super layoutAttributesForElementsInRect:visableRect];
    CGFloat minDelta = MAXFLOAT; //距collectionview中心点最近的item与中心的的i间距
    
    for (UICollectionViewLayoutAttributes *attr in attrArr) {//找到最小间距
        
        CGFloat deltX = fabs(attr.center.x - centerX);
        
        if (deltX < fabs(minDelta)) {
            minDelta = attr.center.x - centerX;
        }
    }
    proposedContentOffset.x += minDelta;//补足间距 以便item中心点与collectionview中心重合
    
    if (proposedContentOffset.x <= 0) {
        proposedContentOffset.x = 0;
    }
    return proposedContentOffset;
}


/*如果collectionview的宽高与FlowLayout中设置的一样时，则不用自己计算items的布局，因此不需要事先计算，直接使用系统计算的结果即可。
 - (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
 {
 NSArray *sArr = [super layoutAttributesForElementsInRect:rect];
 //计算collectionview中心点对应的偏移量
 CGFloat offsetX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0;
 NSUInteger count = sArr.count;
 NSMutableArray *mutArr = [NSMutableArray array];
 for (int i = 0; i < count; i++) {
 UICollectionViewLayoutAttributes *att1 = sArr[i];
 UICollectionViewLayoutAttributes *att = [att1 copy];
 if (UICollectionElementCategoryCell != att.representedElementKind){
 continue;
 }
 //当前attj离屏幕中心点的偏移量
 CGFloat deltX = fabs(offsetX - att.center.x);//左右滑动都要动画，所以取绝对值，=0时说明二者重合，缩放比例=1
 //        //计算缩放比例 在中心点时=1，其他情况下<1
 float scale = 1 - MIN(deltX / (self.collectionView.frame.size.width + self.itemSize.width / 2.0), 1);//防止超出1的情况
 att.transform = CGAffineTransformMakeScale(1, scale);
 [mutArr addObject:att];
 }
 return mutArr;
 }
 */
@end
