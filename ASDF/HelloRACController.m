//
//  HelloRACController.m
//  ASDF
//
//  Created by Macmafia on 2019/5/22.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "HelloRACController.h"
#import "ViewControllerII.h"
#import "ReactiveObjC.h"
#import "RACReturnSignal.h"

@interface HelloRACController ()

@property (weak, nonatomic) IBOutlet UITextView *mTextview;
@property (weak, nonatomic) IBOutlet UILabel *mLabel1;
@property (weak, nonatomic) IBOutlet UILabel *mLabel2;
@property (weak, nonatomic) IBOutlet UIButton *mBtn1;
@property (weak, nonatomic) IBOutlet UIButton *mBtn2;
@property (weak, nonatomic) IBOutlet UIButton *mBtn3;
@property (weak, nonatomic) IBOutlet UIButton *mBtn4;
@property (weak, nonatomic) IBOutlet UIButton *mBtn5;
@property (weak, nonatomic) IBOutlet UIButton *mBtn6;
@property (weak, nonatomic) IBOutlet UIButton *mBtn7;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) id<RACSubscriber> subscriber;

@end

@implementation HelloRACController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.信号的使用
    //1.1.创建信号，此时信号为冷信号，被订阅之后才能成为热信号并发送消息
    RACSignal *s1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //当有订阅者订阅信号，就会调用此block
        _subscriber = subscriber;
        
        //1.3.发送信号
        [subscriber sendNext:@"Hello from s1~"];
        
        //回抛错误
        [subscriber sendError:[NSError errorWithDomain:@"NetError" code:1022 userInfo:@{@"code":@(1022)}]];
        
        //如果不再发送数据，发送信号完成
        [subscriber sendCompleted];
        
        //返回一个信号，内部会自动调用[RACDisposable disposable]取消订阅信号。
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"++s1 Disposed~");
        }];
    }];
    
    //1.2.订阅信号(订阅后信号变为热信号，如果其内部有发送信号的操作，则此时subscribeNext的block被调用)
    [[[[s1 doNext:^(id  _Nullable x) {
        NSLog(@"+++do next!");
    }] doError:^(NSError * _Nonnull error) {
        NSLog(@"+++do error");
    }] doCompleted:^{
        NSLog(@"+++do complete");
    }] subscribeNext:^(id x) {
        NSLog(@"~~第1个订阅消息：%@",x);
    } error:^(NSError * error) {
        NSLog(@"+++error:%@",error.description);
    } completed:^{
        NSLog(@"++s1 completed");
    }];
    
    //第二次订阅
    [s1 subscribeNext:^(id x) {
        NSLog(@"~~第2个订阅消息：%@",x);
    } error:^(NSError * error) {
        NSLog(@"+++error:%@",error.description);
    } completed:^{
        NSLog(@"++s1 completed");
    }];
    
    //发送事件
    [_subscriber sendNext:@"Hello2 from s1~"];
    
    //1.4.连接类(单次订阅之后不会立刻收到回调，所有订阅完成后调用 connect 时才会先后触发)
    RACSignal *s2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"Hello from s2~"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"++s2 Disposed~");
        }];
    }];
    
    RACMulticastConnection *cnn = [s2 publish];
    
    //订阅连接类信号
    [cnn.signal subscribeNext:^(id x) {
        NSLog(@"~~第1个订阅消息：%@",x);
    }];

    [cnn.signal subscribeNext:^(id x) {
        NSLog(@"~~第2个订阅消息：%@",x);
    }];

    [cnn.signal subscribeNext:^(id x) {
        NSLog(@"~~第3个订阅消息：%@",x);
    }];

    [cnn connect];
    
    
    /**==========================================================================***/
    
    //2.监听按钮事件
    [[_mBtn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl *x) {
        NSLog(@"++clicked Btn1~");
    }];
    
    /**==========================================================================***/
    
    //3.监听通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification
                                                           object:nil]
     subscribeNext:^(NSNotification *x) {
         NSLog(@"++通知:%@",x);
    }];
    
    /**==========================================================================***/
    
    //5.KVO
    [[self rac_valuesAndChangesForKeyPath:@"text"
                                            options:NSKeyValueObservingOptionNew
                                           observer:self]
     subscribeNext:^(RACTwoTuple<id,NSDictionary *> *x) {
        NSLog(@"++self.text update:%@",x.first);
         self.mLabel2.text = self.text;
    }];
    
    //6.KVC
    [[self rac_valuesForKeyPath:@"text" observer:self] subscribeNext:^(id x) {
        NSLog(@"++++KVC new self.text:%@",x);
    }];
    
    /**==========================================================================***/
    
    //7.监听TextView的内容变化
    [self.mTextview.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"+++TextView:%@",x);
        //触发_text属性变化
        self.text = x; //注意：这里只能用self.text赋值，不能使用_text，因为_text赋值不会触发属性的变化；
    }];
    
    /**==========================================================================***/
    
    //8.监听对象变化
    //8.1.Textview内容变化后，label1的内容跟着变化
    RAC(self.mLabel1,text) = self.mTextview.rac_textSignal;

    //8.2.监听属性的变化
    [RACObserve(self, text) subscribeNext:^(id x) {
        NSLog(@"~~属性变化:%@",x);
    }];
}

//MARK:-Actions

- (IBAction)onAction2:(id)sender {
    
    /**==========================================================================***/
    //4.代理
    ViewControllerII *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                    instantiateViewControllerWithIdentifier:@"ViewControllerII"];
    //设置代理信号
    controller.delegate = [RACSubject subject];
    
    //订阅代理
    [controller.delegate subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onAction3:(id)sender {
    //调用代理
    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:)
                    fromProtocol:@protocol(UIAlertViewDelegate)]
     subscribeNext:^(RACTuple * x) {
        NSLog(@"++%@",x);
    }];
}

- (IBAction)onAction4:(id)sender {
    //bind的作用：订阅信号1并创建新的信号2，收到信号1的数据后，修改数据并通过新创建的信号2发送新数据)
    // 1.信号1
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 5.信号1发送数据1
        [subscriber sendNext:@"1"];
        return nil;
    }];
    // 2.信号2
    RACSignal *bindSignal2 = [signal1 bind:^RACSignalBindBlock{
        // 4.bind回调
        NSLog(@"+++This is BindBlock callback");
        RACSignalBindBlock aBindBlock = ^RACSignal*(id value, BOOL *stop){
            // 6.bindBlock内修改数据
            NSLog(@"+++ori value:%@",value);
            value = @"2";
            return [RACReturnSignal return:value];// 信号3
        };
        return aBindBlock;
    }];
    // 3.订阅信号2
    [bindSignal2 subscribeNext:^(id x) {
        // 7.接收数据
        NSLog(@"++++bindSignal return Value:%@",x);
    }];
}

- (IBAction)onAction5:(id)sender {
    // concat: concat左边的在前，右边的在后，按照前后顺序左右分别触发一次新信号订阅者回调
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal1 block");
        [subscriber sendNext:@"1.1"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"1.2"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal2 block");
        [subscriber sendNext:@"2.1"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"2.2"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    RACSignal *signal3 = [signal1 concat:signal2];
    [signal3 subscribeNext:^(id x) {
        NSLog(@"+++++received data:%@",x);
    }];
}

- (IBAction)onAction6:(id)sender {
    // then：信号1先执行，信号2后执行,最后只获取信号2的数据
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 1
        NSLog(@"+++call signal1 block");
        [subscriber sendNext:@"1.1"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"1.2"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
        // 3
        NSLog(@"+++call signal2 block");
        [subscriber sendNext:@"2.1"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"2.2"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *signal3 = [signal1 then:^RACSignal * {
        // 2
        NSLog(@"++++call signal3 then");
        return signal2;
    }];
    
    [signal3 subscribeNext:^(id x) {
        // 4
        NSLog(@"++++received data:%@",x);
    }];
}

- (IBAction)onAction7:(id)sender {
    // merge 谁先sendNext就先收到谁的数据
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal1 block");
        [subscriber sendNext:@"1.1"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"1.2"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal2 block");
        [subscriber sendNext:@"2.1"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"2.2"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *signal3 = [RACSignal merge:@[signal1,signal2]];
    
    [signal3 subscribeNext:^(id x) {
        NSLog(@"+++++received data:%@",x);
    }];
}

- (IBAction)onAction8:(id)sender {
    // zip: 合并n个信号的值到一个元组中，哪个信号在前哪个信号的值就在元组中靠前
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal1 block");
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal2 block");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"2.1"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"2.2"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *signal3 = [RACSignal zip:@[signal1,signal2]];
    
    [signal3 subscribeNext:^(id x) {
        NSLog(@"+++++received data:%@",x);
    }];
}

- (IBAction)onAction9:(id)sender {
    //
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal1 block");
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal2 block");
        [subscriber sendNext:@"2.1"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"2.2"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal3 block");
        [subscriber sendNext:@"3.1"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"3.2"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *signal4 = [RACSignal combineLatest:@[signal1,signal2,signal3]];
    
    [signal4 subscribeNext:^(id x) {
        NSLog(@"+++++received data:%@",x);
    }];
}

- (IBAction)onAction10:(id)sender {
    // reduce
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal1 block");
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal2 block");
        [subscriber sendNext:@"2.1"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"2.2"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *signal3 = [RACSignal combineLatest:@[signal1,signal2]
                                           reduce:^(NSString *str1, NSString *str2){
                                               return [@[str1,str2] componentsJoinedByString:@"+"];
                                           }];
    
    [signal3 subscribeNext:^(id x) {
        NSLog(@"+++++received data:%@",x);
    }];
}

- (IBAction)onAction11:(id)sender {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal1 block");
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signal2 = [signal1 flattenMap:^__kindof RACSignal * (id value) {
        NSLog(@"+++%@",value);
        return [RACSignal return:value];
    }];
    
    [signal2 subscribeNext:^(id  _Nullable x) {
        NSLog(@"+++%@",x);
    }];
}

- (IBAction)onAction12:(id)sender {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"+++call signal1 block");
        [subscriber sendNext:@(1)];
        [subscriber sendNext:@(2)];
        [subscriber sendNext:@(3)];
        [subscriber sendCompleted];
        return nil;
    }];
    [[signal1 flattenMap:^RACSignal *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            return nil;
        }];
    }] subscribeNext:^(id x) {
        NSLog(@"+++received Value:%@",x);
    }];
}

- (IBAction)onAction13:(id)sender {
    
}

- (IBAction)onAction14:(id)sender {
    //1.创建信号
    RACSignal *s1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //^didSubscribe中执行任务
        return [RACDisposable disposableWithBlock:^{
            //清理资源
        }];
    }];
    //2.订阅信号
    [s1 subscribeNext:^(id x) {
        NSLog(@"+++received value:%@",x);
    }];
}



//MARK:- Business

@end
