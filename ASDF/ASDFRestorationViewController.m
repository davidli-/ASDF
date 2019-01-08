//
//  ASDFRestorationViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/1/8.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFRestorationViewController.h"

@interface ASDFRestorationViewController ()

@end

@implementation ASDFRestorationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -Restoration Delegate
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents
                                                            coder:(NSCoder *)coder
{
    UIStoryboard *storyboard = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    ASDFRestorationViewController *vc = (ASDFRestorationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ASDFRestorationViewController"];
    vc.restorationIdentifier = [identifierComponents lastObject];
    vc.restorationClass = [ASDFRestorationViewController class];
    return vc;
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder{
    [super decodeRestorableStateWithCoder:coder];
}
@end
