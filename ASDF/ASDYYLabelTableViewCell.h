//
//  ASDYYLabelTableViewCell.h
//  ASDF
//
//  Created by Macmafia on 2019/5/3.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"
#import "ASDFChatMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDYYLabelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YYLabel *label;
@property (nonatomic, assign) BOOL isCongigured;

- (void)configureWithChatMessage:(ASDFChatMessage*)message;

@end

NS_ASSUME_NONNULL_END
