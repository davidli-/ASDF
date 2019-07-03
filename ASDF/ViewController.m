//
//  ViewController.m
//  ASDF
//
//  Created by Macmafia on 2017/7/25.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerII.h"
#import "ASDFDownloadController.h"
#import "ASDFResponsibleLabel.h"
#import "ASDTableViewController.h"
#import "RACTableViewController.h"

static void *mAssociateObjKey = &mAssociateObjKey;

@interface ViewController ()<UIAlertViewDelegate,CALayerDelegate>

@property (weak, nonatomic) IBOutlet ASDFResponsibleLabel *mResponsibleLabel;
@property (weak, nonatomic) IBOutlet UIButton *mBtn3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //结构体
    struct ADate adate = {2019,05,10};
    adate.year = 2019;
    adate.month = 05;
    adate.day = 10;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

#pragma mark -Actions

- (IBAction)onHandleModel:(id)sender {
    ASDTableViewController *viewController = [[ASDTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:viewController animated:YES];
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
    RACTableViewController *controller = [[RACTableViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onHandle4:(id)sender {
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
