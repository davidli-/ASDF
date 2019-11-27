//
//  MattASCellNode.m
//  ASDF
//
//  Created by Macmafia on 2019/11/20.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "MattASCellNode.h"

@interface MattASCellNode ()
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *detailNode;
@property (nonatomic, strong) ASNetworkImageNode *iconNode;
@end


@implementation MattASCellNode

- (instancetype)initWithIndexPath:(NSIndexPath*)indexPath{
    self = [super init];
    if (self) {
        // 图标
        _iconNode = [[ASNetworkImageNode alloc] init];
        _iconNode.URL = [NSURL URLWithString:@"https://davidlii.nos-eastchina1.126.net/pic_icon_netease%403x.png"];
        //_iconNode.image = [UIImage imageNamed:@"1"]; // 使用本地图片
        
        // 标题
        _titleNode = [[ASTextNode alloc] init];
        _titleNode.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Index:%ld",indexPath.row]
                                                                  attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                                               NSFontAttributeName: [UIFont systemFontOfSize:15]}];
        
        // 详情
        _detailNode = [[ASTextNode alloc] init];
        _detailNode.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, ~.~"
                                                                  attributes:@{NSForegroundColorAttributeName: [UIColor orangeColor],
                                                                               NSFontAttributeName: [UIFont systemFontOfSize:15]}];
        /*
                [self addSubnode:_iconNode];
                [self addSubnode:_titleNode];
                [self addSubnode:_detailNode];*/
        
        self.automaticallyManagesSubnodes = YES; // 此属性=YES时，上面三个add操作就不需要了，子Node具体现实与否要根据-layoutSpecThatFits中的布局而定。
        /*If flag is YES the node no longer require addSubnode: or removeFromSupernode method calls. The presence or absence of subnodes is completely determined in its layoutSpecThatFits: method.*/
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    // 图标的预设尺寸
    _iconNode.style.preferredSize = CGSizeMake(50, 50);
    
    // 标题和详情文本作为一个整体，被组合到Stack视图中，二者呈上下分布
    ASStackLayoutSpec *rightStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                spacing:10
                                                                         justifyContent:ASStackLayoutJustifyContentStart
                                                                             alignItems:ASStackLayoutAlignItemsStretch
                                                                               children:@[_titleNode,_detailNode]];
    // 图标和rightStackSpec作为一个整体，被组合到一个Stack视图中，二者呈左右分布
    ASStackLayoutSpec *contentStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal 
                                                                                  spacing:20 
                                                                           justifyContent:ASStackLayoutJustifyContentStart
                                                                               alignItems:ASStackLayoutAlignItemsStretch
                                                                                 children:@[_iconNode,rightStackSpec]];
    // 为以上所有元素设置距离cell的间距
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 20, 10, 20) child:contentStackSpec];

    return insetSpec;
}
@end
