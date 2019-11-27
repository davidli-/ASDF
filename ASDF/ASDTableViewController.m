//
//  ASDTableViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/5/13.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDTableViewController.h"
#import "ASDTableViewCell.h"
#import "Masonry.h"
#import "ASDTableViewDatasource.h"

static NSString *kIdentifier = @"cell";

@interface ASDTableViewController ()<ASDTableViewCellDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) ASDTableViewDatasource *mDatasource;

@end

@implementation ASDTableViewController

- (ASDTableViewDatasource *)mDatasource{
    if (!_mDatasource) {
        _mDatasource = [[ASDTableViewDatasource alloc] init];
    }
    return _mDatasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mTableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.view);
    }];
    
    /*注册cell，加载时配合[dequeueReusableCellWithIdentifier: forIndexPath:]方式使用
    [_mTableView registerClass:[ASDTableViewCell class] forCellReuseIdentifier:kIdentifier];
     */
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(onBak) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mDatasource.countOfDatasource;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*参考：https://blog.csdn.net/youngsblog/article/details/44536143 */
    //方式1：使用此方式初始化cell时，不需要注册cell，但需要自己判断cell为空的情况；为空时使用自定义的方法创建cell；
    ASDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if (!cell) {
        cell = [[ASDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
    }else{
        NSLog(@"+++cell被重用:%ld,%p",(long)indexPath.row,cell);
    }
    
    /*方式2：使用此方式初始化cell时，需要提前注册cell，但不需要自己判断cell是否为空；当cell为空时，运行时会自动从你注册的方法创建cell；
    ASDTableViewCell *cell = (ASDTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
     */
    
    ASDTableViewModel *model = [self.mDatasource modelAtIndex:indexPath.row];
    [cell setWithIndex:indexPath.row model:model delegate:self];
    
    NSLog(@"+++xxx%ld:%p",(long)indexPath.row,cell);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}


//MARK:-Acions

- (void)ASDTableViewCell:(id)cell didSelectRow:(NSInteger)index{
    ASDTableViewModel *model = [self.mDatasource modelAtIndex:index];
    [model.player play];
}


- (void)onBak{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)dealloc{
    NSLog(@"++++ASDTableViewController deallocled~");
}
@end
