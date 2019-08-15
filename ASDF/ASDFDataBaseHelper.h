//
//  ASDFDataBaseHelper.h
//  ASDF
//
//  Created by Macmafia on 2019/8/2.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDFDataBaseHelper : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (instancetype)shareInstance;
- (void)saveContext;

@end

NS_ASSUME_NONNULL_END
