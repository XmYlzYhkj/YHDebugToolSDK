//
//  YHDebugToolManger.m
//  YHDebugToolSDK_Example
//
//  Created by zxl on 2020/9/3.
//  Copyright © 2020 zhengxiaolang. All rights reserved.
//

#import "YHDebugToolManger.h"
#import "YHDebugToolDicToModel.h"

#if DEBUG
#import <FLEX/FLEX.h>
#endif

@interface YHDebugToolManger()

@property(nonatomic,strong)NSLock *lock;

@end

@implementation YHDebugToolManger

+ (YHDebugToolManger*)shareInstance
{
    static YHDebugToolManger* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YHDebugToolManger alloc]init];
    });
    return instance;
}

-(id)init{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
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

/// 读取数据
-(void)initData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self readEnvData];
    });
    
//    [self testData];
}

-(NSLock *)lock{
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

#pragma mark - business action

-(void)saveEnvData{
    
    NSString *filename=[self getEnvFileName];
    NSFileManager* fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:filename]) {
        
    }else{
        [fm createFileAtPath:filename contents:nil attributes:nil];
    }
    
    //写入内容
    
    [self.lock lock];
    
    NSArray *keys = [YHDebugToolManger shareInstance].envModelForModules.allKeys;
                     
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        YHDebugToolEnvModel *model = [YHDebugToolManger shareInstance].envModelForModules[key];
        
        [dic setValue:[YHDebugToolDicToModel dictionaryWithModel:model] forKey:key];
    }];
    
    BOOL isSuccess = [dic writeToFile:filename atomically:YES];
    
    if (isSuccess) {
        NSLog(@"succ");
    }
    [self.lock unlock];
}

-(void)readEnvData{
    
    NSString *filename=[self getEnvFileName];
    //读文件
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:filename]) {
        NSDictionary* dataDic = [NSDictionary dictionaryWithContentsOfFile:filename];
        NSLog(@"dic is:%@",dataDic);
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        for (NSString *key in dataDic.allKeys) {
            NSDictionary *originalDic = dataDic[key];

            YHDebugToolEnvModel *model = [YHDebugToolDicToModel modelWithDict:originalDic className:@"YHDebugToolEnvModel"];
            
            [dic setValue:model forKey:key];
            NSLog(@"ok = %@",@"ok");
        }
        
        
        [self.lock lock];
        [YHDebugToolManger shareInstance].envModelForModules = dic;
        [self.lock unlock];
        
//        NSLog(@"path = %@",[YHDebugToolManger shareInstance].envModelForModules);
    }else{
        NSLog(@"path = %@",@"文件不存在");
    }
    
}

-(NSString *)getEnvFileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistpath = [paths objectAtIndex:0];
    NSLog(@"path = %@",plistpath);
    
    NSString *filename= [plistpath stringByAppendingPathComponent:@"yhreleasetool.plist"];

#if DEBUG
    filename= [plistpath stringByAppendingPathComponent:@"yhdebugtool.plist"];
#else
    
#endif
    
    return filename;
}


-(void)testData{
    YHDebugToolEnvModel *modelA = [YHDebugToolEnvModel new];
    modelA.productUrl = @"http:product_modelA";
    modelA.testUrl = @"http:test_modelA";
    modelA.devUrl = @"http:dev_modelA";
    modelA.moduleName = @"在线问诊A";
    modelA.moduleId = @"YH_modelA";
    
    YHDebugToolEnvModel *modelB = [YHDebugToolEnvModel new];
    modelB.productUrl = @"http:product_modelB";
    modelB.testUrl = @"http:test_modelB";
    modelB.devUrl = @"http:dev_modelB";
    modelB.moduleName = @"社保查询";
    modelB.moduleId = @"YH_modelB";
    
    YHDebugToolEnvModel *modelC = [YHDebugToolEnvModel new];
    modelC.productUrl = @"http:product_modelC";
    modelC.testUrl = @"http:test_modelC";
    modelC.devUrl = @"http:dev_modelC";
    modelC.moduleName = @"在线取药";
    modelC.moduleId = @"YH_modelC";
    
    [self.envModelForModules setValue:modelA forKey:modelA.moduleId];
    [self.envModelForModules setValue:modelB forKey:modelB.moduleId];
    [self.envModelForModules setValue:modelC forKey:modelC.moduleId];
    
}
@end
