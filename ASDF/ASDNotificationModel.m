//
//  ASDNotificationModel.m
//  ASDF
//
//  Created by Macmafia on 2019/1/6.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDNotificationModel.h"

@implementation ASDNotificationModel

- (BOOL)isEqualToNotificationModel:(ASDNotificationModel*)model
{
    if (!model) {
        return NO;
    }
    //观察者对象相同 且 通知名相同、参数相同时，认为二者相同
    BOOL isSameObserver = (self.observer && model.observer &&  [self.observer isEqual:model.observer]) || (!self.observer && model.observer);
    BOOL isSameName = (self.name && model.name &&  [self.name isEqualToString:model.name]) || (!self.name && model.name);
    BOOL isSameObject = (self.object && model.object &&  [self.object isEqual:model.object]) || (!self.object && model.object);
    
    if ( isSameObserver && isSameName && isSameObject) {
        return YES;
    }
    return NO;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToNotificationModel:object];
}

- (NSUInteger)hash{
    return [self.observer hash] ^ [self.name hash] ^ [self.object hash];
}
@end
