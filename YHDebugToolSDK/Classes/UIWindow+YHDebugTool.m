//
//  UIWindow+YHDebugTool.m
//  FLEX
//
//  Created by zxl on 2020/9/3.
//

#import "UIWindow+YHDebugTool.h"
#import "YHDebugToolManger.h"

@implementation UIWindow (YHDebugTool)

#if DEBUG
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionBegan:motion withEvent:event];
    
    if (motion == UIEventSubtypeMotionShake) {
        [YHDebugToolManger showConfirmAlert];
    }
}

#endif

@end
