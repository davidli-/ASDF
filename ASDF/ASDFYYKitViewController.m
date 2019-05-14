//
//  ASDFYYKitViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/5/3.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFYYKitViewController.h"
#import "YYKit.h"
#import "Masonry.h"
#import "ASDYYLabelTableViewCell.h"
#import "ASDFTextMaker.h"
#import "ASDFYYDatasource.h"

@interface ASDFYYKitViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *mBtn;
@property (nonatomic, strong) YYTextView *mYYTextView;

@property (nonatomic, strong) ASDFYYDatasource *mDatasource;

@end

@implementation ASDFYYKitViewController


-(ASDFYYDatasource *)mDatasource
{
    if (!_mDatasource) {
        _mDatasource = [[ASDFYYDatasource alloc] initWithWidth:_mTableView.size.width];
    }
    return _mDatasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //FIXME:YYTextView必须延迟加载 否则会闪退；在故事板中拖一个YYTextView也一样会闪退
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addYYTextView];
    });
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

// MARK:-Tableview Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mDatasource numberOfRows];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASDFChatMessage *mess = [self.mDatasource chatMessAtIndexPath:indexPath];
    return mess.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ASDYYLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ASDFChatMessage *mess = [self.mDatasource chatMessAtIndexPath:indexPath];
    [cell configureWithChatMessage:mess];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


//MARK:- 延时加载YYTextView
- (void)addYYTextView{
    _mYYTextView = [[YYTextView alloc] init];
    [self.view addSubview:_mYYTextView];
    
    [_mYYTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([UIApplication sharedApplication].statusBarFrame.size.height);
        make.bottom.equalTo(_mBtn.mas_top).offset(-20);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    _mYYTextView.backgroundColor = [UIColor yellowColor];
    _mYYTextView.editable = NO;
    _mYYTextView.attributedText = [ASDFTextMaker makeText];
}
@end
