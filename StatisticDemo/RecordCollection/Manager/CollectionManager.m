//
//  CollectionManager.m
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import "CollectionManager.h"
#import "NSObject+RuntimeMethodHelper.h"
#import "StorageManager.h"
#import "PageModel.h"
#import "EventModel.h"
// 外部文件
//#import "WFLocationData.h"
//#import "NSString+Regular.h"
//#import "WKRequest.h"

// 手机系统
#define PhoneVersion  [UIDevice currentDevice].systemVersion

#define CollectionPageListPath [[NSBundle mainBundle] pathForResource:@"CollectionPageList" ofType:@"plist"]

#define CollectionEventListPath [[NSBundle mainBundle] pathForResource:@"CollectionEventList" ofType:@"plist"]


static CollectionManager *_collectionManager = nil;

@interface CollectionManager ()<StorageManagerDelagete>

/** 配置页面字典  pagename 和pagetitle 对应*/
@property (nonatomic, strong, nullable) NSDictionary *pageConfigDic;
/** 配置页面数组  所有配置页面的name 数组*/
@property (nonatomic, strong, nullable) NSArray *pageConfigArray;
/** 配置事件字典*/
@property (nonatomic, strong, nullable) NSDictionary *eventConfigDic;
/** 配置 事件目标 数组*/
@property (nonatomic, strong, nullable) NSArray *eventTargetConfigArr;
/** pageModel*/
@property (nonatomic, strong, nullable) PageModel *pageModel;
/** eventModel*/
@property (nonatomic, strong, nullable) EventModel *eventModel;



@end
@implementation CollectionManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _collectionManager = [[CollectionManager alloc] init];
        _collectionManager.uploadDataCount = 10;
        // 设置代理
        [StorageManager sharedManager].delegate = _collectionManager;
    });
    return _collectionManager;
}


/** 保存页面数据 */
- (void)savePageData:(NSString *)pageName withTitle:(NSString *)pageTitle withEndTime:(NSString *)endTime; {
    
    if ([pageName isEqualToString:self.tempControllerName]) {
        
        self.pageModel = [PageModel new];
        self.pageModel.startTime = self.beginTime;
        self.pageModel.pageName = pageName;
        self.pageModel.title = [self getConfigPageTitle:pageName];
        self.pageModel.endTime = endTime;
//        外部文件
//        self.pageModel.latitude = [NSString stringWithFormat:@"%f",[WFLocationData shareInstace].latitude];
//        self.pageModel.longitude = [NSString stringWithFormat:@"%f",[WFLocationData shareInstace].longitude];
        
        [[StorageManager sharedManager]saveData:[NSKeyedArchiver archivedDataWithRootObject:self.pageModel] withType:1];
        
    }
    
}

/** 保存事件数据*/
- (void)saveEventData:(NSString *)eventId withTargetName:(NSString *)eventTarget withBeginTime:(NSString *)time; {
    
    self.eventModel = [EventModel new];
    self.eventModel.eventName = [self getConfigEventTitle:eventTarget andEventId:eventId];
    self.eventModel.eventId = eventId;
    self.eventModel.time = time;
//    外部文件
//    self.eventModel.latitude = [NSString stringWithFormat:@"%f",[WFLocationData shareInstace].latitude];
//    self.eventModel.longitude = [NSString stringWithFormat:@"%f",[WFLocationData shareInstace].longitude];
    [[StorageManager sharedManager]saveData:[NSKeyedArchiver archivedDataWithRootObject:self.eventModel] withType:2];

    
}



#pragma mark - StorageManagerDelagete
/** 接收 页面统计数据和 事件 统计数据*/
- (void)inceptPageData:(NSArray *)pageArray andeEventData:(NSArray *)eventArray;{
    // 判断如果 数据数量大于等于 数据上传数量 就上传数据
    if(pageArray.count + eventArray.count >= self.uploadDataCount){
            // 数据上传
        [self upLoadPageData:pageArray andEventData:eventArray];
        
        // 删除数据
        [self deletePageData:pageArray andeEventData:eventArray];
    }
    
    
}


/** 删除数据*/
- (void)deletePageData:(NSArray *)pageArray andeEventData:(NSArray *)eventArray;{
    
    [[StorageManager sharedManager]deletePageData:pageArray andeEventData:eventArray];
}


/**页面是否需要被统计*/
-(BOOL)isCollectPage:(NSString *)pageName;{
    
    return [self.pageConfigArray containsObject:pageName];
    
}

/**事件是否需要被统计*/
-(BOOL)isCollectEvent:(NSString *)eventId andTarget:(NSString *)targetName;{
    
    
    if (![self.eventTargetConfigArr containsObject:targetName]) {
        return NO;
    }else{
        
        return [[[self.eventConfigDic objectForKey:targetName] allKeys] containsObject:eventId];
    }
    
}


/**数据上传*/
- (void)upLoadPageData:(NSArray *)pageData andEventData:(NSArray *)eventData;{
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
                NSMutableArray *pageArr = [NSMutableArray array];
                NSMutableArray *eventArr = [NSMutableArray array];
                for (NSData *data in pageData) {
                    self.pageModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [pageArr addObject:[self.pageModel wf_dicFromObjectPropertyString]];
                }
                for (NSData *data in eventData) {
                    self.eventModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [eventArr addObject:[self.eventModel wf_dicFromObjectPropertyString]];
                }
//                外部文件
                NSDictionary *dataDic = @{
                                          @"provider":@"YZC",
                                          @"platform":@"iOS",
//                                          @"phoneModel":[NSString getCurrentDeviceModel],
//                                          @"phoneVersion":PhoneVersion,
                                          @"pages":pageArr,
                                          @"events":eventArr,
                                          };
                
//                [WKRequest postWithURLString:@"http://dev.jx9n.cn:10001/yzc-collect-data/yzc/v1/collect/app/data" parameters:dataDic isJson:YES isShowHud:NO success:^(WKBaseModel *baseModel) {
//
//                } failure:^(NSError *error) {
//
//                }];
            
            });
    
    
}



/** 根据页面的name获取页面的标题  如果获去不到为@"" */
-(NSString *)getConfigPageTitle:(NSString *)name;{
    
    return [self.pageConfigDic objectForKey:name] ? [self.pageConfigDic objectForKey:name] : @"";
    
}

/** 根据事件目标和事件id 获取事件的标题  如果获去不到为@"" */
-(NSString *)getConfigEventTitle:(NSString *)targetNme andEventId:(NSString *)eventId {
    
    NSDictionary *dic = [self.eventConfigDic objectForKey:targetNme];
    
    if (dic) {
       
        return [dic objectForKey:eventId] ? [dic objectForKey:eventId] : @"";
    }
    return @"";
    
    
    
}


- (NSArray *)pageConfigArray {
    if (!_pageConfigArray) {
        _pageConfigArray = [self.pageConfigDic allKeys];
    }
    
    return _pageConfigArray;
}

-(NSArray *)eventTargetConfigArr{
    
    if (!_eventTargetConfigArr) {
        
        _eventTargetConfigArr = [self.eventConfigDic allKeys];
    }
    
    return _eventTargetConfigArr;
}

-(NSDictionary *)pageConfigDic{
    
    if (!_pageConfigDic) {
        _pageConfigDic = [[NSDictionary alloc]initWithContentsOfFile:CollectionPageListPath];
    }
    
    return _pageConfigDic;
    
}


-(NSDictionary *)eventConfigDic {
    if (!_eventConfigDic) {
        
      _eventConfigDic =  [[NSDictionary alloc]initWithContentsOfFile:CollectionEventListPath];

    }
    
    return _eventConfigDic;
}




@end
