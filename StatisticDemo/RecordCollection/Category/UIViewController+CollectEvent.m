//
//  UIViewController+CollectEvent.m
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import "UIViewController+CollectEvent.h"
#import "NSObject+RuntimeMethodHelper.h"
#import "CollectionManager.h"

@implementation UIViewController (CollectEvent)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 替换方法
//        [self sel_exchangeFirstSel:@selector(viewDidLoad) secondSel:@selector(wf_viewDidLoad)];viewDidAppear
        [self sel_exchangeFirstSel:@selector(viewDidAppear:) secondSel:@selector(wf_viewDidAppear:)];
        [self sel_exchangeFirstSel:@selector(viewWillDisappear:) secondSel:@selector(wf_viewWillDisappear:)];
        
    });
}




//新的viewDidAppear方法
- (void)wf_viewDidAppear:(BOOL)animated {
    
    [self wf_viewDidAppear:animated];
    if ([self  isKindOfClass:[UIViewController class]]) {
        
        NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        
        NSLog(@"OPEN----->控制器标题:%@------当前恐控制器名称:%@------>进来的时间:%@",self.title,NSStringFromClass([self class]),timeStr);
        
        if ([[CollectionManager sharedManager]isCollectPage:NSStringFromClass([self class])]) {
            [CollectionManager sharedManager].tempControllerName = NSStringFromClass([self class]);
            [CollectionManager sharedManager].beginTime = timeStr;
        }
        
    }
    
}

//新的viewWillDisappear方法
- (void)wf_viewWillDisappear:(BOOL)animated {
    
    [self wf_viewWillDisappear:animated];
    if ([self  isKindOfClass:[UIViewController class]]) {
        
        NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        
        NSLog(@"CLOSE----->控制器标题:%@------当前恐控制器名称:%@------>离开的时间:%@",self.title,NSStringFromClass([self class]),timeStr);
        if ([[CollectionManager sharedManager]isCollectPage:NSStringFromClass([self class])]) {
            [[CollectionManager sharedManager]savePageData:NSStringFromClass([self class]) withTitle:self.title withEndTime:timeStr];
            
        }
    }
}





@end
