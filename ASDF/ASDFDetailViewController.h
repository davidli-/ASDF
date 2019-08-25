//
//  ASDFDetailViewController.h
//  ASDF
//
//  Created by Macmafia on 2019/8/23.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASDFKeyForCTMediatorParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDFDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, copy) DetailReturnBlock _Nullable detailBlock;

@end

NS_ASSUME_NONNULL_END
