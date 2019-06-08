//
//  ViewControllerII.m
//  ASDF
//
//  Created by Macmafia on 2017/7/25.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "ViewControllerII.h"
#import "ASDNotificationCenter.h"

@interface ViewControllerII ()

@end

@implementation ViewControllerII

- (void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[ASDNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:@"ANotification" object:@"Hello"];
//    [[ASDNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:@"ANotification" object:@"Hello"];
}
- (void)onNotification:(id)notification
{
//    id obj = notification.object;
    NSLog(@"");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
}

-(void)viewWillLayoutSubviews{
    
}

-(void)viewDidLayoutSubviews{
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


-(void)dealloc{
    NSLog(@"ViewControllerII dealloced!");
}

//-(void)willMoveToParentViewController:(UIViewController *)parent{
//    
//}
//
//-(void)didMoveToParentViewController:(UIViewController *)parent{
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)onDismiss:(id)sender
{
    //RAC回调
    if (self.delegate) {
        [self.delegate sendNext:@"++ViewControllerII Closed~"];
    }
    //关闭
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
