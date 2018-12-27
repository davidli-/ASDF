//
//  DataTaskTool.m
//  ASDF
//
//  Created by Macmafia on 2017/12/21.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "DataTaskTool.h"

@interface DataTaskTool ()
<
NSURLConnectionDataDelegate
>
{
    NSMutableURLRequest *mRequest; //请求对象
    NSURLConnection *mUrlConnection; //连接对象
    NSFileHandle *mFileHandle; //文件管理
    NSString *mFilePath; //沙盒文件路径
    unsigned long long mTotalContentLength; //文件总长度
    unsigned long long mCurrentContentLength; //当前接收到的数据总长度
    double mProgressValue; //当前下载进度值
}

@property (nonatomic, weak) id <DataTaskToolDelegate> delegate;

@end

@implementation DataTaskTool


- (instancetype)initWithURL:(NSString*)URL delegate:(id<DataTaskToolDelegate>)delegate
{
    if (self = [super init])
    {
        if (0 == URL.length) {
            return nil;
        }
        _delegate = delegate;
        
        //设置请求
        mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];
        mRequest.HTTPMethod = @"GET";
        mRequest.timeoutInterval = 60;
        
        //创建连接对象
        mUrlConnection = [[NSURLConnection alloc] initWithRequest:mRequest delegate:self];
    }
    return self;
}


#pragma mark -NSURLConnectionDataDelegate
//接收到服务器的响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    mTotalContentLength = response.expectedContentLength;
    
    //设置文件路径
    NSString *fileName = response.suggestedFilename;
    NSString* caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    mFilePath = [caches stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:mFilePath])
    {
        [[NSFileManager defaultManager] createFileAtPath:mFilePath contents:nil attributes:nil];
    }
    mFileHandle = [NSFileHandle fileHandleForWritingAtPath:mFilePath];
}

//接收到服务器返回的数据（此方法可能会回调多次）
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //移动到文件的结尾
    [mFileHandle seekToEndOfFile];
    //新数据追加到文件中
    [mFileHandle writeData:data];
    
    //计算当前下载进度
    mCurrentContentLength += data.length;
    mProgressValue = (double)mCurrentContentLength / mTotalContentLength;
    
    //回调进度
    [_delegate dataTaskTool:self onDownloadProgress:mProgressValue];
}

//下载完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //结束写入
    [mFileHandle closeFile];
    NSError *error = [NSError new];
    [[NSFileManager defaultManager] removeItemAtPath:mFilePath error:&error];
    
    //完成回调
    [_delegate dataTaskTool:self onDownloadFinishedWithInfo:nil];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_delegate dataTaskTool:self onDownloadFailedWithError:error];
}

#pragma mark -BUSINESS
//开始请求
- (void)start
{
    [mUrlConnection start];
}

//暂停
- (void)pause
{
    [mUrlConnection cancel];
    mUrlConnection = nil;
}

//恢复
- (void)resume
{
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-", mCurrentContentLength];
    [mRequest setValue:range forHTTPHeaderField:@"Range"];
    mUrlConnection = [[NSURLConnection alloc] initWithRequest:mRequest delegate:self];
    [mUrlConnection start];
}

//取消请求
- (void)cancel
{
    [mUrlConnection cancel];
}

@end
