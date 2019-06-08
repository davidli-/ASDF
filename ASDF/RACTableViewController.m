//
//  RACTableViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/5/26.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "RACTableViewController.h"
#import "RACTableViewCell.h"
#import "RACTableViewModel.h"
#import "ReactiveObjC.h"

@interface RACTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) RACTableViewModel *mViewModel;
@property (nonatomic, strong) UIRefreshControl *mRrefreshControl;

@end

@implementation RACTableViewController

//MARK:- Lazy load
- (UITableView *)mTableView{
    if (!_mTableView) {
        
        _mTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mTableView.tableFooterView = [UIView new];
        _mTableView.backgroundColor = [UIColor lightGrayColor];
        [_mTableView registerClass:[RACTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _mTableView;
}

- (RACTableViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel = [[RACTableViewModel alloc] init];
    }
    return _mViewModel;
}

- (UIRefreshControl *)mRrefreshControl{
    if (!_mRrefreshControl) {
        _mRrefreshControl = [[UIRefreshControl alloc] init];
        _mRrefreshControl.tintColor = [UIColor whiteColor];
    }
    return _mRrefreshControl;
}

//MARK:- LifrCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self RACBinder];
    [self dataBinder];
}

- (void)dealloc {
    NSLog(@"+++%@ %s!",[self class],__func__);
}

//MARK:- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (([self.mViewModel numOfRows] > 0) ? 1 : 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mViewModel numOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RACTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[RACTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    RACModel *model = [self.mViewModel dataAtIndexPath:indexPath];
    cell.textLabel.text = model.title ? model.title : [NSString stringWithFormat:@"x%ld",indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//MARK:- Business

- (void)setupUI{
    [self.view addSubview:self.mTableView];
    [self.mTableView addSubview:self.mRrefreshControl];
}

- (void)RACBinder{
    
    @weakify(self);
    [[self.mRrefreshControl rac_signalForControlEvents:UIControlEventValueChanged]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSLog(@"++refreshControl 触发~");
        //声明请求参数
        RACTuple *paramsTuple = [RACTuple tupleWithObjects:@(1),@(20), nil];//元组第一个对象表示页码，第二个表示每页数量
        //发起请求
        [[self.mViewModel.fetchCommand execute:paramsTuple] subscribeNext:^(id x) {
            NSLog(@"+++请求回调数据!!!!!");
        } error:^(NSError * _Nullable error) {
            NSLog(@"++%@",error.description);
        } completed:^{
            NSLog(@"+++刷新操作完成!!!!!");
        }];
         /*command默认不允许并发执行，并发执行command时会报错。
        [[self.mViewModel.fetchCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            NSLog(@"++++再次回调数据？？");
        } error:^(NSError * _Nullable error) {
            NSLog(@"++++%@",error.description);
        }];
        */
    }];
    
    //设置返回按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"返回" forState:UIControlStateNormal];
    [btn1 sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    [[[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside]
      flattenMap:^RACSignal *(UIControl *value) {
          RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
              @strongify(self);//一定要强引用一下，否则VC不会销毁
              [self.navigationController popViewControllerAnimated:YES];
              [subscriber sendNext:@"++Poped~"];
              [subscriber sendCompleted];
              return nil;
          }];
        return signal2;
    }]
     subscribeNext:^(id x) {
        NSLog(@"+++Mess:%@",x);
    }];
    
    //设置刷新按钮
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"刷新" forState:UIControlStateNormal];
    [btn2 sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    RACSignal *mEnableSignal = [RACObserve(self.mViewModel, isRefresh)
                                map:^id (id value) {
                                    return @(![value boolValue]);
    }];
    
    btn2.rac_command = [[RACCommand alloc] initWithEnabled:mEnableSignal
                                               signalBlock:^RACSignal *(id input) {
                                                   @strongify(self);
                                                   //business
                                                   NSLog(@"++stop");
                                                   [self.mRrefreshControl endRefreshing];
                                                   RACSignal *signalFetch = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                                       //called when subscribed
                                                       NSLog(@"++");
                                                       //声明请求参数
                                                       RACTuple *paramsTuple = [RACTuple tupleWithObjects:@(1),@(20), nil];//元组第一个对象表示页码，第二个表示每页数量
                                                       //发起请求
                                                       CGFloat deltY = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
                                                       [self.mTableView setContentOffset:CGPointMake(0, -(deltY + 60)) animated:YES];
                                                       [self.mRrefreshControl beginRefreshing];
                                                       [[self.mViewModel.fetchCommand execute:paramsTuple] subscribeNext:^(id  _Nullable x) {
                                                           NSLog(@"+++fetchCommand executed!");
                                                       }];
                                                       [subscriber sendCompleted];
                                                       
                                                       return [RACDisposable disposableWithBlock:^{
                                                       }];
                                                   }];
                                                   return signalFetch;
                                               }];
    //监听cell点击代理的调用
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)
                    fromProtocol:@protocol(UITableViewDelegate)]
     subscribeNext:^(RACTuple *tuple) {
         NSIndexPath *indexPath = tuple.last;
         NSLog(@"+++select row:%ld",indexPath.row);
     }];
}

- (void)dataBinder{
    
    @weakify(self);
    //监听VM中属性的变化 更新界面
    /*RACObserve是y基于KVC的，且默认选项是 NSKeyValueObservingOptionInitial，所以监听后会自动回调一次，
    *我们需要的是后续刷新后重新赋的值，所以跳过第一次*/
    [[RACObserve(self.mViewModel, shouldReload) skip:1] subscribeNext:^(id reload) {
        @strongify(self);
        if ([reload boolValue]) {
            [self.mTableView reloadData];
            [self.mRrefreshControl endRefreshing];
            CGFloat deltY = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
            [self.mTableView setContentOffset:CGPointMake(0, -deltY) animated:YES];
        }
    }];
}
@end
