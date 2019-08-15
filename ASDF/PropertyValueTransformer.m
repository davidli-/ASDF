//
//  PropertyValueTransformer.m
//  ASDF
//
//  Created by Macmafia on 2019/8/2.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "PropertyValueTransformer.h"

@implementation PropertyValueTransformer

@end


// 数组转Data
@implementation ArrayToDataValueTransformer

+ (Class)transformedValueClass{
    return [NSArray class];
}

+ (BOOL)allowsReverseTransformation{
    return YES;
}

// 将数组对象转换成data
- (id)transformedValue:(id)value{
    if (value == nil) {
        return nil;
    }
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

// 将data反过来转换成数组对象
- (id)reverseTransformedValue:(id)value{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end



// 图片转Data
@implementation ImageToDataValueTransformer

+ (Class)transformedValueClass {
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

// 将teacher_avator图片转成data
- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    return UIImagePNGRepresentation(value);
}

// 将data转成teacher_avator图片
- (id)reverseTransformedValue:(id)value {
    return [UIImage imageWithData:(NSData *)value];
}

@end
