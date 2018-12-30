//
//  ASDFCollectionViewHorizontalBaseFlowLayout.m
//  ASDF
//
//  Created by Macmafia on 2018/12/29.
//  Copyright © 2018 Macmafia. All rights reserved.
//

#import "ASDFCollectionViewHorizontalBaseFlowLayout.h"

@implementation ASDFCollectionViewHorizontalBaseFlowLayout

- (void)prepareLayout{
    //计算item总个数
    self.mAllColumn = [self.collectionView numberOfItemsInSection:0];
}
@end
