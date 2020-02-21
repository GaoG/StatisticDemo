//
//  UIGestureRecognizer+CollectEvent.m
//  StatisticDemo
//
//  Created by  GaoGao on 2020/2/20.
//  Copyright © 2020年  GaoGao. All rights reserved.
//

#import "UIGestureRecognizer+CollectEvent.h"
#import "NSObject+RuntimeMethodHelper.h"

@implementation UIGestureRecognizer (CollectEvent)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ///获取
    
        [self sel_exchangeFirstSel:@selector(initWithTarget:action:) secondSel:@selector(wf_initWithTarget:action:)];
        
    });
}

- (instancetype)wf_initWithTarget:(nullable id)target action:(nullable SEL)action{
    UIGestureRecognizer *gestureRecognizer = [self wf_initWithTarget:target action:action];
    SEL changeSEL = @selector(wf_gestureAction:);
    IMP hookIMP = class_getMethodImplementation(self.class, changeSEL);
    const char *type = method_getTypeEncoding(class_getInstanceMethod([target class], action));
    class_addMethod([target class], changeSEL, hookIMP, type);
    
    
    [self sel_exchangeClass:[target class] FirstSel:action secondSel:changeSEL];
    
    
    return gestureRecognizer;
}

- (void)wf_gestureAction:(id)sender{
    [self wf_gestureAction:sender];
    
    UIGestureRecognizer *gesture = sender;
    
    
    NSArray *aaa = [gesture valueForKey:@"targets"];
   NSString *fristName =  [aaa firstObject];
    NSArray *comminuteArr = [[NSString stringWithFormat:@"%@",fristName] componentsSeparatedByString:@","];
    NSString *comminuteFristName = [comminuteArr firstObject];

    NSString *cationName = [comminuteFristName stringByReplacingOccurrencesOfString:@"(action=" withString:@""];
    NSLog(@"cationName:%@",cationName);
    
    NSLog(@"self:%@--->senderClass:%@----action:%@",NSStringFromClass([self class]),[sender class],cationName);
//    [[LJL_HookObjcLog logManage] recordLogActionHookClass:[sender class] action:@selector(action) identifier:@"手势"];
    
}


@end
