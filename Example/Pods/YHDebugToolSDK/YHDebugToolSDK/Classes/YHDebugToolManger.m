//
//  YHDebugToolManger.m
//  YHDebugToolSDK_Example
//
//  Created by zxl on 2020/9/3.
//  Copyright © 2020 zhengxiaolang. All rights reserved.
//

#import "YHDebugToolManger.h"
#import "YHDebugToolDicToModel.h"
#import "YHDebugToolView.h"

#if __has_include(<FLEX/FLEX.h>)
    #if DEBUG
    #import <FLEX/FLEX.h>
    #endif
#endif
static NSInteger YHDebugToolView_Tag = 123321;

@interface YHDebugToolManger()

/// 模块配置环境
@property(nonatomic,strong)NSMutableDictionary<NSString *,YHDebugToolEnvModel *> *envModelForModules;

/// 上次保存的旧数据，为了在每次重新打开app后，先读旧数据，再跟新环境对比，将每个模块旧的环境类型设置到新的数据上
//@property(nonatomic,strong)NSMutableDictionary<NSString *,YHDebugToolEnvModel *> *oldEnvModelForModules;

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

+(void)showConfirmAlert{
    
    NSInteger tag = YHDebugToolView_Tag;
    UIApplication *app = [UIApplication sharedApplication];
    UIView *superView = app.delegate.window.rootViewController.view;
    
    if ([superView viewWithTag:tag] == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请确认是否进入debug主页" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];

        UIAlertAction *debugAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [YHDebugToolManger showHomePage];
        }];
        [alert addAction:debugAction];
        
        [app.delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }else{
        
    }
}

+(void)showHomePage{
    YHDebugToolView *debugView = [[YHDebugToolView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    debugView.tag = YHDebugToolView_Tag;
    
    UIApplication *app = [UIApplication sharedApplication];
    UIView *superView = app.delegate.window.rootViewController.view;
    [superView addSubview:debugView];
}

+(void)showNetDebugView{
#if __has_include(<FLEX/FLEX.h>)
    #if DEBUG
    [[FLEXManager sharedManager] showExplorer];
    #endif
#endif

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
    
    if (![fm fileExistsAtPath:filename]) {
        [fm createFileAtPath:filename contents:nil attributes:nil];
    }
    
    //写入内容
    
    [self.lock lock];
    
    NSArray *keys = [YHDebugToolManger shareInstance].envModelForModules.allKeys;
                     
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        YHDebugToolEnvModel *model = [YHDebugToolManger shareInstance].envModelForModules[key];

        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:[YHDebugToolDicToModel dictionaryWithModel:model]];

        //默认为保存以4个字段，手动移除 edit by zxl
        NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"];
        [mutableDic removeObjectsForKeys:filters];
        [dic setValue:mutableDic forKey:key];
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
        }
        
        [self.lock lock];
        [YHDebugToolManger shareInstance].envModelForModules = dic;
        [self.lock unlock];
        
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

+(NSString *)getUrlWithModuleId:(NSString *)moduleId withType:(YHDebugToolEnvType)envType{
    YHDebugToolEnvModel *model = [YHDebugToolManger shareInstance].envModelForModules[moduleId];
    //如果模块不存在
    if (model == nil) {
        return [NSString stringWithFormat:@"module: [%@] no exists",moduleId];
    }else{
        switch (envType) {
            case YHDebugToolEnvTypeDev:
                return model.devUrl;
                break;
            case YHDebugToolEnvTypeTest:
                return model.testUrl;
                break;
            case YHDebugToolEnvTypePreProduct:
                return model.preProductUrl;
                break;
            case YHDebugToolEnvTypeProduct:
                return model.productUrl;
                break;
            default:
                return model.productUrl;
                break;
        }
    }
}

+(void)resetEnv{
    NSArray *array = [[YHDebugToolManger shareInstance].envModelForModules allValues];
    
    [array enumerateObjectsUsingBlock:^(YHDebugToolEnvModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.currentEnvType = YHDebugToolEnvTypeProduct;
    }];
}

+(YHDebugToolEnvModel *)getModuleEnvModelWithId:(NSString *)moduleId{
    return [YHDebugToolManger shareInstance].envModelForModules[moduleId];
}

/// 获取所有模块的ID
+(NSArray *)getAllModluleIds{
    return [YHDebugToolManger shareInstance].envModelForModules.allKeys;
}

+(void)addModuleModel:(YHDebugToolEnvModel *)model{
    if (model.moduleId == nil ||
        [@"" isEqualToString:model.moduleId] ||
        nil == model) {
        return;
    }
    //先读取本地缓存
    if ([YHDebugToolManger shareInstance].envModelForModules.allKeys.count == 0) {
        [[YHDebugToolManger shareInstance] readEnvData];
    }
    
    [[YHDebugToolManger shareInstance].lock lock];
    
    //start edit by zxl
    //app重新打开后，每次进入，先读取旧数据的当前环境，将旧环境设置到新的model里，这样每次都可以读取到旧的数据
    
    YHDebugToolEnvModel *oldModel = [YHDebugToolManger shareInstance].envModelForModules[model.moduleId];
    
    if (oldModel != nil) {
        model.currentEnvType = oldModel.currentEnvType;
        model.localCacheUrl = oldModel.localCacheUrl;
    }
    // end
    
    [[YHDebugToolManger shareInstance].envModelForModules setValue:model forKey:model.moduleId];
    [[YHDebugToolManger shareInstance].lock unlock];
}

+(void)removeModuleModelById:(NSString *)moduleId{
    
    [[YHDebugToolManger shareInstance].lock lock];
    [[YHDebugToolManger shareInstance].envModelForModules removeObjectForKey:moduleId];
    [[YHDebugToolManger shareInstance].lock unlock];
}
@end
