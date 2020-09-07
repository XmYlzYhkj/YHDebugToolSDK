//
//  YHDebugToolView.m
//  FLEX
//
//  Created by zxl on 2020/9/3.
//

#import "YHDebugToolView.h"
#import <UIKit/UIKit.h>
#import "YHDebugToolManger.h"
#import "YHDebugToolEnvModel.h"
#import "YHDebugToolEnvEditView.h"

@interface YHDebugToolView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)UIButton *closeBtn;

@end

@implementation YHDebugToolView

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
//    self.layer.borderColor = [UIColor blueColor].CGColor;
//    self.layer.borderWidth = 1;
}

-(void)createView{
    [self addSubview:self.tableview];
    
    [self addSubview:self.closeBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    self.tableview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) - 50);
    
    self.closeBtn.frame = CGRectMake(0, CGRectGetHeight(self.tableview.frame), CGRectGetWidth(frame), 50);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + [YHDebugToolManger shareInstance].envModelForModules.allKeys.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"打开网络调试工具";
        }else{
            cell.textLabel.text = @"打开开发环境调试工具";
        }
        
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个",indexPath.row];
    cell.textLabel.text = [self getCellText:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 ) {
        return 2;
    }else{

        return 4;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [YHDebugToolManger showNetDebugView];
        }
    }else{
        
        YHDebugToolEnvModel *model = [self getEnvModelWithIndexPath:indexPath];
        
        model.currentUrl = [self getEnvUrlByRow:indexPath.row withModel:model];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = model.currentUrl;
        
        [tableView reloadData];
        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"弹窗" message:@"进入编辑界面" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:cancelAction];
//
//        UIApplication *app = [UIApplication sharedApplication];
//        [app.delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
//        [UIScreen mainScreen] bounds]
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    
    if (section == 0) {
        headerView.textLabel.text = @"菜单列表";
    }else{
        NSArray *array = [YHDebugToolManger shareInstance].envModelForModules.allKeys;
        
        headerView.textLabel.text = [NSString stringWithFormat:@"模块：%@",array[section - 1]];
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleInsert;
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //编辑
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        YHDebugToolEnvEditView *editView = [[YHDebugToolEnvEditView alloc] initWithFrame:self.bounds];
        
        [self addSubview:editView];
        
        NSLog(@"点击了编辑");
    }];
    editRowAction.backgroundColor = [UIColor purpleColor];
    
    if(indexPath.section > 0)
    {
        return @[editRowAction];
    }
    
    return @[];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{return YES;
    if (indexPath.section > 0) {
        return YES;
    }
    return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (editingStyle == UITableViewCellEditingStyleInsert) {
//        NSLog(@"styleNone");
//    }
//}

#pragma mark - lazy loading

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:@"❌关闭调试界面❌" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.layer.borderColor = [UIColor redColor].CGColor;
        _closeBtn.layer.borderWidth = 1;
        
    }
    return _closeBtn;
}

-(UITableView *)tableview{
    if (!_tableview) {
        UITableView *tableview = [[UITableView alloc] init];
        [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
        tableview.delegate = self;
        tableview.dataSource = self;
        _tableview = tableview;
    }
    return _tableview;
}

#pragma mark - business acton

-(NSString *)getCellText:(NSIndexPath *)indexPath{
    NSArray *array = [YHDebugToolManger shareInstance].envModelForModules.allKeys;
    
    NSString *moduleKey = array[indexPath.section - 1];
    
    YHDebugToolEnvModel *model = [YHDebugToolManger shareInstance].envModelForModules[moduleKey];
    
    NSString *envUrl = [self getEnvUrlByRow:indexPath.row withModel:model];
    
    NSString *check = [model.currentUrl isEqualToString:envUrl]? @"✅":@"";
    return [NSString stringWithFormat:@"%@%@:%@",
            check,
            [self getEnvNameByRow:indexPath.row],
            envUrl];
}

-(NSString *)getEnvNameByRow:(NSInteger)row{
    switch (row) {
        case 0:
            return @"正式环境";
            break;
        case 1:
            return @"开发环境";
            break;
        case 2:
            return @"测试环境";
        break;
        case 3:
            return @"预正式环境";
        break;
        default:
            break;
    }
    return @"未知环境";
}

-(NSString *)getEnvUrlByRow:(NSInteger)row withModel:(YHDebugToolEnvModel *)model{
    switch (row) {
        case 0:
            return model.productUrl;
            break;
        case 1:
            return model.devUrl;
            break;
        case 2:
        return model.testUrl;
            break;
        case 3:
            return model.pre_productUrl;
        break;
        default:
            break;
    }
    return @"地址为空";
}

-(YHDebugToolEnvModel *)getEnvModelWithIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [YHDebugToolManger shareInstance].envModelForModules.allKeys;
    NSString *moduleKey = array[indexPath.section - 1];
    YHDebugToolEnvModel *model = [YHDebugToolManger shareInstance].envModelForModules[moduleKey];
    
    return model;
}

#pragma mark - business action

-(void)closeView{
    [self removeFromSuperview];
}

@end
