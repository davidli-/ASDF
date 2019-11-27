//
//  MattASXViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/11/22.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "MattASXViewController.h"

@interface MattASXViewController ()
@property (nonatomic, strong) ASDisplayNode *displayNode;
@property (nonatomic, strong) ASImageNode *imgNode;
@property (nonatomic, strong) ASTextNode *textNode;
@end

@implementation MattASXViewController

- (instancetype)init {
    
    _displayNode = [[ASDisplayNode alloc] init];
    _imgNode = [[ASImageNode alloc] init];
    _imgNode.image = [UIImage imageNamed:@"1"];
    _textNode = [[ASTextNode alloc] init];
    _textNode.attributedText = [[NSAttributedString alloc] initWithString:@"Hello AS~"
                                                               attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    
    self = [super initWithNode:_displayNode];
    if (self) {
        // [_displayNode addSubnode:_imgNode];
        // [_displayNode addSubnode:_imgNode];
        _displayNode.automaticallyManagesSubnodes = YES;
        
        // 必须在init方法中设置.layoutSpecBlock属性，其他地方无效
        __weak typeof(self) wself = self;
        _displayNode.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            __strong typeof(wself) sself = wself;
            sself.imgNode.style.preferredSize = CGSizeMake(50, 50);
            ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical 
                                                                                   spacing:10 
                                                                            justifyContent:ASStackLayoutJustifyContentCenter 
                                                                                alignItems:ASStackLayoutAlignItemsCenter 
                                                                                  children:@[sself.imgNode,sself.textNode]];
            ASCenterLayoutSpec *centerSpec = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                                                        sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                                                                child:stackSpec];
            return centerSpec;
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _displayNode.backgroundColor = [UIColor orangeColor];
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

@end
