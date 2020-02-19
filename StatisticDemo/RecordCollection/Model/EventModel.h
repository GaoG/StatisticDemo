//
//  EventModel.h
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventModel : NSObject <NSCoding , NSCopying>
/**事件名称*/
@property (nonatomic, copy, nullable)NSString* eventName;
/**事件id*/
@property (nonatomic, copy, nullable)NSString* eventId;
/**开始时间*/
@property (nonatomic, copy, nullable)NSString* time;
/**纬度*/
@property (nonatomic, copy, nullable)NSString* latitude;
/**经度*/
@property (nonatomic, copy, nullable)NSString* longitude;

@end

NS_ASSUME_NONNULL_END
