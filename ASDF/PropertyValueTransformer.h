//
//  PropertyValueTransformer.h
//  ASDF
//
//  Created by Macmafia on 2019/8/2.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PropertyValueTransformer : NSObject

@end
NS_ASSUME_NONNULL_END


// 数组转Data
@interface ArrayToDataValueTransformer : NSValueTransformer

@end



// 图片转Data
#import <UIKit/UIKit.h>

@interface ImageToDataValueTransformer : NSValueTransformer

@end

