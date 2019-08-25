//
//  Target_ASDFDetailViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/8/25.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "Target_ASDFDetailViewController.h"
#import "ASDFKeyForCTMediatorParameters.h"

@interface Target_ASDFDetailViewController ()

@end

@implementation Target_ASDFDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (ASDFDetailViewController*)Action_showDetail:(NSDictionary*)param
{
    ASDFDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                    instantiateViewControllerWithIdentifier:@"ASDFDetailViewController"];
    vc.userInfo = param;
    
    return vc;
}
@end
