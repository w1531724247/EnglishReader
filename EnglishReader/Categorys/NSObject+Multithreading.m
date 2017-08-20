//
//  NSObject+Multithreading.m
//  OCMultithreading
//
//  Created by QMTV on 2017/7/14.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "NSObject+Multithreading.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation NSObject (Multithreading)

//更新UI的操作放在主线程执行
- (void)updateUI:(dispatch_block_t)operation {
    [self performOperationInMainThread:operation];
}

//网络请求, 异步并发
- (void)netWorkOperation:(dispatch_block_t)operation {
    const char *queueLabel = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL);
    char *queueName = "UIApplication.networkThread.concurrent";
    if (strcmp(queueLabel,queueName) != 0) {//不在指定线程
        dispatch_queue_t queue = [self application_queue_concurrent];
        dispatch_async(queue, operation);
    } else {
        operation();
    }
}

//普通业务逻辑放在专门的线程执行
- (void)normalLogicOperation:(dispatch_block_t)operation {
    const char *queueLabel = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL);
    char *queueName = "UIApplication.normalLogic.serial";
    if (strcmp(queueLabel,queueName) != 0) {//不在指定线程
        dispatch_queue_t queue = [self application_queue_serial];
        dispatch_async(queue, operation);
    }else {
        operation();
    }
}

//需要放在主线程的操作
- (void)performOperationInMainThread:(dispatch_block_t)operation {
    dispatch_async(dispatch_get_main_queue(), operation);
}

//添加依赖按顺序执行, 数组里的代码块后一个依赖于前一个
- (void)performOperationsInOrder:(NSArray<dispatch_block_t> *)operations {
    NSInteger count = operations.count;
    if (count < 1) {
        return;
    }

    for (int i = 0; i < count; i++) {
        if (i >= 1) {
            dispatch_block_t priviousBlock = [operations objectAtIndex:i-1];
            dispatch_block_t nextBlock = [operations objectAtIndex:i];
            
            NSBlockOperation *priviousOperation = [NSBlockOperation blockOperationWithBlock:priviousBlock];
            NSBlockOperation *nextOperation = [NSBlockOperation blockOperationWithBlock:nextBlock];
            
            [nextOperation addDependency:priviousOperation];
            NSOperationQueue *operationQueue = [self application_operation_queue];
            if (i == 1) {
                [operationQueue addOperation:priviousOperation];
            }
            
            [operationQueue addOperation:nextOperation];
        }
    }
}

#pragma mark ----- getter

- (dispatch_queue_t)application_queue_serial {
    const char *nameKey = "UIApplication.normalLogic.serial";
    dispatch_queue_t queue = objc_getAssociatedObject([UIApplication sharedApplication], nameKey);
    if (!queue) {
        queue = dispatch_queue_create(nameKey, DISPATCH_QUEUE_SERIAL);
        objc_setAssociatedObject([UIApplication sharedApplication], nameKey, queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return queue;
}

- (dispatch_queue_t)application_queue_concurrent {
    const char *nameKey = "UIApplication.networkThread.concurrent";
    dispatch_queue_t queue = objc_getAssociatedObject([UIApplication sharedApplication], nameKey);
    if (!queue) {
        queue = dispatch_queue_create(nameKey, DISPATCH_QUEUE_CONCURRENT);
        objc_setAssociatedObject([UIApplication sharedApplication], nameKey, queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return queue;
}

- (NSOperationQueue *)application_operation_queue {
    const char *nameKey = "UIApplication.serial_operation_queue";
    NSOperationQueue *serial_operation_queue = objc_getAssociatedObject([UIApplication sharedApplication], nameKey);
    if (!serial_operation_queue) {
        serial_operation_queue = [[NSOperationQueue alloc] init];
        serial_operation_queue.maxConcurrentOperationCount = 1;//串行队列
        serial_operation_queue.name = @"UIApplication.serial_operation_queue";
        objc_setAssociatedObject([UIApplication sharedApplication], nameKey, serial_operation_queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return serial_operation_queue;
}

@end
