//
//  YHDebugToolEnvModel.m
//  FLEX
//
//  Created by zxl on 2020/9/3.
//

#import "YHDebugToolEnvModel.h"

@interface YHDebugToolEnvModel()


@end

@implementation YHDebugToolEnvModel

-(id)init{
    self = [super init];
    
    if (self) {
        self.moduleName = @"模块未命名";
        self.devUrl = @"";
        self.testUrl = @"";
        self.productUrl = @"";
        self.preProductUrl = @"左滑->菜单";
        self.localCacheUrl = @"本地缓存";
    }
    return self;
}

-(NSString *)getCurrentEnvName{
    return [YHDebugToolEnvModel getEnvNameByType:self.currentEnvType];
}

-(NSString *)getCurrentEnvUrl{
    return [self getEnvUrlByType:self.currentEnvType];
}

+(NSString *)getEnvNameByType:(YHDebugToolEnvType)type{
    
    switch (type) {
        case 0:
            return @"正式环境";
            break;
        case 1:
            return @"开发环境";
            break;
        case 2:
            return @"测试环境";
            break;
        case 3:
            return @"预正式环境";
            break;
        case 4:
            return @"自定义环境";
            break;
        default:
            break;
    }
    return @"未知环境";
}

-(NSString *)getEnvUrlByType:(YHDebugToolEnvType)type{
    switch (type) {
        case 0:
            return self.productUrl;
            break;
        case 1:
            return self.devUrl;
            break;
        case 2:
            return self.testUrl;
            break;
        case 3:
            return self.preProductUrl;
            break;
        case 4:
            return self.localCacheUrl;
            break;
        default:
            break;
    }
    return @"未知环境";
}

-(NSString *)getEditEnvName{
    return [YHDebugToolEnvModel getEnvNameByType:self.editEnvType];
}

-(NSString *)getEditEnvUrl{
    return [self getEnvUrlByType:self.editEnvType];
}
-(void)resetWithNewUrl:(NSString *)url toEnv:(YHDebugToolEnvType)envType{
    switch (envType) {
        case 0:
            self.productUrl = url;
            break;
        case 1:
            self.devUrl = url;
            break;
        case 2:
            self.testUrl = url;
            break;
        case 3:
            self.preProductUrl = url;
            break;
        case 4:
            self.localCacheUrl = url;
            break;
        default:
            break;
    }
}
#pragma mark - debugDelegate

- (NSString * _Nullable)getDebugDevUrl {
    return self.devUrl;
}

- (NSString * _Nullable)getDebugPreProductUrl {
    return self.preProductUrl;
}

- (NSString * _Nullable)getDebugProductUrl {
    return self.productUrl;
}

- (NSString * _Nullable)getDebugTestUrl {
    return self.testUrl;
}

- (NSString * _Nullable)getDebugLocalCacheUrl {
    return self.localCacheUrl;
}

@end
