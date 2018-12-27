//
//  Model.m
//  ASDF
//
//  Created by Macmafia on 2018/11/13.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "Model.h"

@implementation Model

- (id)copyWithZone:(NSZone *)zone
{
    NSLog(@"++++call Model copyWithZone~");
    Model *newModel = [[[self class] allocWithZone:zone] init];
    newModel.name = self.name;
    return newModel;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    NSLog(@"++++call Model mutableCopyWithZone~");
    Model *newModel = [[[self class] allocWithZone:zone] init];
    newModel.name = self.name;

    return newModel;
}
@end
