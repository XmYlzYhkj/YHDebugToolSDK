//
//  YHDebugToolEnvListView.m
//  FLEX
//
//  Created by zxl on 2020/9/7.
//

#import "YHDebugToolEnvListView.h"

#import "YHDebugToolManger.h"
#import "YHDebugToolEnvModel.h"
#import "YHDebugToolEnvEditView.h"

@interface YHDebugToolEnvListView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)UIButton *closeBtn;

@end

@implementation YHDebugToolEnvListView

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
    return [YHDebugToolManger shareInstance].envModelForModules.allKeys.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [self getCellText:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    YHDebugToolEnvModel *model = [self getEnvModelWithIndexPath:indexPath];
    
    model.currentUrl = [self getEnvUrlByRow:indexPath.row withModel:model];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = model.currentUrl;
    
    [tableView reloadData];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[YHDebugToolManger shareInstance] saveEnvData];
    });
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    
    NSArray *array = [YHDebugToolManger shareInstance].envModelForModules.allKeys;
    
    headerView.textLabel.text = [NSString stringWithFormat:@"模块：%@",array[section]];
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
        
        YHDebugToolEnvModel *model = [self getEnvModelWithIndexPath:indexPath];
        model.editUrl = [self getEnvUrlByRow:indexPath.row withModel:model];
        
        YHDebugToolEnvEditView *editView = [[YHDebugToolEnvEditView alloc] initWithModel:model];
        [editView setEditBlock:^{
            [self.tableview reloadData];
        }];
        editView.frame = self.bounds;
        
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
{
    return YES;
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
        [_closeBtn setTitle:@"⬅️返回功能界面⬅️" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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
    
    NSString *moduleKey = array[indexPath.section];
    
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
    NSString *moduleKey = array[indexPath.section];
    YHDebugToolEnvModel *model = [YHDebugToolManger shareInstance].envModelForModules[moduleKey];
    
    return model;
}

#pragma mark - business action

-(void)closeView{
    [self removeFromSuperview];
}

@end
