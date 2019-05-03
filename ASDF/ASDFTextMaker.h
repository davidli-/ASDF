//
//  ASDFTextMaker.h
//  ASDF
//
//  Created by Macmafia on 2019/5/3.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDFTextMaker : NSObject

+ (NSMutableAttributedString*)makeTextWithNick:(NSString*)name message:(NSString*)message link:(NSString*)link;
+ (NSMutableAttributedString*)makeText;

@end

NS_ASSUME_NONNULL_END
