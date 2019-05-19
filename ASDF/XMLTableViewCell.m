//
//  XMLTableViewCell.m
//  ASDF
//
//  Created by Macmafia on 2019/5/20.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "XMLTableViewCell.h"

@implementation XMLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setWithFood:(Food*)food {
    _name.text = food.name;
    _price.text = food.price;
    _calories.text = food.calories;
    _descript.text = food.descript;
}
@end
