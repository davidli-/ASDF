//
//  ViewControllerII.m
//  ASDF
//
//  Created by Macmafia on 2017/7/25.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "ViewControllerII.h"

@interface ViewControllerII ()

@end

@implementation ViewControllerII

- (void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
