//
//  Person.m
//  ASDF
//
//  Created by Macmafia on 2017/11/25.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize name = _name;

////解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ([super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
    }
    return self;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    if ([key isEqualToString:@"name"]) {
        return NO;
    }
    return YES;
}

- (NSString *)name{
    return _name;
}

-(void)setName:(NSString *)name{
    
    if ([name isEqualToString:@"David"]) {
        [self willChangeValueForKey:@"name"];
        _name = name;
        [self didChangeValueForKey:@"name"];
    }else{
        _name = name;
    }
}

-(void)dealloc{
//    NSLog(@"++++PERSON IS DEALLOCED~");
}
@end

