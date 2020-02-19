//
//  UIScrollView+CollectEvent.m
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import "UIScrollView+CollectEvent.h"
#import "NSObject+RuntimeMethodHelper.h"
#import "UITableView+CollectEvent.h"


// return sel
#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])

@implementation UIScrollView (CollectEvent)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sel_exchangeFirstSel:@selector(setDelegate:) secondSel:@selector(wf_setDelegate:)];
    });
}



- (void)wf_setDelegate:(id<UIScrollViewDelegate>)delegate {
    
    if ([NSStringFromClass([self class]) isEqualToString:@"UITableView"]){
        if (![self isContainSel:GET_CLASS_CUSTOM_SEL(@selector(tableView:didSelectRowAtIndexPath:),[delegate class]) inClass:[delegate class]]) {
            [(UITableView *)self swizzling_tableViewDidSelectRowAtIndexPathInClass:delegate];
        }
        
    }
    [self wf_setDelegate:delegate];
    
}


@end
