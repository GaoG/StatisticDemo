//
//  UICollectionView+CollectEvent.h
//  StatisticDemo
//
//  Created by  GaoGao on 2020/2/20.
//  Copyright © 2020年  GaoGao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (CollectEvent)

- (void)swizzling_collectionViewDidSelectItemAtIndexPathInClass:(id)object;



@end

NS_ASSUME_NONNULL_END
