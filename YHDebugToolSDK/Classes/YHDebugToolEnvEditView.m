//
//  YHDebugToolEnvEditView.m
//  FLEX
//
//  Created by zxl on 2020/9/4.
//

#import "YHDebugToolEnvEditView.h"

#import "YHDebugToolSDK.h"


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
    
    self.currentModuleLabel.frame = [self frameWithNum:0];
    
    self.currentEnvNameLabel.frame = [self frameWithNum:1];
    
    self.currentEnvTextLabel.frame = [self frameWithNum:2];
    
    self.currentNewEnvLabel.frame = [self frameWithNum:3];
    
    self.textView.frame = [self frameWithNum:4];;
    
    CGRect frame = self.frame;
    
    CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height + 44 + 270;
    
    CGFloat width = CGRectGetWidth(frame)/2;
    
    self.cancelBtn.frame = CGRectMake(10, y, width - 20, 50);
    
    self.confirmBtn.frame = CGRectMake(width + 10, y, width - 20, 50);
    
    [self reloadData];
}

-(CGRect)frameWithNum:(NSInteger)num{
    
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width - 40;
    
    return CGRectMake(20, [UIApplication sharedApplication].statusBarFrame.size.height + 44 + 50 * num, labelWidth, 50);
}

#pragma mark - lazy loading

-(UILabel *)currentNewEnvLabel{
    if (!_currentNewEnvLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor brownColor];
        label.numberOfLines = 0;
        _currentNewEnvLabel = label;
    }
    return _currentNewEnvLabel;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = [UIColor brownColor];
        _textView.delegate = self;
        _textView.layer.borderColor = [UIColor brownColor].CGColor;
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
        label.numberOfLines = 0;
        _currentEnvTextLabel = label;
    }
    return _currentEnvTextLabel;
}

-(UILabel *)currentEnvNameLabel{
    if (!_currentEnvNameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = [UIColor redColor];
        label.numberOfLines = 0;
        _currentEnvNameLabel = label;
    }
    return _currentEnvNameLabel;
}

-(UILabel *)currentModuleLabel{
    if (!_currentModuleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = [UIColor redColor];
        label.numberOfLines = 0;
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
    
    [YHDebugToolManger showFeedbackLight];
    
    if (btn.tag == 0) {
        NSLog(@"cancel");
        [self removeFromSuperview];
    }else{
        NSLog(@"保存");
        
        if (self.textView.text.length == 0) {
            [YHDebugToolManger showTipAlertWithTitle:@"温馨提示" withMessage:@"请输入新地址"];
            return;
        }
        
        [self.editModel resetWithNewUrl:self.textView.text toEnv:self.editModel.editEnvType];
        [YHDebugToolManger showTipAlertWithTitle:@"保存成功" withMessage:[NSString stringWithFormat:@"模块：%@\n环境：%@\n新地址：%@",self.editModel.moduleName,[self.editModel getEditEnvName],self.textView.text]];
        
        if (self.editBlock) {
            self.editBlock();
        }
        [self removeFromSuperview];
    }

}

-(void)reloadData{
    
    self.currentModuleLabel.text = [NSString stringWithFormat:@"编辑模块：%@",self.editModel.moduleName];
    
    self.currentEnvNameLabel.text = [NSString stringWithFormat:@"编辑环境：%@",[self.editModel getEditEnvName]];

    self.currentEnvTextLabel.text = [NSString stringWithFormat:@"当前地址：%@",[self.editModel getEditEnvUrl]];
    
    NSString *cacheInfo = @"临时缓存,app重启后将还原";
    if (self.editModel.editEnvType == YHDebugToolEnvTypeLocalCache) {
        cacheInfo = @"永久缓存,app重启后继续保留";
    }
    self.currentNewEnvLabel.text = [NSString stringWithFormat:@"新地址：%@",cacheInfo];
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
