//
//  YYPerson.m
//  ASDF
//
//  Created by Macmafia on 2019/10/25.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "YYPerson.h"
#import <NSObject+YYModel.h>
#import "YYMan.h"
#import "YYWoman.h"

@implementation YYPerson

+ (Class)modelCustomClassForDictionary:(NSDictionary*)dictionary {
    NSNumber *sex = dictionary[@"sex"];
    if (sex.integerValue == 1) {
        return [YYMan class];
    }
    return [YYWoman class];
}
@end
