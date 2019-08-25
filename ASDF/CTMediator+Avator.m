//
//  CTMediator+Avator.m
//  ASDF
//
//  Created by Macmafia on 2019/8/24.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "CTMediator+Avator.h"
#import "ASDFKeyForCTMediatorParameters.h"

@implementation CTMediator (Avator)

- (UIViewController*)showAvator:(UIImage*)image
{
    return [self performTarget:@"ASDFAvatorViewController"
                 action:@"showAvator"
                 params:@{kImage:image}
      shouldCacheTarget:NO];
}

@end
