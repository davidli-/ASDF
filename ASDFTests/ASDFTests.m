//
//  ASDFTests.m
//  ASDFTests
//
//  Created by Macmafia on 2018/11/23.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ASDFTests : XCTestCase

@end

@implementation ASDFTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testAsynExample {
    //1.模拟异步请求的情况
    XCTestExpectation *exp = [self expectationWithDescription:@"这里可以是操作出错的原因描述。。。"];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要2秒后才能获取结果，比如一个异步网络请求
        sleep(2);
        //模拟获取的异步操作后，获取结果，判断异步方法的结果是否正确
        XCTAssertEqual(@"a", @"a");
        //如果断言没问题，就调用fulfill宣布测试满足
        [exp fulfill];//调用fulfill后 waitForExpectationsWithTimeout 会结束等待
    }];
    
    //设置延迟多少秒后，如果没有满足测试条件就报错
    [self waitForExpectationsWithTimeout:3 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

-(void)testAsynWithPredicate{
    //2.模拟异步的案例,使用“NSPredicate”
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(UIButton  *button, NSDictionary<NSString *,id> *bindings) {
        return [button imageForState:UIControlStateNormal] == nil;
    }];
    UIButton *button;
    [self expectationForPredicate:predicate evaluatedWithObject:button handler:^BOOL{
        return  YES;
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

@end
