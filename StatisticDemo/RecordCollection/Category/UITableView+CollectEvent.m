//
//  UITableView+CollectEvent.m
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import "UITableView+CollectEvent.h"
#import "NSObject+RuntimeMethodHelper.h"
#import "CollectionManager.h"
// return sel
#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])

#define TableViewDidSelectId   @"tableView:didSelectRowAtIndexPath"

@implementation UITableView (CollectEvent)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
}

- (void)swizzling_tableViewDidSelectRowAtIndexPathInClass:(id)object {
    SEL sel = @selector(tableView:didSelectRowAtIndexPath:);
    
    
    // 为每个含tableView的控件 增加swizzle delegate method
    [self class_addMethod:[object class]
                 selector:GET_CLASS_CUSTOM_SEL(sel,[object class])
                      imp:method_getImplementation(class_getInstanceMethod([self class],@selector(wf_imp_tableView:didSelectRowAtIndexPath:)))
                    types:"v@:@@"];
    
    // 检查页面是否已经实现了origin delegate method  如果没有手动加一个
    if (![self isContainSel:sel inClass:[object class] ]) {
        [self class_addMethod:[object class]
                     selector:sel
                          imp:nil
                        types:"v@:@@"];
    }
    
    // 将swizzle delegate method 和 origin delegate method 交换
    [self sel_exchangeClass:[object class]
                   FirstSel:sel
                  secondSel:GET_CLASS_CUSTOM_SEL(sel,[object class])];
}

/**
 swizzle method IMP
 */
- (void)wf_imp_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SEL sel = GET_CLASS_CUSTOM_SEL(@selector(tableView:didSelectRowAtIndexPath:),[self class]);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id,id) = (void *)imp;
        func(self, sel,tableView,indexPath);
    }
    NSLog(@"TABLEVIEW/didSelectRowAtIndexPath--->当前控制器%@--->当前section:%ld--->当前rwo:%ld",NSStringFromClass([self class]),indexPath.section,indexPath.row);
    
    //先判断是否在被统计的范围内
  
    if ([[CollectionManager sharedManager]isCollectEvent:TableViewDidSelectId andTarget:NSStringFromClass([self class])]) {
        
        [[CollectionManager sharedManager]saveEventData:TableViewDidSelectId withTargetName:NSStringFromClass([self class]) withBeginTime:[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
        
    }
    
    
    
    
}
@end
