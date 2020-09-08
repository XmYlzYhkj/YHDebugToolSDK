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

/// 全局
+ (instancetype)shareInstance;

/// 显示弹窗：是否进入主页
+ (void)showConfirmAlert;

/// 显示debug主页
+ (void)showHomePage;

/// 显示网络调试界面
+ (void)showNetDebugView;

/// 重置所有模块的开发环境，统一以product为默认环境
+ (void)resetEnv;

/// 读取环境数据
- (void)readEnvData;

/// 保存环境数据
- (void)saveEnvData;

/// 获取根据模块id获取模块中的不同地址
/// @param moduleId 模块ID
/// @param envType 地址类型
+ (NSString *)getUrlWithModuleId:(NSString *)moduleId withType:(YHDebugToolEnvType)envType;

/// 根据模块ID获取数据
/// @param moduleId 模块ID
+(YHDebugToolEnvModel *)getModuleEnvModelWithId:(NSString *)moduleId;

/// 获取所有模块的ID
+(NSArray *)getAllModluleIds;

/// 添加模块环境
/// @param model 环境模型
+(void)addModuleModel:(YHDebugToolEnvModel *)model;

/// 根据模块id移除模块环境
/// @param moduleId 模块id
+(void)removeModuleModelById:(NSString *)moduleId;

@end

NS_ASSUME_NONNULL_END
