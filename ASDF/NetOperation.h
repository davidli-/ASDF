//
//  NetOperation.h
//  ASDF
//
//  Created by Macmafia on 2017/11/17.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NetOperation;
//代理协议
@protocol NetOperationDelegate<NSObject>

- (void)downloadFinishedWithData:(id)data;

@end



@interface NetOperation : NSOperation

- (instancetype)initWithUrl:(NSString *)url delegate:(id<NetOperationDelegate>)delegate;

@end
