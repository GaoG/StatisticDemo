//
//  PageModel.h
//  StatisticDemo
//
//  Created by  GaoGao on 2020/2/14.
//  Copyright © 2020年  GaoGao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageModel : NSObject <NSCoding , NSCopying>
/**类名称*/
@property (nonatomic, copy, nullable)NSString* pageName;
/** 标题*/
@property (nonatomic, copy, nullable)NSString* title;
/**开始时间*/
@property (nonatomic, copy, nullable)NSString* startTime;
/**结束时间*/
@property (nonatomic, copy, nullable)NSString* endTime;
/**纬度*/
@property (nonatomic, copy, nullable)NSString* latitude;
/**经度*/
@property (nonatomic, copy, nullable)NSString* longitude;
@end

NS_ASSUME_NONNULL_END
