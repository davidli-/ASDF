//
//  SessionTaskViewController.m
//  ASDF
//
//  Created by Macmafia on 2017/12/22.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "SessionTaskViewController.h"

//static NSString *url = @"https://picjumbo.imgix.net/HNCK8461.jpg?q=40&w=1650&sharp=30";

static NSString *url = @"https://software-download.microsoft.com/db/Win10_1709_Chinese(Simplified)_x32.iso?t=e56bdb47-6973-4da2-9e94-5a6a458c9192&e=1513964531&h=d9ba28ed1645810206cd89e7c4675a5b";

//static NSString *url = @"http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg";

@interface SessionTaskViewController ()
<
NSURLSessionDownloadDelegate
>
{
    NSURLSession *mURLSession;
    NSURLSessionDownloadTask *mDataTask;
}
@property (nonatomic, strong) NSData *mResumeData;

@end



@implementation SessionTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sendRequest];
}

#pragma mark -Acions

//开启任务
- (IBAction)start:(id)sender
{
    [mDataTask resume];
}

//挂起
- (IBAction)pause:(id)sender
{
    [mDataTask suspend];
}

//断点恢复
- (IBAction)resume:(id)sender
{
    mDataTask = [mURLSession downloadTaskWithResumeData:_mResumeData];
    [mDataTask resume];
}

//挂起恢复
- (IBAction)suspendResume:(id)sender
{
    [mDataTask resume];
}

//断点取消下载
- (IBAction)cancel:(id)sender
{
    [mDataTask cancelByProducingResumeData:^(NSData *resumeData) {
        _mResumeData = resumeData;
        mDataTask = nil;
        NSLog(@"++++取消时data长度：%lu",(unsigned long)_mResumeData.length);
    }];
}


//直接取消任务
- (IBAction)taskCancel:(id)sender
{
    [mDataTask cancel];
}


#pragma mark -Business
- (void)sendRequest
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 60;
    config.allowsCellularAccess = YES;
    mURLSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue new]];
    mDataTask = [mURLSession downloadTaskWithURL:[NSURL URLWithString:url]];
}

#pragma mark -NSURLSessionDownloadDelegate

//下载完成
-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
}

//每次写入沙盒完成后
-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"+++下载进度：%f",(double)totalBytesWritten/totalBytesExpectedToWrite);
}

//恢复下载后
-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"++++出错前data长度：%lu",(unsigned long)_mResumeData.length);
    _mResumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
    NSLog(@"++++出错后data长度：%lu",(unsigned long)_mResumeData.length);
}
@end
