//
//  ASDYYLabelTableViewCell.m
//  ASDF
//
//  Created by Macmafia on 2019/5/3.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDYYLabelTableViewCell.h"
#import "ASDFTextMaker.h"

@implementation ASDYYLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)configureWithChatMessage:(ASDFChatMessage *)message
{
    if (_isCongigured) {
        return;
    }
    
    _label.displaysAsynchronously = YES;
    _label.ignoreCommonProperties = YES;
    _label.preferredMaxLayoutWidth = self.size.width;
    _label.textLayout = message.layout;
    
    _isCongigured = YES;
}
@end
