//
//  YHDebugToolEnvModel.m
//  FLEX
//
//  Created by zxl on 2020/9/3.
//

#import "YHDebugToolEnvModel.h"

@interface YHDebugToolEnvModel()

//@property(nonatomic,copy)NSString *currentUrl;

@end

@implementation YHDebugToolEnvModel

-(id)init{
    self = [super init];
    
    if (self) {
        self.pre_productUrl = @"进入编辑";
        self.devUrl = @"";
        self.testUrl = @"";
        self.productUrl = @"";
        self.editUrl = @"";
    }
    return self;
}

-(NSString *)getCurrentEnvName{
    return [self getEnvNameWithUrl:self.currentUrl];
}

/// 重写当前环境
/// @param productUrl 正式环境
-(void)setProductUrl:(NSString *)productUrl{
    _productUrl = productUrl;
    
    //如果当前环境为空，默认则为正式地址
    if ([@"" isEqualToString:self.currentUrl] ||
        nil == self.currentUrl) {
        _currentUrl = productUrl;
    }
}

-(void)editWithNewUrl:(NSString *)url{
    
    if ([self.editUrl isEqualToString:self.productUrl]) {
        self.productUrl = url;
    }else if ([self.editUrl isEqualToString:self.pre_productUrl]) {
        self.pre_productUrl = url;
    }else if ([self.editUrl isEqualToString:self.devUrl]) {
        self.devUrl = url;
    }else if ([self.editUrl isEqualToString:self.testUrl]) {
        self.testUrl = url;
    }
    self.editUrl = url;
    
}

-(NSString *)getEnvNameWithUrl:(NSString *)url{
    
    if ([url isEqualToString:self.productUrl]) {
        return @"正式环境";
    }else if ([url isEqualToString:self.pre_productUrl]) {
        return @"预正式环境";
    }else if ([url isEqualToString:self.devUrl]) {
        return @"开发环境";
    }else if ([url isEqualToString:self.testUrl]) {
        return @"测试环境";
    }
    return @"未知";
}

@end
