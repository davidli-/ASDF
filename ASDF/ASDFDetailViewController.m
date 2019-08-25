//
//  ASDFDetailViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/8/23.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFDetailViewController.h"
#import "BackButton.h"

@interface ASDFDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nName;
@property (weak, nonatomic) IBOutlet UILabel *mSex;
@property (weak, nonatomic) IBOutlet UILabel *mAge;
@property (weak, nonatomic) IBOutlet UILabel *mDescription;
@property (weak, nonatomic) IBOutlet UITextView *mTextview;

@end

@implementation ASDFDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onDone{
    [self.mTextview resignFirstResponder];
     DetailReturnBlock block = _userInfo[kDetailBlock];
    block(_mTextview.text);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.mTextview resignFirstResponder];
}

- (void)setUI{
    BackButton *btn = [[BackButton alloc] initWithBackType:BACK_BTN_TYPE_TEXT
                                                    images:nil text:@"Back" target:self
                                                  selector:@selector(onBack)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    BackButton *btn2 = [[BackButton alloc] initWithBackType:BACK_BTN_TYPE_TEXT
                                                    images:nil text:@"Done" target:self
                                                  selector:@selector(onDone)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    _nName.text = _userInfo[kName];
    _mSex.text = _userInfo[kSex];
    _mAge.text = _userInfo[kAge];
    _mDescription.text = _userInfo[kDescription];
}

- (void)dealloc{
    NSLog(@"++++ASDFDetailViewController dealloced~");
}
@end
