//
//  UIWindow+YHDebugTool.m
//  FLEX
//
//  Created by zxl on 2020/9/3.
//

#import "UIWindow+YHDebugTool.h"
#import "YHDebugToolView.h"

#if DEBUG
#import <FLEX/FLEX.h>
#endif

static NSInteger YHDebugToolView_Tag = 123321;

@implementation UIWindow (YHDebugTool)

#if DEBUG
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionBegan:motion withEvent:event];
    
    if (motion == UIEventSubtypeMotionShake) {
        
        NSInteger tag = YHDebugToolView_Tag;
        UIApplication *app = [UIApplication sharedApplication];
        UIView *superView = app.delegate.window.rootViewController.view;
        
        if ([superView viewWithTag:tag] == nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请确认是否进入debug界面" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];

            UIAlertAction *debugAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self showDebugView];
            }];
            [alert addAction:debugAction];
            
            [app.delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }else{
            
        }
        
    }
}

-(void)showDebugView{
    YHDebugToolView *debugView = [[YHDebugToolView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    debugView.tag = YHDebugToolView_Tag;
    
    UIApplication *app = [UIApplication sharedApplication];
    UIView *superView = app.delegate.window.rootViewController.view;
    [superView addSubview:debugView];
}
#endif

@end
