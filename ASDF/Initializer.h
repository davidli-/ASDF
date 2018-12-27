//
//  Initializer.h
//  ASDF
//
//  Created by Macmafia on 2017/12/23.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN int aGlobalInt;
UIKIT_EXTERN NSString *className;
UIKIT_EXTERN NSMutableDictionary *paramDic;

@interface Initializer : NSObject
{
    NSString *aTitle;
    NSDate   *aDate;
}

//- (instancetype)init NS_UNAVAILABLE;//此标志代表：不希望调用父类(NSObject)的这个 Designated Initializer

- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title
                         date:(NSDate*)date NS_DESIGNATED_INITIALIZER;//此标志代表：Designated Initializer

@end
