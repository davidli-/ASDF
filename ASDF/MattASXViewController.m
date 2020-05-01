//
//  MattASXViewController.m
//  ASDF
//
//  Created by Macmafia on 2019/11/22.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "MattASXViewController.h"
#import <POP.h>

@interface MattASXViewController ()<POPAnimationDelegate>
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
    [_textNode addTarget:self action:@selector(onClickedText) forControlEvents:ASControlNodeEventTouchUpInside];
    [_imgNode addTarget:self action:@selector(touchDown:) forControlEvents:ASControlNodeEventTouchDown];

    // 添加手势
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_imgNode.view addGestureRecognizer:recognizer];
    
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

//MARK:  Gestures
- (void)touchDown:(UIControl *)sender {
    [sender.layer pop_removeAllAnimations];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // 拖拽
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                     recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

    // 拖拽动作结束
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        // 计算出移动的速度
        CGPoint velocity = [recognizer velocityInView:self.view];

        // 衰退减速动画
        POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];

        // 设置代理
        positionAnimation.delegate = self;

        // 设置速度动画
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];

        // 添加动画
        [recognizer.view.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
}


- (void)onClickedText{
    // 执行Spring动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.toValue             = [NSValue valueWithCGPoint:CGPointMake(1.5f, 1.5f)];
    anim.springSpeed         = 0.f;
    [_textNode.layer pop_addAnimation:anim forKey:@"ScaleXY"];
}
@end
