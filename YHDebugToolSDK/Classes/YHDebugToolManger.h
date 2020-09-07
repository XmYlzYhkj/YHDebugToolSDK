//
//  YHDebugToolManger.h
//
//  Created by zxl on 2020/9/3.
//  Copyright © 2020 zhengxiaolang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YHDebugToolEnvModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHDebugToolManger : NSObject

/// 主工程环境
@property(nonatomic,strong)YHDebugToolEnvModel *mainEnvModel;

/// 模块配置环境
@property(nonatomic,strong)NSMutableDictionary<NSString *,YHDebugToolEnvModel *> *envModelForModules;

/// 全局
+ (instancetype)shareInstance;


/// 显示debug界面
-(void)showDebugView;


/// 显示网络调试界面
+(void)showNetDebugView;
@end

NS_ASSUME_NONNULL_END
