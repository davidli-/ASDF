//
//  ASDClickTableViewCell.h
//  ASDF
//
//  Created by Macmafia on 2019/6/27.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASDInCellBtn.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASDClickTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet ASDInCellBtn *clickBtn;

@end

NS_ASSUME_NONNULL_END
