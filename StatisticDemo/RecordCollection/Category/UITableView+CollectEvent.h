//
//  UITableView+CollectEvent.h
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (CollectEvent)

- (void)swizzling_tableViewDidSelectRowAtIndexPathInClass:(id)object;


@end

NS_ASSUME_NONNULL_END
