//
//  Student.h
//  ASDF
//
//  Created by Macmafia on 2018/8/28.
//  Copyright © 2018年 Macmafia. All rights reserved.
//

#import "Person.h"

@interface Student : Person<NSCoding>
@property (nonatomic, assign) int sID;
@end
