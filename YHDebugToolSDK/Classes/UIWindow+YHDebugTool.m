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

@implementation UIWindow (YHDebugTool)

#if DEBUG
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionBegan:motion withEvent:event];
    
    if (motion == UIEventSubtypeMotionShake) {
//        [[FLEXManager sharedManager] showExplorer];
        
        UIApplication *app = [UIApplication sharedApplication];
        UIView *superView = app.delegate.window.rootViewController.view;
        
        if ([superView viewWithTag:123321] == nil) {
            YHDebugToolView *debugView = [[YHDebugToolView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            debugView.tag = 123321;
            [superView addSubview:debugView];
        }else{
            
        }
    }
}
#endif

@end
