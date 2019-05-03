//
//  ASDFChatMessage.m
//  ASDF
//
//  Created by Macmafia on 2019/5/3.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDFChatMessage.h"
#import "ASDFTextMaker.h"

@implementation ASDFChatMessage

- (YYTextLayout *)layout{
    if (!_layout) {
        _layout = [YYTextLayout layoutWithContainer:self.container text:self.attributedText];
    }
    return _layout;
}

- (YYTextContainer *)container{
    if (!_container) {
        _container = [YYTextContainer new];
        _container.size = CGSizeMake(self.width, CGFLOAT_MAX);
        _container.insets = UIEdgeInsetsMake(5, 10, 5, 10);
        _container.maximumNumberOfRows = 0;
        _container.truncationType = YYTextTruncationTypeEnd;
    }
    return _container;
}

- (NSMutableAttributedString *)createAttributedText{
    if (!_attributedText) {
        _attributedText = [ASDFTextMaker makeTextWithNick:_name message:_message link:_link];
    }
    return _attributedText;
}


- (CGFloat)calHight{
    if (0 == _height) {
        _height = self.layout.textBoundingSize.height;
    }
    return _height;
}

@end
