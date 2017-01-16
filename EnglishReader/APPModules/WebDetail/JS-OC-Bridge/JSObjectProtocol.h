//
//  JSObjectProtocol.h
//  QMPlayground
//
//  Created by QMTV on 16/4/19.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjectProtocol <JSExport>

- (void)textDidTouch:(NSString *)text;

@end
