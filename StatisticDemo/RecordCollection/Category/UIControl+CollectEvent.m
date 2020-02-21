//
//  UIControl+CollectEvent.m
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import "UIControl+CollectEvent.h"
#import "NSObject+RuntimeMethodHelper.h"
#import "CollectionManager.h"
@implementation UIControl (CollectEvent)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //创建新的sendAction:to:forEvent:方法
        [self sel_exchangeFirstSel:@selector(sendAction:to:forEvent:) secondSel:@selector(wf_sendAction:to:forEvent:)];
        
    });
    
}


- (void)wf_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event {
    
    [self wf_sendAction:action to:target forEvent:event];
    
    
    NSLog(@"方法调用--->方法名:%@----->当前按钮:%@---->当前事件响应者:%@--->当前时间:%@",NSStringFromSelector(action), [self class],NSStringFromClass([target class]),[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]);
    //先判断是否在被统计的范围内
    if ([[CollectionManager sharedManager]isCollectEvent:NSStringFromSelector(action) andTarget:NSStringFromClass([target class])]) {
        
        [[CollectionManager sharedManager]saveEventData:NSStringFromSelector(action) withTargetName:NSStringFromClass([target class]) withBeginTime:[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
        
    }
    

    
}


@end
