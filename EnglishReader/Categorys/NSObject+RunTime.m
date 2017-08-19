//
//  NSObject+RunTime.m
//  XDWRTMPSender
//
//  Created by QMTV on 17/2/21.
//  Copyright © 2017年 xindawn. All rights reserved.
//

#import "NSObject+RunTime.h"


@implementation NSObject (RunTime)

//获取对象的成员变量, 用@property声明的属性, 获取的时候要加下划线_propertyName
- (id)getInstanceVariableWithName:(NSString *)pName {
    Ivar targetVar = nil;
    unsigned  int count = 0;
    Ivar *members = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++)
    {
        Ivar var = members[i];
        const char *memberAddress = ivar_getName(var);
        NSString *propertyName = [NSString stringWithFormat:@"%s", memberAddress];
        
        if ([propertyName isEqualToString:pName]) {
            targetVar = var;
            break;
        }
    }
    
    return object_getIvar(self, targetVar);
}

//设置对象的实例变量的值, 用@property声明的属性, 设置的时候要加下划线_propertyName
- (void)setInstanceVariableWithName:(NSString *)pName value:(id)value {
    Ivar targetVar = nil;
    unsigned  int count = 0;
    Ivar *members = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++)
    {
        Ivar var = members[i];
        const char *memberAddress = ivar_getName(var);
        NSString *propertyName = [NSString stringWithFormat:@"%s", memberAddress];
        
        if ([propertyName isEqualToString:pName]) {
            targetVar = var;
        }
    }
    
    object_setIvar(self, targetVar, value);
}

//获取类实例的内存大小
- (size_t)classGetInstanceSize {
    return class_getInstanceSize([self class]);
}

//通过方法名获取实例方法
- (Method)classGetInstanceMethodWithName:(NSString *)methodName {
    SEL selector = NSSelectorFromString(methodName);
    
    return class_getInstanceMethod([self class], selector);
}

//通过方法名获取类方法
- (Method)classGetClassMethodWithName:(NSString *)methodName {
    SEL selector = NSSelectorFromString(methodName);
    
    return class_getClassMethod([self class], selector);
}

//通过方法名获取方法的内存地址
- (IMP)classGetMethodImplementationWithName:(NSString *)methodName {
    SEL selector = NSSelectorFromString(methodName);
    
    return class_getMethodImplementation([self class], selector);
}

//返回对象的属性列表, 属性的名字对应字典的key, 属性名对应类型为value
//example: {@"name":@"NSString"}, name属性的类型是NSString
- (NSDictionary *)getPropertyList {
    NSMutableDictionary *propertyList = [NSMutableDictionary dictionary];
    
    unsigned  int count = 0;
    Ivar *members = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++)
    {
        Ivar var = members[i];
        const char *memberAddress = ivar_getName(var);
        const char *memberType = ivar_getTypeEncoding(var);
        
        NSString *propertyName = [NSString stringWithFormat:@"%s", memberAddress];
        NSString *propertyClassName = [NSString stringWithFormat:@"%s", memberType];
        
        [propertyList setValue:propertyClassName forKey:propertyName];
    }
    
    return [propertyList copy];
}

//获取方法列表
- (NSArray *)getMethodList {
    NSMutableArray *methodList = [NSMutableArray array];
    
    unsigned int count = 0;
    Method *memberFuncs = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        SEL address = method_getName(memberFuncs[i]);
        NSString *methodName = [NSString stringWithCString:sel_getName(address) encoding:NSUTF8StringEncoding];
        [methodList addObject:methodName];
    }
    
    return [methodList copy];
}

//方法交换
+ (void)qm_swizzleMethod:(Class)srcClass srcSel:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel{
    if (!srcClass) {
        return;
    }
    if (!srcSel) {
        return;
    }
    if (!tarClass) {
        return;
    }
    if (!tarSel) {
        return;
    }
    Method srcMethod = class_getInstanceMethod(srcClass,srcSel);
    Method tarMethod = class_getInstanceMethod(tarClass,tarSel);
    method_exchangeImplementations(srcMethod, tarMethod);
}

- (NSDictionary *)analysisMethodParameterAndReturnTypes {
    NSMutableDictionary *methodInfo = [NSMutableDictionary dictionary];
    
    unsigned int count = 0;
    Method *memberFuncs = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        Method method = memberFuncs[i];
        SEL address = method_getName(method);
        NSString *methodName = [NSString stringWithCString:sel_getName(address) encoding:NSUTF8StringEncoding];
        NSString *returnType = [NSString stringWithCString:method_copyReturnType(method) encoding:NSUTF8StringEncoding];
        unsigned int argumentCount = method_getNumberOfArguments(method);
        NSString *argumentsType = [NSString string];
        
        for (unsigned int j = 0; j < argumentCount; j++) {
            NSString *typeString = [NSString stringWithFormat:@"arg_%d: %s, ", j, method_copyArgumentType(method, j)];
            argumentsType = [argumentsType stringByAppendingString:typeString];
        }
        
        NSString *value = [NSString stringWithFormat:@"returnType: %@    argumentTpes: %@", returnType, argumentsType];
        
        [methodInfo setValue:value forKey:methodName];
    }
    
    return [methodInfo copy];
}

- (NSString *)methodReturnType:(Method)method {
    return [NSString stringWithCString:method_copyReturnType(method) encoding:NSUTF8StringEncoding];
}

- (unsigned int)methodNumberOfArguments:(Method)method {
    return method_getNumberOfArguments(method);
}

- (NSString *)method:(Method)method argumentTypeAtIndex:(unsigned int)index{
    return [NSString stringWithFormat:@"argument %d type is: %s", index, method_copyArgumentType(method, index)];
}

//为对象冬天添加一个属性
- (void)setAssociatedObjectWithName:(NSString *)propertyName value:(id)propertyValue andPolicy:(NSString *)policyString {
    const char *key = [propertyName cStringUsingEncoding:NSUTF8StringEncoding];
    objc_AssociationPolicy policy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
    if ([policyString isEqualToString:@"retain"]) {
        policy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
    }
    
    if ([policyString isEqualToString:@"assign"]) {
        policy = OBJC_ASSOCIATION_ASSIGN;
    }
    
    if ([policyString isEqualToString:@"copy"]) {
        policy = OBJC_ASSOCIATION_COPY_NONATOMIC;
    }
    
    objc_setAssociatedObject(self, key, propertyValue, policy);
}

//获取为对象动态添加的属性
- (id)getAssociatedObjectWithName:(NSString *)propertyName {
    const char *key = [propertyName cStringUsingEncoding:NSUTF8StringEncoding];
    
    return objc_getAssociatedObject(self, key);
}

//移除所有动态添加的属性
- (void)removeAllAssociatedObject {
    objc_removeAssociatedObjects(self);
}

@end
