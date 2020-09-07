//
//  YHDebugToolEnvEditView.m
//  FLEX
//
//  Created by zxl on 2020/9/4.
//

#import "YHDebugToolEnvEditView.h"

@interface YHDebugToolEnvEditView()


/// 取消
@property(nonatomic,strong)UIButton *cancelBtn;

/// 确认
@property(nonatomic,strong)UIButton *confirmBtn;

/// 当前模块名称
@property(nonatomic,strong)UILabel *currentModuleLabel;

/// 当前环境
@property(nonatomic,strong)UILabel *currentEnvLabel;

/// 当前环境网址
@property(nonatomic,strong)UILabel *currentEnvTextLabel;

/// 新环境地址
@property(nonatomic,strong)UITextView *textView;

@end

@implementation YHDebugToolEnvEditView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self createView];
        
    }
    return self;
}

-(void)initData{
    self.backgroundColor = [UIColor whiteColor];
}

-(void)createView{
    [self addSubview:self.cancelBtn];
    
    [self addSubview:self.confirmBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    CGFloat height = 50;
    CGFloat y = CGRectGetHeight(frame) - height;
    CGFloat width = CGRectGetWidth(frame)/2;
    
    self.cancelBtn.frame = CGRectMake(0, y, width, 50);
    
    self.confirmBtn.frame = CGRectMake(width, y, width, 50);
    
}

#pragma mark - lazy loading

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"❌取消❌" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = 0;
        _cancelBtn = btn;
    }
    return _cancelBtn;
}

-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"✅保存✅" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = 1;
        _confirmBtn = btn;
    }
    return _confirmBtn;
}

#pragma mark - business action

-(void)clickBtn:(UIButton *)btn{
    if (btn.tag == 0) {
        NSLog(@"cancel");
    }else{
        NSLog(@"保存");
    }
    [self removeFromSuperview];
}
@end
