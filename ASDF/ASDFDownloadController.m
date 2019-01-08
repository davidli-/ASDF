//
//  ASDFDownloadController.m
//  ASDF
//
//  Created by Macmafia on 2019/1/8.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFDownloadController.h"
#import "DataTaskTool.h"

@interface ASDFDownloadController ()<DataTaskToolDelegate>
@property (nonatomic, strong) DataTaskTool *mTool;
@end

@implementation ASDFDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [tool start];
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

- (IBAction)onDismissAction:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
