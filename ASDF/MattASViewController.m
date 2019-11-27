//
//  MattASViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/11/20.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "MattASViewController.h"
#import "MattASCellNode.h"

@interface MattASViewController ()
<ASTableDataSource,
ASTableDelegate>

@property(nonatomic, strong) ASTableNode *tableNode;
@end

@implementation MattASViewController

- (instancetype)init{
    // ASTableNode相当于UITableview
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    self = [super initWithNode:_tableNode];
    
    if (self) {
        
        _tableNode.dataSource = self;
        _tableNode.delegate = self;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /* TableNode.view = ASTableView
        Don't forget that a node's view or layer property should only be accessed after -viewDidLoad or -didLoad, respectively, have been called.
         即 注意访问TableNode.view的时机，只能在-viewDidload之后
     */
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.title = @"TableNode";
}

// MARK: ASTableNodeDataSource

- (NSInteger)tableNode:(ASTableNode *)tableNode 
 numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode
  nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASCellNode *(^ASCellNodeBlock)() = ^ASCellNode *() {
        MattASCellNode *cellNode = [[MattASCellNode alloc] initWithIndexPath:indexPath];
           return cellNode;
       };
    
       return ASCellNodeBlock;
}

// MARK:ASTableNodeDelegate

- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode {
    return YES;
}

- (void)tableNode:(ASTableNode *)tableNode 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
    //NSLog(@"++++didselectRow:%ld",indexPath.row);
}

// 替代 -tableView:heightForRowAtIndexPath:，用来约束cell的宽高信息
//- (ASSizeRange)tableNode:(ASTableNode *)tableNode 
//constrainedSizeForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGSize min = CGSizeMake(width, ([UIScreen mainScreen].bounds.size.height/3) * 2); // 指定最小宽高
//    CGSize max = CGSizeMake(width, INFINITY); // 指定最大宽高
//    return ASSizeRangeMake(min, max);
//}

@end
