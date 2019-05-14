//
//  ASDTableViewModel.h
//  ASDF
//
//  Created by Macmafia on 2019/5/13.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDTableViewModel : NSObject

@property (nonatomic, assign) NSInteger index;  //当前资源对应的行号
@property (nonatomic, strong) AVPlayer *player; //播放器实例
@property (nonatomic, copy) NSString *nowTime;  //当前n播放时间 使用字符串可解决每次更新文本时的开销
@property (nonatomic, copy) NSString *remain;   //资源剩余可播放时长
@property (nonatomic, assign) BOOL observed;    //是否监听过了

@end

NS_ASSUME_NONNULL_END
