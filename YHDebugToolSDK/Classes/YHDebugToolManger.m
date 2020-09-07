//
//  YHDebugToolManger.m
//  YHDebugToolSDK_Example
//
//  Created by zxl on 2020/9/3.
//  Copyright © 2020 zhengxiaolang. All rights reserved.
//

#import "YHDebugToolManger.h"

#if DEBUG
#import <FLEX/FLEX.h>
#endif

@interface YHDebugToolManger()

@end

@implementation YHDebugToolManger

+ (YHDebugToolManger*)shareInstance
{
    static YHDebugToolManger* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YHDebugToolManger alloc]init];
        [instance initData];
    });
    return instance;
}

-(void)showDebugView{
    
}

+(void)showNetDebugView{
    [[FLEXManager sharedManager] showExplorer];
}

-(void)showDevEnvDebugView{
    
}

#pragma mark - lazy loading

-(NSMutableDictionary<NSString *,YHDebugToolEnvModel *> *) envModelForModules{
    if (!_envModelForModules) {
        _envModelForModules = [[NSMutableDictionary alloc] init];
    }
    return _envModelForModules;
}

-(void)initData{
    YHDebugToolEnvModel *modelA = [YHDebugToolEnvModel new];
    modelA.productUrl = @"http:product_modelA";
    modelA.testUrl = @"http:test_modelA";
    modelA.devUrl = @"http:dev_modelA";
    
    YHDebugToolEnvModel *modelB = [YHDebugToolEnvModel new];
    modelB.productUrl = @"http:product_modelB";
    modelB.testUrl = @"http:test_modelB";
    modelB.devUrl = @"http:dev_modelB";
    
    YHDebugToolEnvModel *modelC = [YHDebugToolEnvModel new];
    modelC.productUrl = @"http:product_modelC";
    modelC.testUrl = @"http:test_modelC";
    modelC.devUrl = @"http:dev_modelC";
    
    [self.envModelForModules setValue:modelA forKey:@"ModuleA"];
    [self.envModelForModules setValue:modelB forKey:@"ModuleB"];
    [self.envModelForModules setValue:modelC forKey:@"ModuleC"];
    
}
@end
