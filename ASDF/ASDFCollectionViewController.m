//
//  ASDFCollectionViewController.m
//  ASDF
//
//  Created by Macmafia on 2018/12/25.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "ASDFCollectionViewController.h"
#import "ASDFCollectionViewHorizontalAnimateFlowLayout.h"

static const CGFloat ITEM_WIDTH  = 200.0f;
static const CGFloat ITEM_HEIGHT = 100.0f;

@interface ASDFCollectionViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionview;
@property (weak, nonatomic) IBOutlet ASDFCollectionViewHorizontalAnimateFlowLayout *mHorizontalFlowLayout;
@property (nonatomic, strong) NSMutableArray *mAnimatedIndexPathArr;
@end

@implementation ASDFCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)initData
{
    _mAnimatedIndexPathArr = [NSMutableArray array];
    
    _mHorizontalFlowLayout.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
    _mHorizontalFlowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _mHorizontalFlowLayout.minimumLineSpacing = 10;
    _mHorizontalFlowLayout.minimumInteritemSpacing = 10;
    _mHorizontalFlowLayout.mCellWidth = ITEM_WIDTH;
    _mHorizontalFlowLayout.mCellHeight = ITEM_HEIGHT;
//    _mHorizontalFlowLayout.mColumn = (CGRectGetWidth(self.mCollectionview.frame) - _mHorizontalFlowLayout.sectionInset.left - _mHorizontalFlowLayout.sectionInset.right + _mHorizontalFlowLayout.minimumInteritemSpacing) / (_mHorizontalFlowLayout.mCellWidth + _mHorizontalFlowLayout.minimumInteritemSpacing);
}

#pragma mark -Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 120;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView
   moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"++move from:%lu to:%lu",sourceIndexPath.item,destinationIndexPath.item);
}

#pragma mark -Delegate
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"++select section:%ld, index:%ld",(long)indexPath.section,(long)indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([_mAnimatedIndexPathArr containsObject:indexPath]) {
//        return;
//    }
//    [_mAnimatedIndexPathArr addObject:indexPath];
//
//    cell.transform = CGAffineTransformMakeScale(0.5, 0.8);
//    [UIView animateWithDuration:0.5 animations:^{
//        cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    }];
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView
         performAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    NSLog(@"++perform action section:%ld, row:%ld",(long)indexPath.section,(long)indexPath.row);
}

//#pragma mark -Layout
//InitData中已经通过_mHorizontalFlowLayout设置过，下面这些代理不需了
//每个item的size
//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (0 == indexPath.section) {
//        return CGSizeMake(itemWidth, itemHeight);
//    }
//    return CGSizeMake(80, 50);
//}
////section的上左下右的内边距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
//layout:(UICollectionViewLayout *)collectionViewLayout
//insetForSectionAtIndex:(NSInteger)section
//{
//    if (0 == section) {
//        return UIEdgeInsetsMake(10, 10, 10, 10);
//    }
//    return UIEdgeInsetsMake(0, 10, 0, 10);
//}
////每个section中行与行之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView
//                   layout:(UICollectionViewLayout *)collectionViewLayout
//minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
////每个section中列与列之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView
//                   layout:(UICollectionViewLayout *)collectionViewLayout
//minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
@end
