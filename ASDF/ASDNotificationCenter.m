//
//  ASDNotificationCenter.m
//  ASDF
//
//  Created by Macmafia on 2019/1/4.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ASDNotificationCenter.h"
#import "ASDNotificationModel.h"

@interface ASDNotificationCenter()
@property (nonatomic, strong) NSMutableDictionary *mObserverDic;
@end

static ASDNotificationCenter *mDefaultCenter;

@implementation ASDNotificationCenter

+ (instancetype)defaultCenter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mDefaultCenter = [[ASDNotificationCenter alloc] init];
    });
    return mDefaultCenter;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mDefaultCenter = [super allocWithZone:zone];
        mDefaultCenter.mObserverDic = [NSMutableDictionary dictionary];
    });
    return mDefaultCenter;
}

- (NSMutableDictionary *)mObserverDic{
    if (!_mObserverDic) {
        _mObserverDic = [NSMutableDictionary dictionary];
    }
    return _mObserverDic;
}

#pragma mark - OverWrite
- (void)addObserver:(id)observer selector:(SEL)aSelector
               name:(NSNotificationName)aName
             object:(id)anObject
{
    if (!observer || !aName.length) {
        return;
    }
    
    // 新建model对象
    ASDNotificationModel *model = [[ASDNotificationModel alloc] init];
    model.observer = observer;// [NSValue valueWithNonretainedObject:observer];//打破强引用 避免循环引用问题
    model.selector = aSelector;
    model.name = aName;
    model.object = anObject;
    
    //保存通知
    [self saveNotificationModel:model];
}

- (id<NSObject>)addObserverForName:(NSNotificationName)aName
                            object:(id)obj
                             queue:(NSOperationQueue *)queue
                        usingBlock:(void (^)(NSNotification *))block
{
    if (!aName.length || !queue || !block) {
        return nil;
    }
    
    // 新建model对象
    ASDNotificationModel *model = [[ASDNotificationModel alloc] init];
    model.name = aName;
    model.queue = queue;
    model.block = [block copy];
    
    //保存通知
    [self saveNotificationModel:model];
    
    return model;
}

- (void)postNotification:(NSNotification *)notification{
    
}

- (void)postNotificationName:(NSNotificationName)aName object:(id)anObject
{
    if (!aName) {
        return;
    }
    ASDNotificationModel *resultModel;
    NSMutableSet *modelsSet = self.mObserverDic[aName];
    for (ASDNotificationModel *model in modelsSet) {
        if ([model.name isEqualToString:aName] &&
            ((anObject && [anObject isEqual:model.object]) || (!anObject && !model.object))) {
            resultModel = model;
            break;
        }
    }
    if (!resultModel) {
        return;
    }
    //判断是通过哪种方式监听的通知
    if (resultModel.block) {
        NSOperationQueue *queue = resultModel.queue;
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            ASDNotification *notification = [[ASDNotification alloc] initWithName:aName object:nil userInfo:nil];
            resultModel.block(notification);
        }];
        [queue addOperation:operation];
    }else{
        [resultModel.observer performSelector:resultModel.selector withObject:resultModel.object];
    }
}

- (void)postNotificationName:(NSNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo{
    
}

#pragma mark -Self Business

- (void)saveNotificationModel:(ASDNotificationModel*)model
{
    //检测之前有无注册过此名称的通知
    NSMutableSet *modelsSet = self.mObserverDic[model.name];
    if (!modelsSet) {
        modelsSet = [NSMutableSet set];
    }
    if ([modelsSet containsObject:model]) {//已注册过相同名称 相同参数的通知，不再重复注册
        return;
    }
    //没有注册过，加入到观察对象的数组中
    [modelsSet addObject:model];
    self.mObserverDic[model.name] = modelsSet;
}
@end
