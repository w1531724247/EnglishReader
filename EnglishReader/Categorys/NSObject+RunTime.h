//
//  NSObject+RunTime.h
//  XDWRTMPSender
//
//  Created by QMTV on 17/2/21.
//  Copyright © 2017年 xindawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (RunTime)

//获取对象的成员变量, 获取@property声明的属性的时候要加下划线_propertyName
- (id)getInstanceVariableWithName:(NSString *)pName;

//设置对象的实例变量的值, 设置@property声明的属性的时候要加下划线_propertyName
- (void)setInstanceVariableWithName:(NSString *)pName value:(id)value;

//获取类实例的内存大小
- (size_t)classGetInstanceSize;

//通过方法名获取实例方法
- (Method)classGetInstanceMethodWithName:(NSString *)methodName;

//通过方法名获取类方法
- (Method)classGetClassMethodWithName:(NSString *)methodName;

//通过方法名获取方法的内存地址
- (IMP)classGetMethodImplementationWithName:(NSString *)methodName;

//返回对象的属性列表, 属性的名字对应字典的key, 属性名对应类型为value
//example: {@"name":@"NSString"}, name属性的类型是NSString
- (NSDictionary *)getPropertyList;

//获取方法列表
- (NSArray *)getMethodList;

//方法交换
+ (void)qm_swizzleMethod:(Class)srcClass srcSel:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel;

//分析方法的返回值类型和参数类型
- (NSDictionary *)analysisMethodParameterAndReturnTypes;

//获取方法的返回值类型
- (NSString *)methodReturnType:(Method)method;

//获取方法的参数的个数
- (unsigned int)methodNumberOfArguments:(Method)method;

//获取方法第x个参数的类型
- (NSString *)method:(Method)method argumentTypeAtIndex:(unsigned int)index;

//为对象动态添加一个属性
- (void)setAssociatedObjectWithName:(NSString *)propertyName value:(id)propertyValue andPolicy:(NSString *)policyString;

//获取为对象动态添加的属性
- (id)getAssociatedObjectWithName:(NSString *)propertyName;

//移除所有动态添加的属性
- (void)removeAllAssociatedObject;

@end

