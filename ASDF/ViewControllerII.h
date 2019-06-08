//
//  ViewControllerII.h
//  ASDF
//
//  Created by Macmafia on 2017/7/25.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACSubject.h"

@interface ViewControllerII : UIViewController

@property (nonatomic, strong) RACSubject *delegate;

@end
