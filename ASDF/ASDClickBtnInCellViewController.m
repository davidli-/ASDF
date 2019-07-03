//
//  ASDClickBtnInCellViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/6/27.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDClickBtnInCellViewController.h"
#import "ASDClickTableViewCell.h"

@interface ASDClickBtnInCellViewController ()

@end

@implementation ASDClickBtnInCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASDClickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"+++++select row:%ld",indexPath.row);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
@end
