//
//  NSObject+Multithreading.h
//  OCMultithreading
//
//  Created by QMTV on 2017/7/14.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Multithreading)

/*
 *三大模块:
 *1. 更新UI
 *2. 普通逻辑
 *3. 网络请求
 */

//更新UI的操作放在主线程执行
- (void)updateUI:(dispatch_block_t)operation;

//普通业务逻辑放在专门的线程执行
- (void)normalLogicOperation:(dispatch_block_t)operation;

//网络请求, 异步并发
- (void)netWorkOperation:(dispatch_block_t)operation;

//需要放在主线程的操作
- (void)performOperationInMainThread:(dispatch_block_t)operation;

//添加依赖按顺序执行, 数组里的代码块后一个依赖于前一个
/*
 *注意一定不要产生循环依赖
 */
- (void)performOperationsInOrder:(NSArray<dispatch_block_t> *)operations;

@end
