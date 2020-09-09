//
//  YHDebugToolView.m
//  FLEX
//
//  Created by zxl on 2020/9/3.
//

#import "YHDebugToolView.h"
#import <UIKit/UIKit.h>
#import "YHDebugToolManger.h"
#import "YHDebugToolEnvListView.h"

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
    
    [[YHDebugToolManger shareInstance] readEnvData];
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
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"网络抓包工具";
    }else{
        cell.textLabel.text = @"切换开发环境";
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        [YHDebugToolManger showNetDebugView];
    }else{
        YHDebugToolEnvListView *listView = [[YHDebugToolEnvListView alloc] initWithFrame:self.bounds];
        [self addSubview:listView];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    
    if (section == 0) {
        headerView.textLabel.text = @"调试功能列表";
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

#pragma mark - lazy loading

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:@"❌关闭调试界面❌" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _closeBtn.layer.borderWidth = 1;
        [_closeBtn setBackgroundColor:[UIColor whiteColor]];
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

#pragma mark - business action

-(void)closeView{
    [self removeFromSuperview];
}

@end
