//
//  Person.h
//  ASDF
//
//  Created by Macmafia on 2017/11/25.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end

