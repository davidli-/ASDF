//
//  ASDTableViewModel.m
//  ASDF
//
//  Created by Macmafia on 2019/5/13.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDTableViewModel.h"

@implementation ASDTableViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        //默认值
        _nowTime = @"00:00";
        _remain = @"00:00";
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = self.player.status;
        if (status == AVPlayerStatusReadyToPlay) {
            
            double timeT = CMTimeGetSeconds(self.player.currentItem.duration);
            if (isnan(timeT)) {
                return;
            }
            int minute = timeT / 60.0;
            int second = [[NSNumber numberWithDouble:timeT] intValue] % 60;
            _remain = [NSString stringWithFormat:@"%d:%d",minute,second];
        }
    }
}

@end
