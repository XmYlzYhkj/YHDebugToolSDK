//
//  YHDebugToolEnvEditView.h
//  FLEX
//  开发环境编辑页
//  Created by zxl on 2020/9/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHDebugToolEnvEditView : UIView

@property(nonatomic,copy)dispatch_block_t editBlock;

/// 编辑页面
/// @param model 进入编辑界面
-(id)initWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
