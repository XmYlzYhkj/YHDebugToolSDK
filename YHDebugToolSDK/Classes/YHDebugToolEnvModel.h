//
//  YHDebugToolEnvModel.h
//  FLEX
//
//  Created by zxl on 2020/9/3.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,YHDebugToolEnvType){
    YHDebugToolEnvTypeProduct = 0,//生产地址
    YHDebugToolEnvTypeDev = 1,//开发
    YHDebugToolEnvTypeTest = 2,//测试
    YHDebugToolEnvTypePreProduct = 3//预生产
};
 
@protocol YHDebugToolDelegate <NSObject>

//-(NSString *_Nullable)getDebugCurrentUrl;

-(NSString *_Nullable)getDebugProductUrl;

-(NSString *_Nullable)getDebugPreProductUrl;

-(NSString *_Nullable)getDebugDevUrl;

-(NSString *_Nullable)getDebugTestUrl;

@end
NS_ASSUME_NONNULL_BEGIN

@interface YHDebugToolEnvModel : NSObject<YHDebugToolDelegate>

/// 生产环境
@property(nonatomic,copy)NSString *productUrl;

/// 预生产环境
@property(nonatomic,copy)NSString *preProductUrl;

/// 开发环境
@property(nonatomic,copy)NSString *devUrl;

/// 测试环境
@property(nonatomic,copy)NSString *testUrl;

///模块中文名称
@property(nonatomic,copy)NSString *moduleName;

///模块ID
@property(nonatomic,copy)NSString *moduleId;

/// 编辑的环境
@property(nonatomic,assign)YHDebugToolEnvType editEnvType;

/// 当前环境，默认为正式环境
@property(nonatomic,assign)YHDebugToolEnvType currentEnvType;

/// 获取当前环境名称
-(NSString *)getCurrentEnvName;

/// 获取当前环境地址
-(NSString *)getCurrentEnvUrl;

/// 根据网址获取环境名称
/// @param type 环境类型
+(NSString *)getEnvNameByType:(YHDebugToolEnvType)type;

/// 根据网址类型获取网址
/// @param type 环境类型
-(NSString *)getEnvUrlByType:(YHDebugToolEnvType)type;

/// 获取编辑的环境名称
-(NSString *)getEditEnvName;

/// 获取编辑的环境地址
-(NSString *)getEditEnvUrl;

/// 根据环境类型设置新的地址
/// @param url 新地址
/// @param envType 环境类型
-(void)resetWithNewUrl:(NSString *)url toEnv:(YHDebugToolEnvType)envType;

@end

NS_ASSUME_NONNULL_END
