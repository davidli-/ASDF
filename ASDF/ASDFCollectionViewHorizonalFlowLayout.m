//
//  ASDFCollectionViewHorizonalFlowLayout.m
//  ASDF
//
//  Created by Macmafia on 2018/12/27.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "ASDFCollectionViewHorizonalFlowLayout.h"

@implementation ASDFCollectionViewHorizonalFlowLayout

/*准备布局相关的数据，【必须重写】
 The default implementation of this method does nothing. During the layout cycle, the collection view calls this method first to give you a chance to prepare any data needed during the layout operation. When defining a custom layout, you can override this method and use it to set up data structures or perform any initial computations needed to perform the layout later.
 */
-(void)prepareLayout
{
    [super prepareLayout];//必须调用super
    
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

/*计算可滑动区域，【必须重写】
 This property contains the width and height of all of the collection view’s contents, not just the content that is currently visible. The collection view uses this information to configure its scroll view.
 When creating custom layouts, you must reimplement this property and provide the size of the collection view’s contents. It is recommended that you cache the content size and adjust the value when the layout changes or when items are added and removed.
 The default value in this property is NSZeroSize.
 */
- (CGSize)collectionViewContentSize
{
    return self.mContentSize;
}

/*预先计算indexPath处item的布局信息，optional,非【必须重写】
 The default implementation of this method does nothing. During the layout cycle, the collection view calls this method first to give you a chance to prepare any data needed during the layout operation. When defining a custom layout, you can override this method and use it to set up data structures or perform any initial computations needed to perform the layout later.
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //初始化方法1：记得copy 否则报错
    //UICollectionViewLayoutAttributes *att = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    //初始化方法2：推荐这种
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame;
    long column = indexPath.item;
    
    frame.origin.x = self.sectionInset.left + column * (self.minimumInteritemSpacing + self.mCellWidth);
    frame.origin.y = (self.mCellHeight - self.itemSize.height) / 2.0;
    frame.size = self.itemSize;
    
    att.frame = frame;
    
    return att;
}

/*返回指定区域内items的布局信息，【必须重写】
 Returns the layout attribute objects for all items and views in the specified rectangle.
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attArr = [NSMutableArray array];

    for (UICollectionViewLayoutAttributes *att in self.mAttributesArr) {
        if (CGRectContainsRect(rect, att.frame) &&
            UICollectionElementCategoryCell == att.representedElementKind)
        {
            [attArr addObject:att];
        }
    }
    return attArr;
}


//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
//{
//    //1.计算scrollview最后停留的范围
//    CGRect lastRect ;
//    lastRect.origin = proposedContentOffset;
//    lastRect.size = self.collectionView.frame.size;
//
//    //2.取出这个范围内的所有属性
//    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
//
//    //起始的x值，也即默认情况下要停下来的x值
//    CGFloat startX = proposedContentOffset.x;
//
//    //3.遍历所有的属性
//    CGFloat adjustOffsetX = MAXFLOAT;
//    for (UICollectionViewLayoutAttributes *attrs in array) {
//        CGFloat attrsX = CGRectGetMinX(attrs.frame);
//        CGFloat attrsW = CGRectGetWidth(attrs.frame) ;
//
//        if (startX - attrsX  < attrsW/2) {
//            adjustOffsetX = -(startX - attrsX + self.minimumInteritemSpacing);
//        }else{
//            adjustOffsetX = attrsW - (startX - attrsX);
//        }
//
//        break ;//只循环数组中第一个元素即可，所以直接break了
//    }
//    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
//}
//
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return YES;
//}
@end
