//
//  SubModel.m
//  ASDF
//
//  Created by Macmafia on 2018/11/13.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "SubModel.h"

@implementation SubModel

-(id)copyWithZone:(NSZone *)zone
{
    SubModel *newSubModel = [super copyWithZone:zone];
    newSubModel.subName = [self.subName copy];
    
    return newSubModel;
}

@end
