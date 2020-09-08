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

/// 模块配置环境
@property(nonatomic,strong)NSMutableDictionary<NSString *,YHDebugToolEnvModel *> *envModelForModules;

/// 全局
+ (instancetype)shareInstance;

/// 显示弹窗：是否进入主页
+ (void)showConfirmAlert;

/// 显示debug主页
+ (void)showHomePage;

/// 显示网络调试界面
+ (void)showNetDebugView;

/// 读取环境数据
- (void)readEnvData;

/// 保存环境数据
- (void)saveEnvData;

/// 获取根据模块id获取模块中的不同地址
/// @param moduleId 模块ID
/// @param envType 地址类型
- (NSString *)getUrlWithModuleId:(NSString *)moduleId withType:(YHDebugToolEnvType)envType;

@end

NS_ASSUME_NONNULL_END
