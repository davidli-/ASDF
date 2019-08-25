//
//  CTMediator+Detail.m
//  ASDF
//
//  Created by Macmafia on 2019/8/25.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "CTMediator+Detail.h"

@implementation CTMediator (Detail)

- (UIViewController*)showDetail:(NSDictionary*)info
{
    return [self performTarget:@"ASDFDetailViewController"
                        action:@"showDetail"
                        params:info
             shouldCacheTarget:NO];
}
@end
