//
//  NSObject+RuntimeMethodHelper.m
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import "NSObject+RuntimeMethodHelper.h"

@implementation NSObject (RuntimeMethodHelper)

- (BOOL)class_addMethod:(Class)class selector:(SEL)selector imp:(IMP)imp types:(const char *)types {
    //    Method method = class_getInstanceMethod(class,selector);
    //    method_getTypeEncoding(method)
    return class_addMethod(class,selector,imp,types);
}

- (void)sel_exchangeFirstSel:(SEL)sel1 secondSel:(SEL)sel2 {
    [self sel_exchangeClass:[self class] FirstSel:sel1 secondSel:sel2];
}

- (void)sel_exchangeClass:(Class)class FirstSel:(SEL)sel1 secondSel:(SEL)sel2 {
    Method firstMethod = class_getInstanceMethod(class, sel1);
    Method secondMethod = class_getInstanceMethod(class, sel2);
    method_exchangeImplementations(firstMethod, secondMethod);
    
}

- (void)method_exchangeImplementations:(Method)method1 method:(Method)method2 {
    method_exchangeImplementations(method1,method2);
}

- (IMP)method_getImplementation:(Method)method {
    return method_getImplementation(method);
}

- (Method)class_getInstanceMethod:(Class)class selector:(SEL)selector {
    return class_getInstanceMethod(class, selector);
}

- (BOOL)isContainSel:(SEL)sel inClass:(Class)class {
    unsigned int count;
    
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    return NO;
}

- (void)log_class_copyMethodList:(Class)class {
    unsigned int count;
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSLog(@"%s%s",__func__,sel_getName(method_getName(method)));
    }
}



- (NSDictionary *)wf_dicFromObjectPropertyString{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [self valueForKey:name];
        
        if ([value isKindOfClass:[NSNull class]] || !value) {
            [dic setObject:@"" forKey:name];
        }else{
            
            [dic setObject:value forKey:name];
        }
    }
    
    return [dic copy];
}

@end
