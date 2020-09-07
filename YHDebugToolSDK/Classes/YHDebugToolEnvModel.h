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

///模块中文名称
@property(nonatomic,copy)NSString *moduleName;

///模块ID
@property(nonatomic,copy)NSString *moduleId;

///编辑的环境
@property(nonatomic,copy)NSString *editUrl;


/// 获取当前环境名称
-(NSString *)getCurrentEnvName;


/// 编辑设置新地址
/// @param url 编辑的地址
-(void)editWithNewUrl:(NSString *)url;


/// 根据地址判断为何环境
/// @param url 地址
-(NSString *)getEnvNameWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
