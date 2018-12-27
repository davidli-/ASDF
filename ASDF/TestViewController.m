//
//  TestViewController.m
//  ASDF
//
//  Created by Macmafia on 2017/12/22.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "TestViewController.h"
#import "DataTaskTool.h"

@interface TestViewController ()<DataTaskToolDelegate>
@property (nonatomic, strong) DataTaskTool *mTool;
@end

@implementation TestViewController

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    NSLog(@"TestViewController dealloced!");
}
#pragma mark DataTaskToolDelegate

- (void)dataTaskTool:(DataTaskTool *)tool onDownloadFailedWithError:(NSError *)error
{
    NSLog(@"++++下载失败");
}

- (void)dataTaskTool:(DataTaskTool *)tool onDownloadFinishedWithInfo:(id)info
{
    NSLog(@"++++下载完成");
}

- (void)dataTaskTool:(DataTaskTool *)tool onDownloadProgress:(double)progress
{
    NSLog(@"++++当前进度：%f",progress);
}


#pragma mark -Button Actions
- (IBAction)start:(id)sender
{
    DataTaskTool *tool = [[DataTaskTool alloc] initWithURL:@"https://software-download.microsoft.com/db/Win10_1709_Chinese(Simplified)_x32.iso?t=e56bdb47-6973-4da2-9e94-5a6a458c9192&e=1513964531&h=d9ba28ed1645810206cd89e7c4675a5b" delegate:self];
//    [tool start];
    _mTool = tool;
}

- (IBAction)pause:(id)sender
{
    [_mTool pause];
}

- (IBAction)resume:(id)sender
{
    [_mTool resume];
}

- (IBAction)cancel:(id)sender
{
    [_mTool cancel];
}

#pragma mark -Restoration Delegate
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents coder:(NSCoder *)coder
{
    UIStoryboard *storyboard = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    TestViewController *vc = (TestViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TestViewController"];
    vc.restorationIdentifier = [identifierComponents lastObject];
    vc.restorationClass = [TestViewController class];
    return vc;
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder{
    [super decodeRestorableStateWithCoder:coder];
}

@end
