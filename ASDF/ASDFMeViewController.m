//
//  ASDFMeViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/8/23.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFMeViewController.h"
#import "CTMediator+Avator.h"
#import "CTMediator+Detail.h"
#import "ASDFKeyForCTMediatorParameters.h"

@interface ASDFMeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *mIconBtn;

@end

@implementation ASDFMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onClickAvator:(id)sender {
    UIViewController *vc = [[CTMediator sharedInstance] showAvator:_mIconBtn.currentBackgroundImage];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -Tableview Delegate & Datasourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        NSDictionary *dic = @{kName : @"Davidli",
                              kSex : @"男",
                              kAge : @"20",
                              kDescription : @"Hello, I'm Davidli~",
                              kDetailBlock : ^(NSString *text){
            // kDetailBlock 为block，作为DetailVc的代理，用于回抛数据
            self.title = [NSString stringWithFormat:@"%ld",text.length];
        }};
        
        UIViewController *vc = [[CTMediator sharedInstance] showDetail:dic];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
