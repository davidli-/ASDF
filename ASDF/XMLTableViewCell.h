//
//  XMLTableViewCell.h
//  ASDF
//
//  Created by Macmafia on 2019/5/20.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMLTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *calories;
@property (weak, nonatomic) IBOutlet UILabel *descript;

- (void)setWithFood:(Food*)food;

@end

NS_ASSUME_NONNULL_END
