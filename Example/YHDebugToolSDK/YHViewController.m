//
//  YHViewController.m
//  YHDebugToolSDK
//
//  Created by zhengxiaolang on 09/03/2020.
//  Copyright (c) 2020 zhengxiaolang. All rights reserved.
//

#import "YHViewController.h"

#import "YHDebugToolSDK.h"


#define VERTICAL_SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width    //竖屏宽度
#define VERTICAL_SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)   //竖屏高度

@interface YHViewController ()

@end

@implementation YHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    YHDebugToolView *toolView = [[YHDebugToolView alloc] initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT)];
    
//    [self.view addSubview:toolView];
    
    [self testData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [YHDebugToolManger addModuleModel:modelA];
    [YHDebugToolManger addModuleModel:modelB];
    [YHDebugToolManger addModuleModel:modelC];
}
@end
