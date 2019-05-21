//
//  AppDelegate.m
//  ASDF
//
//  Created by Macmafia on 2017/7/25.
//  Copyright © 2017年 Macmafia. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "ASDNotificationCenter.h"

@interface AppDelegate()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//        UIView *view;
//        CALayer;
//        CAAnimation;
//        CAPropertyAnimation;
//            CABasicAnimation;
//                CASpringAnimation;
//            CAKeyframeAnimation;
//        CATransition;
//        CAAnimationGroup;
//        NSCache;
//        NSURLCache;
//        CAShapeLayer;
    
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:1.0 green:96/255.0 blue:34/255.0 alpha:1];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:
                              [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"+++deviceToken:%@",deviceString);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"[DeviceToken Error]:%@\n",error.description);
}

- (void)registNotification
{
    //iOS10之后
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    //注册远端消息通知获取device token，如果只是本地推送则不需要注册，只需要设置并实现代理即可
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound |UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * error) {
                              if (!error && granted) {
                                  NSLog(@"注册成功");
                              }else{
                                  NSLog(@"注册失败");
                              }
                          }];
    //查询当前通知授权状况
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"+++%@",settings);
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //设置本地通知
    [self createLocalizedUserNotification];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createLocalizedUserNotification];
    });
}

- (void)createLocalizedUserNotification
{
    // 设置触发条件 UNNotificationTrigger
    UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60.0f repeats:YES];
    
    // 创建通知内容 UNMutableNotificationContent, 注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString stringWithFormat:@"title+%d",arc4random()%5];
    content.subtitle = [NSString stringWithFormat:@"subtitle"];
    content.body = @"body";
    content.badge = @2;
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{@"ID":@"value1",@"INFO":@"value2"};
    
    //创建通知标示
    NSString *identifier = [NSString stringWithFormat:@"%u",arc4random()%5];
    content.threadIdentifier = identifier;
    
    // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:timeTrigger];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    // 将通知请求 add 到 UNUserNotificationCenter
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"推送已添加成功 %@", identifier);
        }
    }];
/*
    //设置每周一的14点3分提醒
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekday = 2;
    components.hour = 16;
    components.minute = 3;
    [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    //设置基于位置的通知
    CLLocationCoordinate2D center1 = CLLocationCoordinate2DMake(39.788857, 116.5559392);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center1 radius:500 identifier:@"经海五路"];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
 */
}

#pragma mark -UNNOTIFICATION DELEGATE

//App处于前台接收通知时
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
    }else {
        // 判断为本地通知
        NSLog(@"收到本地通知:{\n body:%@，\n title:%@,\n subtitle:%@, \n badge：%@，\n sound：%@，\n userInfo：%@}",body,title,subtitle,badge,sound,userInfo);
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

//App通知的点击事件
-(void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
withCompletionHandler:(void (^)(void))completionHandler
{
    //这个代理方法，只会是用户点击消息才会触发，如果使用户长按（3DTouch）、Action等并不会触发。
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
    }else {
        // 判断为本地通知
        NSLog(@"点击了到本地通知:{\n body:%@，\n title:%@,\n subtitle:%@, \n badge：%@，\n sound：%@，\n userInfo：%@}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(); // 系统要求执行这个方法
}

#pragma mark-保存和恢复应用状态
-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return NO;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return NO;
}

-(void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder{
    
}

-(void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder{
    [[UIApplication sharedApplication] extendStateRestoration];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        
        // do any additional asynchronous initialization work here...
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // done asynchronously initializing, complete our state restoration
            //
            [[UIApplication sharedApplication] completeStateRestoration];
        });
    });
    
    // if you ever want to check for restore bundle version of user interface idiom, use this code:
    //
    //ask for the restoration version (used in case we have multiple versions of the app with varying UIs)
    // String with value of info.plist's Bundle Version (app version) when state was last saved for the app
    //
    NSString *restoreBundleVersion = [coder decodeObjectForKey:UIApplicationStateRestorationBundleVersionKey];
    NSLog(@"Restore bundle version = %@", restoreBundleVersion);
    
    // ask for the restoration idiom (used in case user ran used to run an iPhone version but now running on an iPad)
    // NSNumber containing the UIUSerInterfaceIdiom enum value of the app that saved state
    //
    NSNumber *restoreUserInterfaceIdiom = [coder decodeObjectForKey:UIApplicationStateRestorationUserInterfaceIdiomKey];
    NSLog(@"Restore User Interface Idiom = %ld", (long)restoreUserInterfaceIdiom.integerValue);
}
@end
