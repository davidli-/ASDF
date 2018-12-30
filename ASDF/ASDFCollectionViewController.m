//
//  ASDFCollectionViewController.m
//  ASDF
//
//  Created by Macmafia on 2018/12/25.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "ASDFCollectionViewController.h"
#import "ASDFCollectionViewHorizontalAnimateFlowLayout.h"

static const CGFloat ITEM_WIDTH  = 50.0f;
static const CGFloat ITEM_HEIGHT = 50.0f;

@interface ASDFCollectionViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionview;
@property (weak, nonatomic) IBOutlet ASDFCollectionViewHorizontalAnimateFlowLayout *mHorizontalFlowLayout;
@property (nonatomic, strong) NSMutableArray *mAnimatedIndexPathArr;
@property (nonatomic, strong) UILongPressGestureRecognizer *mGesture;
@property (nonatomic, strong) NSIndexPath *mStartIndexPath;
@property (nonatomic, strong) NSIndexPath *mTargetIndexPath;
@property (nonatomic, strong) NSMutableArray *mDatasourceArr;
@end

@implementation ASDFCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

#pragma mark -Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return _mDatasourceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:1];
    int num = [_mDatasourceArr[indexPath.item] intValue];
    label.text = [NSString stringWithFormat:@"%d",num];
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

#pragma mark -Business

- (void)initData
{
    _mAnimatedIndexPathArr = [NSMutableArray array];
    _mDatasourceArr = [NSMutableArray arrayWithCapacity:120];
    for (int i = 0; i < 120; i++) {
        [_mDatasourceArr addObject:@(i)];
    }
    _mHorizontalFlowLayout.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
    _mHorizontalFlowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _mHorizontalFlowLayout.minimumLineSpacing = 10;
    _mHorizontalFlowLayout.minimumInteritemSpacing = 10;
    _mHorizontalFlowLayout.mCellWidth = ITEM_WIDTH;
    _mHorizontalFlowLayout.mCellHeight = ITEM_HEIGHT;
    //    _mHorizontalFlowLayout.mColumn = (CGRectGetWidth(self.mCollectionview.frame) - _mHorizontalFlowLayout.sectionInset.left - _mHorizontalFlowLayout.sectionInset.right + _mHorizontalFlowLayout.minimumInteritemSpacing) / (_mHorizontalFlowLayout.mCellWidth + _mHorizontalFlowLayout.minimumInteritemSpacing);
}

- (void)initUI{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"操作" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(onHandleBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    _mGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onHangleGesture:)];
    [self.mCollectionview addGestureRecognizer:_mGesture];
}

#pragma mark -Cell Move Actions
- (void)onHandleBtn:(id)sender{
    [self.mCollectionview moveItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                  toIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [_mDatasourceArr exchangeObjectAtIndex:0 withObjectAtIndex:2];
}

- (void)onHangleGesture:(UIGestureRecognizer*)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self onDragBegin:gesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self onDragChanged:gesture];
            break;
        case UIGestureRecognizerStateEnded:
            [self onDragEnd:gesture];
            break;
        case UIGestureRecognizerStateCancelled:
            //[_mCollectionview cancelInteractiveMovement];
            break;
        default:
            break;
    }
}

- (void)onDragBegin:(UIGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:_mCollectionview];
    NSIndexPath *indexPath = [_mCollectionview indexPathForItemAtPoint:point];
    if (indexPath) {//开始移动
        _mStartIndexPath = indexPath;
        UICollectionViewCell *cell = [_mCollectionview cellForItemAtIndexPath:indexPath];
        cell.transform = CGAffineTransformMakeScale(1.2, 1.2);
        //[_mCollectionview beginInteractiveMovementForItemAtIndexPath:indexPath];
    }
}

- (void)onDragChanged:(UIGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:_mCollectionview];
    NSIndexPath *indexPath = [_mCollectionview indexPathForItemAtPoint:point];
    if (indexPath) {
        _mTargetIndexPath = indexPath;
        [_mCollectionview moveItemAtIndexPath:_mStartIndexPath toIndexPath:_mTargetIndexPath];
        [_mDatasourceArr exchangeObjectAtIndex:_mStartIndexPath.item withObjectAtIndex:_mTargetIndexPath.item];
        _mStartIndexPath = _mTargetIndexPath;
    }
}

- (void)onDragEnd:(UIGestureRecognizer*)gesture{
    //[_mCollectionview endInteractiveMovement];
}
@end
