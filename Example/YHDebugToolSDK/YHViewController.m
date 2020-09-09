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
    
    [self initData];
    
    NSArray *btnTitle = @[@"打开调试主页",@"请求网址查看日志",@"显示模块YH_modelA地址"];
    for (NSInteger i = 0; i < btnTitle.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 150 + 80 * i, [UIScreen mainScreen].bounds.size.width - 40, 50)];
        
        NSString *title = btnTitle[i];
        btn.tag = i;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor brownColor]];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 初始化模块
-(void)initData{
    YHDebugToolEnvModel *modelA = [YHDebugToolEnvModel new];
    modelA.productUrl = @"http:product_modelA";
    modelA.testUrl = @"https://yyzs.ylzpay.com:1400";
    modelA.devUrl = @"http://alilive.ylzpay.cn/OperAssist-web";
    modelA.moduleName = @"在线问诊A";
    modelA.moduleId = @"YH_modelA";
    
    YHDebugToolEnvModel *modelB = [YHDebugToolEnvModel new];
    modelB.productUrl = @"http:product_modelB";
    modelB.testUrl = @"https://yyzs.ylzpay.com:1400";
    modelB.devUrl = @"http://alilive.ylzpay.cn/OperAssist-web";
//    modelB.moduleName = @"社保查询";
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

-(void)clickBtn:(UIButton *)btn{
    if (btn.tag == 0) {
        [self showHomePage];
    }else if(btn.tag == 1){
        [self sendRequest];
    }else{
        [self getCurrentModuleUrl];
    }
}
/// 打开调试主页
-(void)showHomePage{
    [YHDebugToolManger showHomePage];
}

/// 根据模块名称获取当前地址
-(NSString *)getCurrentModuleUrl{
    
    NSString *moduleId = @"YH_modelA";
    
    NSString *url = [YHDebugToolManger getCurrentUrlWithModuleId:moduleId];
    
    //debug时候，弹窗提示
    [YHDebugToolManger showTipAlertWithTitle:[YHDebugToolManger getModuleEnvModelWithId:moduleId].moduleName withMessage:url];
    
    return url;
}

-(void)sendRequest{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    
    NSURLSessionTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [YHDebugToolManger showTipAlertWithTitle:@"请求结束" withMessage:@"点击--》网络抓包--》menu--》Network History 即可查看网络记录"];
        });
    }];
    // 启动任务
    [task resume];
    
}
@end
