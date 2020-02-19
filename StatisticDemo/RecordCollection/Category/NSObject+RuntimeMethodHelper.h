//
//  NSObject+RuntimeMethodHelper.h
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RuntimeMethodHelper)
/** 添加方法*/
- (BOOL)class_addMethod:(Class)class selector:(SEL)selector imp:(IMP)imp types:(const char *)types;
/** 方法交换*/
- (void)sel_exchangeFirstSel:(SEL)sel1 secondSel:(SEL)sel2;
/** 方法交换*/
- (void)sel_exchangeClass:(Class)class FirstSel:(SEL)sel1 secondSel:(SEL)sel2;
/**获取方法imp*/
- (IMP)method_getImplementation:(Method)method;

/**获取方法*/
- (Method)class_getInstanceMethod:(Class)class selector:(SEL)selector;
/**是否包含当前方法*/
- (BOOL)isContainSel:(SEL)sel inClass:(Class)class;

/**获取当前类的所有方法*/
- (void)log_class_copyMethodList:(Class)class;

/** 把model 转化为字典  (要满足属性都是字符串,否则这个方法不能用)*/
- (NSDictionary *)wf_dicFromObjectPropertyString;
@end

NS_ASSUME_NONNULL_END
