//
//  YHDebugToolEnvModel.h
//  FLEX
//
//  Created by zxl on 2020/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHDebugToolEnvModel : NSObject

/// 当前环境
@property(nonatomic,copy)NSString *currentUrl;

/// 生产环境
@property(nonatomic,copy)NSString *productUrl;

/// 预生产环境
@property(nonatomic,copy)NSString *pre_productUrl;

/// 开发环境
@property(nonatomic,copy)NSString *devUrl;

/// 测试环境
@property(nonatomic,copy)NSString *testUrl;

/// 获取当前环境名称
-(NSString *)getCurrentEnvName;

@end

NS_ASSUME_NONNULL_END
