//
//  ASDFCoreDataViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/8/2.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFCoreDataViewController.h"
#import "CoreDataSourse.h"

@interface ASDFCoreDataViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
CoreDataSourseDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) CoreDataSourse *dataSource;

@end

@implementation ASDFCoreDataViewController

- (CoreDataSourse *)dataSource{
    if (!_dataSource) {
        _dataSource = [[CoreDataSourse alloc] init];
        _dataSource.delegate = self;
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"分页" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(onFetchPage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"增加" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 sizeToFit];
    [btn2 addTarget:self action:@selector(onAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh setTintColor:[UIColor orangeColor]];
    [refresh addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    self.mTableView.refreshControl = refresh;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource dataNumberOfDataArr];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Course *c = [self.dataSource modelAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)c.id];
    cell.detailTextLabel.text = c.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

/*
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 5) {
        return UITableViewCellEditingStyleInsert;
    }else if (indexPath.row > 5 && indexPath.row < 10){
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
*/


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                  editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *act1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * action, NSIndexPath * indexPath) {
        NSLog(@"+++删除数据:%ld",indexPath.row);
        [self.dataSource removeDataAtIndex:indexPath.row];
    }];

    return @[act1];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataSource updateDataAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[_mDataArr removeObjectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"++++delete style");
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        //[_mDataArr addObject:@(indexPath.row)];
        //[tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        NSLog(@"++++insert style");
    }else{
        NSLog(@"++++none style");
    }
}

#pragma  mark -CoreDataSource Delegate

- (void)dataSourcesDidInsertDataAtIndex:(NSUInteger)index{
    [self.mTableView reloadData];
}

- (void)dataSourcesDidDeleteDataAtIndex:(NSUInteger)index{
    NSIndexPath *indexPath = [self indexPathWithIndex:index];
    [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSourcesDidUpdateDataAtIndex:(NSUInteger)index{
    NSIndexPath *indexPath = [self indexPathWithIndex:index];
    [self.mTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSourcesDidReceiveAllData:(NSArray *)dataArr{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mTableView reloadData];
        [self.mTableView.refreshControl endRefreshing];
    });
}

- (void)dataSourcesLoadLimitedData{
    [self.mTableView reloadData];
}

#pragma mark - BUSINESS

- (void)onFetchPage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择分页" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSUInteger page = [[alert.textFields firstObject].text integerValue];
        [self.dataSource loadDataAtPage:page];
    }];
    
    //页数
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"页数";
    }];
    
    [alert addAction:action];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)onAdd{
    [self.dataSource insertData];
    NSLog(@"++新增数据");
}


- (void)onRefresh{
    [self.dataSource asynchronousFetchRequest];
}

- (NSIndexPath*)indexPathWithIndex:(NSUInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return indexPath;
}

@end
