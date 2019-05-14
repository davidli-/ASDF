//
//  ASDTableViewCell.h
//  ASDF
//
//  Created by Macmafia on 2019/5/13.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASDTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ASDTableViewCell;

@protocol ASDTableViewCellDelegate <NSObject>

- (void)ASDTableViewCell:(ASDTableViewCell*)cell didSelectRow:(NSInteger)index;

@end

@interface ASDTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id <ASDTableViewCellDelegate>delegate;

- (void)setWithIndex:(NSInteger)index model:(ASDTableViewModel*)model delegate:(id<ASDTableViewCellDelegate>)dele;
@end

NS_ASSUME_NONNULL_END
