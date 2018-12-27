//
//  DataTaskTool.h
//  ASDF
//
//  Created by Macmafia on 2017/12/21.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataTaskTool;

@protocol DataTaskToolDelegate

- (void)dataTaskTool:(DataTaskTool*)tool onDownloadProgress:(double)progress;
- (void)dataTaskTool:(DataTaskTool*)tool onDownloadFinishedWithInfo:(id)info;
- (void)dataTaskTool:(DataTaskTool*)tool onDownloadFailedWithError:(NSError*)error;

@end

@interface DataTaskTool : NSObject

- (instancetype)initWithURL:(NSString*)URL delegate:(id<DataTaskToolDelegate>)delegate;
- (void)start;
- (void)pause;
- (void)resume;
- (void)cancel;

@end
