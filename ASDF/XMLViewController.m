//
//  XMLViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/5/20.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "XMLViewController.h"
#import "XMLTool.h"
#import "XMLTableViewCell.h"

@interface XMLViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *mTableView;

@end

@implementation XMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[XMLTool shareInstance] start];
    
    _mTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mTableView.tableFooterView = [UIView new];
    
    [_mTableView registerNib:[UINib nibWithNibName:@"XMLTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_mTableView];
    
    _mTableView.frame = self.view.frame;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[XMLTool shareInstance] numOfDatasource] > 0 ? 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[XMLTool shareInstance] numOfDatasource];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"++++cell 为nil~~");
    }
    Food *food = [[XMLTool shareInstance] dataAtIndexPath:indexPath];
    [cell setWithFood:food];
    
    return cell;
}
@end
