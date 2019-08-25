//
//  ASDFAvatorViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/8/23.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFAvatorViewController.h"
#import "BackButton.h"

@interface ASDFAvatorViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mPhoto;
@end

@implementation ASDFAvatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.mPhoto.image = self.image;
}

- (void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUI{
    BackButton *btn = [[BackButton alloc] initWithBackType:BACK_BTN_TYPE_TEXT
                                                    images:nil text:@"Back" target:self
                                                  selector:@selector(onBack)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (void)dealloc{
    NSLog(@"++++ASDFAvatorViewController dealloced~");
}
@end
