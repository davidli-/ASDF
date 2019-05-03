//
//  ViewController.m
//  ASDF
//
//  Created by Macmafia on 2017/7/25.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerII.h"
#import <objc/runtime.h>
#import "AnimateClickedView.h"
#import "ASDFDownloadController.h"
#import "ASDFResponsibleLabel.h"

static void *mAssociateObjKey = &mAssociateObjKey;

@interface ViewController ()<UIAlertViewDelegate,CALayerDelegate>
{
    int aInt;
    int count;
}
@property (nonatomic, strong) AnimateClickedView *animateView;
@property (weak, nonatomic) IBOutlet ASDFResponsibleLabel *mResponsibleLabel;
@property (weak, nonatomic) IBOutlet UIButton *mBtn3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    _animateView = [[AnimateClickedView alloc] init];
//    _animateView.backgroundColor = [UIColor redColor];
//    float size = 50;
//    uint32_t originX = arc4random() % (int)(self.view.frame.size.width - size);//视图x起点为随机数
//    _animateView.frame = CGRectMake(100, size, size, size);
//    [self.view addSubview:_animateView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark -CALayer Animate Delegate
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event{
    NSLog(@"++++属性:%@",event);
    return nil;
}

#pragma mark -Touch Delegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (aInt != 0) {
//        NSLog(@"++++MMMM:%@",NSStringFromCGPoint(_animateView.layer.modelLayer.frame.origin));
//        NSLog(@"++++PPPP:%@",NSStringFromCGPoint(_animateView.layer.presentationLayer.frame.origin));
//        NSLog(@"++++MMMMpppppp:%@",NSStringFromCGPoint(_animateView.layer.presentationLayer.modelLayer.frame.origin));
//        return;
//    }
//    aInt +=1;
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:2.0f];
//    [CATransaction setCompletionBlock:^{
//        _mSublayer.backgroundColor = [UIColor redColor].CGColor;
//    }];
//    CGAffineTransform transform = _mSublayer.affineTransform;
//    transform = CGAffineTransformRotate(transform, M_PI_2);
//    _mSublayer.affineTransform = transform;
//    [CATransaction commit];

//    _animateView.layer.position = CGPointMake(300, 600);
//    CABasicAnimation *animate = [CABasicAnimation animation];
//    animate.keyPath = @"position";
//    CGFloat midY = CGRectGetMidY(_animateView.frame);
//    animate.fromValue = [NSValue valueWithCGPoint:CGPointMake(50, midY)];
//    animate.toValue = [NSValue valueWithCGPoint:CGPointMake(50, midY + 200)];
//    animate.duration = 10;
//    animate.removedOnCompletion = NO;
//    animate.fillMode = kCAFillModeForwards;
//    [_animateView.layer addAnimation:animate forKey:@"k"];
    
    //创建路径
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:_animateView.center];//动画路径的起点为视图中心点
//    //路径中的控制点随机
//    CGFloat height = CGRectGetHeight(self.view.frame);
//    [path addCurveToPoint:CGPointMake(_animateView.frame.origin.x, height)
//            controlPoint1:CGPointMake(0, arc4random() % (int)(height / 4.0))
//            controlPoint2:CGPointMake(CGRectGetWidth(self.view.frame), height - 200)];
//    //创建动画
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    animation.path = path.CGPath;
//    animation.duration = 10;
//    animation.autoreverses = NO;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    //执行动画
//    [_animateView.layer addAnimation:animation forKey:@"HAPPY_NEW_YEAR_ANIMATION"];
}

#pragma mark -Actions

- (IBAction)onHandleModel:(id)sender {
    ASDFDownloadController *viewControler2 = [[UIStoryboard storyboardWithName:@"Main"
                                                                        bundle:[NSBundle mainBundle]]
                                              instantiateViewControllerWithIdentifier:@"ASDFDownloadController"];
    [self presentViewController:viewControler2 animated:YES completion:^{
    }];
}

- (IBAction)onHandle1:(id)sender {
    ViewControllerII *viewControler = [[UIStoryboard storyboardWithName:@"Main"
                                                                 bundle:[NSBundle mainBundle]]
                                       instantiateViewControllerWithIdentifier:@"ViewControllerII"];
    [self addChildViewController:viewControler];
    [viewControler didMoveToParentViewController:self];
    [viewControler.view setFrame:CGRectMake(0, 0, 375, 300)];
    [self.view addSubview:viewControler.view];
    
    //移除v子VC
    //[viewControler willMoveToParentViewController:self];//先调用will。。。参数为nil
    //[viewControler removeFromParentViewController];
}

- (IBAction)onHandle2:(id)sender {
    NSArray *childs = [self childViewControllers];
    UIViewController *viewControler = childs[0];
    
     ASDFDownloadController*viewControler2 = [[UIStoryboard storyboardWithName:@"Main"
                                                                  bundle:[NSBundle mainBundle]]
                                        instantiateViewControllerWithIdentifier:@"ASDFDownloadController"];
    [self addChildViewController:viewControler2];
    [viewControler2.view setFrame:CGRectMake(0, self.view.frame.size.height, 375, 300)];
    
    [self transitionFromViewController:viewControler toViewController:viewControler2 duration:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        viewControler2.view.frame = CGRectMake(0, self.view.frame.size.height - 300, 375, 300);
        } completion:^(BOOL finished) {
            if (finished) {
                [viewControler2 didMoveToParentViewController:self];
                [viewControler willMoveToParentViewController:nil];
                [viewControler removeFromParentViewController];
            }
        }];
}

- (IBAction)onHandle3:(id)sender {
   
}


#pragma mark -Business
- (UIViewController *)findSuperControllerForView:(UIView *)view
{
    UIViewController *resultController;

    for (UIView *next = view; next; next = [next superview]) {
        UIResponder *responder = [next nextResponder];
        NSLog(@"++++Class:%@",[responder class]);
        if ([responder isKindOfClass:[UIViewController class]]) {
            resultController = (UIViewController*)responder;
        }
    }
    NSLog(@"++++Equal Self?:%@",[resultController isEqual:self] ? @"YES" : @"NO");
    return resultController;
}
@end
