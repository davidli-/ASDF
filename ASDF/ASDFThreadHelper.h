//
//  ASDFThreadHelper.h
//  ASDF
//
//  Created by Macmafia on 2018/12/21.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDFThreadHelper : NSObject

-(NSThread *)getThread;
- (void)finish;
-(instancetype)initWithName:(NSString*)name;
@end

NS_ASSUME_NONNULL_END
