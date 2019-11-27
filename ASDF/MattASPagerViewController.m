//
//  MattASPagerViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/11/21.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "MattASPagerViewController.h"
#import "MattASViewController.h"
#import "MattASCollectionViewController.h"

@interface MattASPagerViewController ()
<ASPagerDelegate,
ASPagerDataSource>

@property (nonatomic, strong) ASPagerNode *pagerNode;
@property (nonatomic, strong) ASDisplayNode *topNode;
@property (nonatomic, strong) ASButtonNode *btnNode1;
@property (nonatomic, strong) ASButtonNode *btnNode2;
@end

@implementation MattASPagerViewController

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNodes];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _topNode.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    _btnNode1.frame = CGRectMake(5, 5, self.view.frame.size.width / 2 - 10, 40);
    _btnNode2.frame = CGRectMake(self.view.frame.size.width / 2 + 5, 5, self.view.frame.size.width / 2 - 10, 40);
    _pagerNode.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50);
}

// MARK: -ASPagerNodeDatasource

- (NSInteger)numberOfPagesInPagerNode:(ASPagerNode *)pagerNode{
    return 2;
}


// 在主线程中创建子vc
- (ASCellNode *)pagerNode:(ASPagerNode *)pagerNode 
              nodeAtIndex:(NSInteger)index
{
    ASCellNode *node = [[ASCellNode alloc] initWithViewControllerBlock:^UIViewController * _Nonnull{
        // block也在主线程中执行，所以可以安全的访问index参数
        if (index == 0) {
            return [[MattASViewController alloc] init];
        }else if (index == 1) {
            return [[MattASCollectionViewController alloc] init];
        }
        return nil;
    } didLoadBlock:^(__kindof ASDisplayNode * _Nonnull node) {
        // NSLog(@"+++%@",[NSThread currentThread]); // 此回调也是在主线程中
    }];
    node.style.preferredSize = pagerNode.bounds.size;
    
    return node;
}


// MARK: -Business

- (void)initNodes{
    //  顶部视图
    _topNode = [[ASDisplayNode alloc] init];
    _topNode.backgroundColor = [UIColor cyanColor];
    
    _btnNode1 = [[ASButtonNode alloc] init];
    _btnNode1.view.tag = 0;
    _btnNode2 = [[ASButtonNode alloc] init];
    _btnNode2.view.tag = 1;
    
    [_btnNode1 setTitle:@"TableNode" 
              withFont:[UIFont systemFontOfSize:15 weight:UIFontWeightBold] 
             withColor:[UIColor darkGrayColor] 
              forState:UIControlStateNormal];
    [_btnNode1 setBackgroundColor:[UIColor whiteColor]];
    [_btnNode1 addTarget:self action:@selector(onSelected:) forControlEvents:ASControlNodeEventTouchUpInside];
    
    [_btnNode2 setTitle:@"CollectionNode" 
     withFont:[UIFont systemFontOfSize:15 weight:UIFontWeightBold] 
    withColor:[UIColor darkGrayColor] 
     forState:UIControlStateNormal];
    [_btnNode2 setBackgroundColor:[UIColor whiteColor]];
    [_btnNode2 addTarget:self action:@selector(onSelected:) forControlEvents:ASControlNodeEventTouchUpInside];
    
    // PagerNode
    _pagerNode = [[ASPagerNode alloc] init];
    _pagerNode.delegate = self;
    _pagerNode.dataSource = self;
    
    
    [self.view addSubnode:_topNode];
    [self.view addSubnode:_pagerNode];
    [_topNode addSubnode:_btnNode1];
    [_topNode addSubnode:_btnNode2];
}

- (void)onSelected:(id)sender {
    ASButtonNode *btnNode = sender;
    [_pagerNode scrollToPageAtIndex:btnNode.view.tag animated:YES];
}
@end
