//
//  CollectionManager.h
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionManager : NSObject
/** 数据上传数量  默认10   */
@property (nonatomic, assign) NSInteger uploadDataCount;
/** 记录控制器的名字*/
@property (nonatomic, copy, nullable) NSString *tempControllerName;
/** 记录控制器的开始时间*/
@property (nonatomic, copy, nullable) NSString *beginTime;

/** 初始化方法*/
+ (instancetype)sharedManager;


/** 保存页面数据 */
-(void)savePageData:(NSString *)pageName withTitle:(NSString *)pageTitle withEndTime:(NSString *)endTime;


/** 保存事件数据*/
- (void)saveEventData:(NSString *)eventId withTargetName:(NSString *)eventTarget withBeginTime:(NSString *)time; ;


/**页面是否需要被统计*/
-(BOOL)isCollectPage:(NSString *)pageName;

/**事件是否需要被统计*/
-(BOOL)isCollectEvent:(NSString *)eventId andTarget:(NSString *)targetName;

@end

NS_ASSUME_NONNULL_END
