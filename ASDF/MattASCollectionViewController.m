//
//  MattASCollectionViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/11/21.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "MattASCollectionViewController.h"
#import "MattASCellNode.h"

@interface MattASCollectionViewController ()
<ASCollectionDelegate,
ASCollectionDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation MattASCollectionViewController

- (instancetype)init{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:_flowLayout];
    
    // 设置collectionview
    self = [super initWithNode:_collectionNode];
    if (self) {
        // 设置cell的间距，等效于UICollectionViewDelegateFlowLayout的回调
        _flowLayout.minimumInteritemSpacing = 10; // 最小左右间距
        _flowLayout.minimumLineSpacing = 10; // 最小行间距
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionNode.delegate = self;
        _collectionNode.dataSource = self;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionNode.view.backgroundColor = [UIColor orangeColor];
    self.title = @"CollectionNode";
}

// MARK:-ASCollectionDataSource

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode 
     numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

// 此方法会在主线程中执行，但其中的cellNodeBlock会异步地在后台线程中执行
- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode 
      nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ASCellNode *(^ASCellNodeBlock)() = ^ASCellNode *() {
        MattASCellNode *cellNode = [[MattASCellNode alloc] initWithIndexPath:indexPath];
        //NSLog(@"+++Thread:%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            cellNode.view.backgroundColor = [UIColor lightTextColor]; // 必须在主线程中设置
        });
           return cellNode;
       };
    
       return ASCellNodeBlock;
}

// 此方法会在主线程中执行，cellNode的初始化也是在主线程中执行
//- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode 
//        nodeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    MattASCellNode *cellNode = [[MattASCellNode alloc] initWithIndexPath:indexPath];
//    NSLog(@"+++Thread:%@",[NSThread currentThread]);
//    //cellNode.view.backgroundColor = [UIColor lightTextColor]; // 必须在主线程中设置
//       return cellNode;
//}

- (void)collectionNode:(ASCollectionNode *)collectionNode 
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"+++select: %ld",indexPath.row);
}


// MARK: -UICollectionViewDelegateFlowLayout
// ??似乎与ASCollectionNode的布局系统冲突??

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView 
//                        layout:(UICollectionViewLayout*)collectionViewLayout 
//        insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView 
//                   layout:(UICollectionViewLayout*)collectionViewLayout 
//minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView 
//                   layout:(UICollectionViewLayout*)collectionViewLayout 
//minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}

@end
