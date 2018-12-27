//
//  Student.m
//  ASDF
//
//  Created by Macmafia on 2018/8/28.
//  Copyright © 2018年 Macmafia. All rights reserved.
//

#import "Student.h"

@implementation Student

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.sID = [aDecoder decodeIntForKey:@"sID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInt:self.sID forKey:@"sID"];
}
@end
