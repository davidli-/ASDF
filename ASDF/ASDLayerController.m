//
//  ASDLayerController.m
//  ASDF
//
//  Created by Macmafia on 2019/1/8.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDLayerController.h"
#import "CustomLayer.h"
#import "CustomView.h"

@interface ASDLayerController ()
@property (weak, nonatomic) IBOutlet UIView *mLayerContainerView;
@property (weak, nonatomic) IBOutlet UIView *mContainer1;
@property (weak, nonatomic) IBOutlet UILabel *mFrameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *mAnchorLabel;
@property (strong, nonatomic) CALayer *layer;

@end

@implementation ASDLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLayer];
    [self customLayer];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -Actions

- (IBAction)onHandleAction:(id)sender {
    if (_layer.anchorPoint.x != 0) {
        _layer.anchorPoint = CGPointMake(0, 0);
    }else{
        //[0,1)之间的随机数
        float x = (float)(arc4random()%100) / 100 ;
        float y = (float)(arc4random()%100) / 100 ;
        _layer.anchorPoint = CGPointMake(x, y);
    }
    [self updateLabelText];
}

- (IBAction)onAction2:(id)sender {
    _layer.position = CGPointMake(0, 0);
    _layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self updateLabelText];
}

#pragma mark - Layer Setups
- (void)setUpLayer{
    
    _layer = [[CALayer alloc] init];
    _layer.backgroundColor = [UIColor blueColor].CGColor;
    _layer.bounds = CGRectMake(0, 0, 50, 50);
    [self.mLayerContainerView.layer addSublayer:_layer];
    
    [self updateLabelText];
}


#pragma mark - Self BUsiness
- (void)updateLabelText{
    _mFrameLabel.text = [NSString stringWithFormat:@"frame:{%.1f,%.1f,%.1f,%.1f}",_layer.frame.origin.x,_layer.frame.origin.y,_layer.frame.size.width,_layer.frame.size.height];
    _mPositionLabel.text = [NSString stringWithFormat:@"position:{%.1f,%.1f}",_layer.position.x,_layer.position.y];
    _mAnchorLabel.text = [NSString stringWithFormat:@"anchorpoint:{%.1f,%.1f}",_layer.anchorPoint.x,_layer.anchorPoint.y];
}

- (void)customLayer{
    //ShapeLayer
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = CGRectMake(20, 20, 50, 50);
    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    circleLayer.lineWidth = 2;
    circleLayer.fillColor = [UIColor yellowColor].CGColor;
    circleLayer.strokeColor = [UIColor whiteColor].CGColor;

    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleLayer.bounds];
    circleLayer.path = path.CGPath;

    [_mContainer1.layer addSublayer:circleLayer];
    
    
    //通过mask添加圆角
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(100, 20, 50, 50)];
    maskView.backgroundColor = [UIColor yellowColor];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer.frame = maskView.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskView.bounds
                                               byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                     cornerRadii:CGSizeMake(10, 10)];
    maskLayer.path = maskPath.CGPath;
    maskView.layer.mask = maskLayer;
    [_mContainer1 addSubview:maskView];

    //自定义Layer
    CustomLayer *layer = [[CustomLayer alloc] init];
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.frame = CGRectMake(180, 20, 150, 120);
    [_mContainer1.layer addSublayer:layer];
    [layer setNeedsDisplay];//调用此方法触发重绘
}
@end
