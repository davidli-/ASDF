//
//  ASDFCollectionViewController.m
//  ASDF
//
//  Created by Macmafia on 2018/12/25.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "ASDFCollectionViewController.h"

@interface ASDFCollectionViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionview;

@end

@implementation ASDFCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (0 == section) {
        return 120;
    }
    else{
        return 130;
    }
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
    if (0 == indexPath.section) {
        return NO;
    }
    return YES;
}


#pragma mark -Delegate
//- (BOOL)collectionView:(UICollectionView *)collectionView
//shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (0 == indexPath.section) {
//        return YES;
//    }
//    return NO;
//}


- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"++select section:%ld, index:%ld",(long)indexPath.section,(long)indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSpringLoadItemAtIndexPath:(NSIndexPath *)indexPath
           withContext:(id<UISpringLoadedInteractionContext>)context
{
    return YES;
}

#pragma mark -Layout
//每个item的size
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return CGSizeMake(50, 50);
    }
    return CGSizeMake(80, 50);
}
//section的上左下右的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
layout:(UICollectionViewLayout *)collectionViewLayout
insetForSectionAtIndex:(NSInteger)section
{
    if (0 == section) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
//每个section中行与行之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//每个section中列与列之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
@end
