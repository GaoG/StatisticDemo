//
//  StorageManager.h
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol StorageManagerDelagete <NSObject>

@required
/** 接收 页面统计数据和 事件 统计数据*/
- (void)inceptPageData:(NSArray *)pageArray andeEventData:(NSArray *)eventArray;

@end

NS_ASSUME_NONNULL_BEGIN

@interface StorageManager : NSObject
/** 代理 */
@property (nonatomic, weak) id<StorageManagerDelagete> delegate;

/** 初始化方法*/
+ (instancetype)sharedManager;


/**保存数据 type 1 页面 2事件*/
- (void)saveData:(NSData *)data withType:(int)type;

/** 删除数据 */
- (BOOL)deletePageData:(NSArray *)pageArray andeEventData:(NSArray *)eventArray;
@end

NS_ASSUME_NONNULL_END
