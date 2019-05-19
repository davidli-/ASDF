//
//  Food.m
//  ASDF
//
//  Created by Macmafia on 2019/5/19.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "Food.h"
#import "RuntimeTool.h"
#import <objc/runtime.h>

@interface Food()
@property (nonatomic, strong) NSMutableArray *mIvars;
@end

@implementation Food

- (NSMutableArray *)mIvars{
    if (!_mIvars) {
        
        _mIvars = [NSMutableArray array];
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        
        for (int i = 0; i<count; i++){
            Ivar ivar = ivars[i];
            const char *charName = ivar_getName(ivar);
            NSString *name = [NSString stringWithCString:charName encoding:NSUTF8StringEncoding];
            if (name) {
                name = [name stringByReplacingOccurrencesOfString:@"_" withString:@""];
                [_mIvars addObject:name];
            }
        }
        free(ivars);
    }
    return _mIvars;
}

- (void)f_setValue:(nullable id)value forKey:(NSString *)key {
    
    if (![self.mIvars containsObject:key]) {
        return;
    }
    [self setValue:value forKey:key];
}


@end
