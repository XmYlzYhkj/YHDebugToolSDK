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
    return [YHDebugToolManger getAllModluleIds].count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [self getCellText:indexPath];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    YHDebugToolEnvModel *model = [self getEnvModelWithIndexPath:indexPath];
    model.currentEnvType = indexPath.row;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if ([model getCurrentEnvUrl] != nil) {
        pasteboard.string = [model getCurrentEnvUrl];
    }
    
    [tableView reloadData];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[YHDebugToolManger shareInstance] saveEnvData];
        
    });
    
    NSString *message = [NSString stringWithFormat:@"已成功切换到：%@\n%@",[model getCurrentEnvName],[model getCurrentEnvUrl]];
    [YHDebugToolManger showTipAlertWithTitle:model.moduleName withMessage:message];
    
    [YHDebugToolManger showFeedbackLight];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    
    NSArray *array = [YHDebugToolManger getAllModluleIds];
    
    YHDebugToolEnvModel *model = [YHDebugToolManger getModuleEnvModelWithId:array[section]];
    
    headerView.textLabel.text = [NSString stringWithFormat:@"模块：%@_%@",model.moduleName,model.moduleId];
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //编辑
    UITableViewRowAction *copyRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"复制" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        YHDebugToolEnvModel *model = [self getEnvModelWithIndexPath:indexPath];
        model.currentEnvType = indexPath.row;
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        if ([model getCurrentEnvUrl] != nil) {
            pasteboard.string = [model getCurrentEnvUrl];
            
            [YHDebugToolManger showTipAlertWithTitle:[NSString stringWithFormat:@"%@_复制成功",model.moduleName] withMessage:pasteboard.string];
        }
        [YHDebugToolManger showFeedbackLight];
        NSLog(@"点击了复制");
    }];
    copyRowAction.backgroundColor = [UIColor systemPinkColor];
    
    //编辑
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        YHDebugToolEnvModel *model = [self getEnvModelWithIndexPath:indexPath];
        model.editEnvType = indexPath.row;
        
        YHDebugToolEnvEditView *editView = [[YHDebugToolEnvEditView alloc] initWithModel:model];
        [editView setEditBlock:^{
            [self.tableview reloadData];
        }];
        editView.frame = self.bounds;
        
        [self addSubview:editView];
        
        [YHDebugToolManger showFeedbackLight];
        NSLog(@"点击了编辑");
    }];
    
    editRowAction.backgroundColor = [UIColor purpleColor];
    
    return @[editRowAction,copyRowAction];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - lazy loading

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:@"⬅️返回主页⬅️" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setBackgroundColor:[UIColor brownColor]];
        
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
    NSArray *array = [YHDebugToolManger getAllModluleIds];
    
    NSString *moduleId = array[indexPath.section];
    
    YHDebugToolEnvModel *model = [YHDebugToolManger getModuleEnvModelWithId:moduleId];
    
    NSString *check = model.currentEnvType == indexPath.row? @"✅":@"";
    return [NSString stringWithFormat:@"%@%@:%@",
            check,
            [YHDebugToolEnvModel getEnvNameByType:indexPath.row],
            [model getEnvUrlByType:indexPath.row]];
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
            return model.preProductUrl;
        break;
        default:
            break;
    }
    return @"地址为空";
}

-(YHDebugToolEnvModel *)getEnvModelWithIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = [YHDebugToolManger getAllModluleIds];
    
    NSString *moduleId = array[indexPath.section];
    
    YHDebugToolEnvModel *model = [YHDebugToolManger getModuleEnvModelWithId:moduleId];
    return model;
}

#pragma mark - business action

-(void)closeView{
    [self removeFromSuperview];
    [YHDebugToolManger showFeedbackLight];
}

@end
