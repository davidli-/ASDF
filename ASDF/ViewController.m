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
#import <HealthKit/HealthKit.h>
#import "CustomLayer.h"
#import "CustomView.h"
#import "AnimateClickedView.h"
#import "MainThreadStuckedObserverTool.h"
#import "TestViewController.h"

static void *mAssociateObjKey = &mAssociateObjKey;

@interface ViewController ()<UIAlertViewDelegate,CALayerDelegate>
{
    int aInt;
    int count;
}
@property (nonatomic, strong) HKHealthStore *healthStore;
@property(nonatomic, copy) NSString *HAHAH;
@property (nonatomic, strong) AnimateClickedView *animateView;
@property (nonatomic, strong) CustomLayer *mSublayer;
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

//    _mSublayer = [[CustomLayer alloc] init];
//    _mSublayer.delegate = self;
//    _mSublayer.backgroundColor = [UIColor whiteColor].CGColor;
//    _mSublayer.frame = CGRectMake(100, 300, 100, 100);
//    [self.view.layer addSublayer:_mSublayer];
//    [_mSublayer setNeedsDisplay];//调用此方法触发重绘
    
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
//    [MainThreadStuckedObserverTool monitorBussy];

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

- (IBAction)onHandle1:(id)sender {
    TestViewController *viewControler2 = [[UIStoryboard storyboardWithName:@"Main"
                                                                  bundle:[NSBundle mainBundle]]
                                        instantiateViewControllerWithIdentifier:@"TestViewController"];
    [self presentViewController:viewControler2 animated:YES completion:^{
    }];
}

- (IBAction)onHandle2:(id)sender {
    NSArray *childs = [self childViewControllers];
    UIViewController *viewControler = childs[0];
    
     TestViewController*viewControler2 = [[UIStoryboard storyboardWithName:@"Main"
                                                                  bundle:[NSBundle mainBundle]]
                                        instantiateViewControllerWithIdentifier:@"TestViewController"];
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

#pragma mark -Business

- (void)showAlert
{
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"Title"
                                                                            message:@"This is Mess"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSString *associateObj = objc_getAssociatedObject(alertControler, mAssociateObjKey);
        NSLog(@"++++关联对象：%@",associateObj);
        objc_setAssociatedObject(alertControler, mAssociateObjKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        NSString *associateObj2 = objc_getAssociatedObject(alertControler, mAssociateObjKey);
        NSLog(@"++++移除关联对象后：%@",associateObj2);
    }];
    [alertControler addAction:action];
    
    objc_setAssociatedObject(alertControler, mAssociateObjKey, @"This is a string obj", OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self presentViewController:alertControler animated:YES completion:^{
    }];
}

- (void)testLayer{
    //ShapeLayer
    //    CAShapeLayer *layer = [CAShapeLayer layer];
    //    layer.frame = CGRectMake(0, 300, 200, 200);
    //    layer.backgroundColor = [UIColor whiteColor].CGColor;
    //    layer.lineWidth = 2;
    //    layer.fillColor = [UIColor blueColor].CGColor;
    //    layer.strokeColor = [UIColor blackColor].CGColor;
    //
    //    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:layer.bounds];
    //    layer.path = path.CGPath;
    //
    //    [self.view.layer addSublayer:layer];
    
    //通过mask添加圆角
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 200, 200)];
    view.backgroundColor = [UIColor whiteColor];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.frame = view.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                               byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight |UIRectCornerBottomLeft)
                                                     cornerRadii:CGSizeMake(20, 20)];
    layer.path = path.CGPath;
    view.layer.mask = layer;
    [self.view addSubview:view];
    
    //    CustomLayer *layer = [[CustomLayer alloc] init];
    //    layer.backgroundColor = [UIColor clearColor].CGColor;
    //    layer.frame = CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height);
    //    [self.view.layer addSublayer:layer];
    //    [layer setNeedsDisplay];//调用此方法触发重绘
    
    //    CustomView *view = [[CustomView alloc] init];
    //    view.backgroundColor = [UIColor whiteColor];
    //    view.frame = CGRectMake(0, 300, 300, 300);
    //    [self.view addSubview:view];
}
@end
