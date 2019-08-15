//
//  ASDFUITests.m
//  ASDFUITests
//
//  Created by Macmafia on 2018/11/23.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ASDFUITests : XCTestCase

@end

@implementation ASDFUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    /*
    XCUIElement *button1 = [[XCUIApplication alloc] init].buttons[@"1111"];///获取名字为1111的按钮
    XCTAssertTrue(button1.exists, @"'1111'按钮不存在");///#值为true才能通过，为false会停在这里
    [button1 tap];///触发按钮的点击事件
    */
    
    //运行应用后 点击XCode左下角红色按钮自动录制

    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [[[[[[[[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:3] tap];
    [app.navigationBars[@"RACTableView"].buttons[@"\u8fd4\u56de"] tap];
    [app.buttons[@"More Info"] tap];
    [app.navigationBars[@"ASDClickBtnInCellView"].buttons[@"Back"] tap];
    [app.buttons[@"\u6a21\u6001"] tap];
    [app.navigationBars[@"ASDTableView"].buttons[@"\u8fd4\u56de"] tap];
}

- (void)testPerformance{
    [self measureBlock:^{
    }];
}
@end
