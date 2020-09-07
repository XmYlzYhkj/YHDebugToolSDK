//
//  YHDebugToolEnvEditView.m
//  FLEX
//
//  Created by zxl on 2020/9/4.
//

#import "YHDebugToolEnvEditView.h"

#import "YHDebugToolEnvModel.h"


#define  YH_Debug_StatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height

// Navigation bar height.
#define  YH_Debug_NavigationBarHeight  44.f

@interface YHDebugToolEnvEditView()<UITextViewDelegate>

/// 取消
@property(nonatomic,strong)UIButton *cancelBtn;

/// 确认
@property(nonatomic,strong)UIButton *confirmBtn;

/// 当前模块名称
@property(nonatomic,strong)UILabel *currentModuleLabel;

/// 当前环境
@property(nonatomic,strong)UILabel *currentEnvNameLabel;

/// 当前环境网址
@property(nonatomic,strong)UILabel *currentEnvTextLabel;

/// 当前新环境
@property(nonatomic,strong)UILabel *currentNewEnvLabel;

/// 新环境地址编辑框
@property(nonatomic,strong)UITextView *textView;

@property(nonatomic,strong)YHDebugToolEnvModel *editModel;

@end

@implementation YHDebugToolEnvEditView

-(id)initWithModel:(id)model{
    
    self = [super init];
    if (self) {
        self.editModel = model;
    }
    return self;
}

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
    [self addInputAccessViewWithTextField:self.textView];
}

-(void)createView{
    [self addSubview:self.cancelBtn];
    
    [self addSubview:self.confirmBtn];
    
    [self addSubview:self.currentModuleLabel];
    [self addSubview:self.currentEnvNameLabel];
    [self addSubview:self.currentEnvTextLabel];
    [self addSubview:self.currentNewEnvLabel];
    [self addSubview:self.textView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    CGFloat height = 50;
    CGFloat y = YH_Debug_StatusBarHeight + YH_Debug_NavigationBarHeight + 270; //CGRectGetHeight(frame) - height;
    CGFloat width = CGRectGetWidth(frame)/2;
    
    self.cancelBtn.frame = CGRectMake(0, y, width, 50);
    
    self.confirmBtn.frame = CGRectMake(width, y, width, 50);
    
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width - 40;
    
    self.currentModuleLabel.frame = CGRectMake(20, YH_Debug_StatusBarHeight + YH_Debug_NavigationBarHeight, labelWidth, 50);
    
    self.currentEnvNameLabel.frame = CGRectMake(20, YH_Debug_StatusBarHeight + YH_Debug_NavigationBarHeight + 50, labelWidth, 50);
    
    self.currentEnvTextLabel.frame = CGRectMake(20, YH_Debug_StatusBarHeight + YH_Debug_NavigationBarHeight + 100, labelWidth, 50);
    
    self.currentNewEnvLabel.frame = CGRectMake(20, YH_Debug_StatusBarHeight + YH_Debug_NavigationBarHeight + 150, labelWidth, 50);
    
    self.textView.frame = CGRectMake(20, YH_Debug_StatusBarHeight + YH_Debug_NavigationBarHeight + 200, labelWidth, 50);
    
    self.cancelBtn.frame = CGRectMake(10, y, width - 20, 50);
    
    self.confirmBtn.frame = CGRectMake(width + 10, y, width - 20, 50);
    
    [self reloadData];
}


#pragma mark - lazy loading

-(UILabel *)currentNewEnvLabel{
    if (!_currentNewEnvLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor greenColor];
        _currentNewEnvLabel = label;
    }
    return _currentNewEnvLabel;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = [UIColor greenColor];
        _textView.delegate = self;
        _textView.layer.borderColor = [UIColor greenColor].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.layer.cornerRadius = 10;
        _textView.font = [UIFont boldSystemFontOfSize:15];
    }
    return _textView;
}

-(UILabel *)currentEnvTextLabel{
    if (!_currentEnvTextLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = [UIColor redColor];
        
        _currentEnvTextLabel = label;
    }
    return _currentEnvTextLabel;
}

-(UILabel *)currentEnvNameLabel{
    if (!_currentEnvNameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = [UIColor redColor];
        _currentEnvNameLabel = label;
    }
    return _currentEnvNameLabel;
}

-(UILabel *)currentModuleLabel{
    if (!_currentModuleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = [UIColor redColor];
        _currentModuleLabel = label;
    }
    return _currentModuleLabel;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"❌取消❌" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = 0;
        btn.layer.cornerRadius = 25;
        _cancelBtn = btn;
    }
    return _cancelBtn;
}

-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"✅保存✅" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = 1;
        btn.layer.cornerRadius = 25;
        _confirmBtn = btn;
    }
    return _confirmBtn;
}

#pragma mark - business action

-(void)clickBtn:(UIButton *)btn{
    if (btn.tag == 0) {
        NSLog(@"cancel");
        [self removeFromSuperview];
    }else{
        NSLog(@"保存");
        
        if (self.textView.text.length > 0) {
            
            [self.editModel editWithNewUrl:self.textView.text];
            if (self.editBlock) {
                self.editBlock();
            }
        }
        [self removeFromSuperview];
    }

}

-(void)reloadData{
    
    self.currentModuleLabel.text = [NSString stringWithFormat:@"当前模块：%@",self.editModel.moduleName];
    
    self.currentEnvNameLabel.text = [NSString stringWithFormat:@"当前环境：%@",[self.editModel getEnvNameWithUrl:self.editModel.editUrl]];
    
    self.currentEnvTextLabel.text = [NSString stringWithFormat:@"当前地址：%@",self.editModel.editUrl];
    
    self.currentNewEnvLabel.text = [NSString stringWithFormat:@"新地址：%@",@""];
    
}

-(void)addInputAccessViewWithTextField:(UITextView *)textView
{
    UIToolbar * toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.0f)];
    toobar.translucent = YES;
    toobar.barStyle = UIBarStyleDefault;
    UIBarButtonItem * spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭键盘" style:UIBarButtonItemStyleDone target:self action:@selector(closekeyboard)];
    [toobar setItems:@[spaceBarButtonItem,doneBarButtonItem]];
    textView.inputAccessoryView = toobar;
}

-(void)closekeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
@end
