//
//  Target_ASDFAvatorViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/8/25.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "Target_ASDFAvatorViewController.h"
#import "ASDFKeyForCTMediatorParameters.h"

@interface Target_ASDFAvatorViewController ()

@end

@implementation Target_ASDFAvatorViewController

- (ASDFAvatorViewController*)Action_showAvator:(NSDictionary*)param
{
    UIImage *image = param[kImage];
    ASDFAvatorViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                    instantiateViewControllerWithIdentifier:@"ASDFAvatorViewController"];
    vc.image = image;
    
    return vc;
}

@end
