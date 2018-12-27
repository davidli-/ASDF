//
//  ASDFCollectionViewHorizonalFlowLayout.m
//  ASDF
//
//  Created by Macmafia on 2018/12/27.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "ASDFCollectionViewHorizonalFlowLayout.h"

@interface ASDFCollectionViewHorizonalFlowLayout()

@property (nonatomic, strong) NSMutableArray *mAttributesArr;

@end


@implementation ASDFCollectionViewHorizonalFlowLayout

-(void)prepareLayout
{
    [super prepareLayout];
    
    _mSectionLeftInset = _mSectionRightInset = 10;
    _mInteritemSpacing = _mLineSpacing = 10;
    _mCellWidth = _mCellHeight = 50;
    _mColumn = (self.collectionView.frame.size.width - _mSectionLeftInset - _mSectionRightInset + _mInteritemSpacing) / (_mCellWidth + _mInteritemSpacing);
    NSInteger sections = self.collectionView.numberOfSections;
    if (0 == _mAllColumn) {
        for (int i = 0; i < sections; i++) {
            _mAllColumn += [self.collectionView numberOfItemsInSection:i];
        }
    }
    //准备布局数据
    if (_mAttributesArr) {
        [_mAttributesArr removeAllObjects];
    }else{
        _mAttributesArr = [NSMutableArray arrayWithCapacity:_mAllColumn];
    }
    for (int i = 0; i < _mAllColumn; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGRect frame;
        long column = indexPath.item;
        
        frame.origin.x = _mSectionLeftInset + column * (_mInteritemSpacing + _mCellWidth);
        frame.origin.y = (_mCellHeight - self.itemSize.height) / 2.0;
        frame.size = self.itemSize;
        
        att.frame = frame;
        [_mAttributesArr addObject:att];
    }
}

- (CGSize)collectionViewContentSize
{
    CGSize size = CGSizeMake(_mSectionLeftInset + _mSectionRightInset + _mAllColumn * _mCellWidth + (_mAllColumn - 1) * _mInteritemSpacing,
                             _mCellHeight);
    return size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *att = _mAttributesArr[indexPath.item];
    return att;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *oriArr = [super layoutAttributesForElementsInRect:rect];
    NSArray *newArr = [[NSArray alloc] initWithArray:oriArr copyItems:YES];
    NSInteger count = [newArr count];
    
    for(NSInteger i = 0; i < count; ++i) {
        
        //只处理cell
        UICollectionViewLayoutAttributes *currentLayoutAttributes = newArr[i];
        if (UICollectionElementCategoryCell != currentLayoutAttributes.representedElementCategory) {
            continue;
        }
    }
    
    return self.mAttributesArr;
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
