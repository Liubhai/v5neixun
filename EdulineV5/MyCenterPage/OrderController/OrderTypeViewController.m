//
//  OrderTypeViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "OrderTypeViewController.h"
#import "OrderCell.h"
#import "OrderFinalCell.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "OrderSureViewController.h"
#import "CourseMainViewController.h"

@interface OrderTypeViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger page;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation OrderTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [NSMutableArray new];
    page = 1;
    [self makeTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderList) name:@"reloadOrderList" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getOrderList)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreOrderList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section][@"products"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"OrderFinalCell";
    OrderFinalCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[OrderFinalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    [cell setOrderFinalInfo:_dataSource[indexPath.section][@"products"][indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *orderNum = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 30, 39.5)];
    orderNum.font = SYSTEMFONT(14);
    orderNum.textColor = EdlineV5_Color.textSecendColor;
    orderNum.text = [NSString stringWithFormat:@"订单号：%@",_dataSource[section][@"order_no"]];//@"订单号：AWN8923779294";
    [view addSubview:orderNum];
    
    UILabel *orderStatus = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, 0, 100, 39.5)];
    orderStatus.textAlignment = NSTextAlignmentRight;
    orderStatus.font = SYSTEMFONT(14);
    orderStatus.text = [NSString stringWithFormat:@"%@",_dataSource[section][@"status_text"]];
    [view addSubview:orderStatus];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 39.5, MainScreenWidth - 15, 0.5)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [view addSubview:line];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 97.5)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth - 15, 0.5)];
    line2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [view addSubview:line2];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, line2.bottom + 12, 150, 16)];
    timeLabel.font = SYSTEMFONT(12);
    timeLabel.textColor = EdlineV5_Color.textSecendColor;
    timeLabel.text = [NSString stringWithFormat:@"%@",[EdulineV5_Tool formateTime:_dataSource[section][@"create_time"]]];
    [view addSubview:timeLabel];
    
    UILabel *truePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 80, 0, 80, 21)];
    truePriceLabel.centerY = timeLabel.centerY;
    truePriceLabel.textColor = EdlineV5_Color.faildColor;
    truePriceLabel.font = SYSTEMFONT(14);
    truePriceLabel.text = [NSString stringWithFormat:@"¥%@",_dataSource[section][@"payment"]];
    [view addSubview:truePriceLabel];
    
    UILabel *trueLabel = [[UILabel alloc] initWithFrame:CGRectMake(truePriceLabel.left - 40, 0, 40, 21)];
    trueLabel.centerY = timeLabel.centerY;
    trueLabel.textColor = EdlineV5_Color.textSecendColor;
    trueLabel.font = SYSTEMFONT(14);
    trueLabel.text = @"实付:";
    trueLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:trueLabel];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = section;
    button2.frame = CGRectMake(MainScreenWidth - 15 - 70, truePriceLabel.bottom + 13, 70, 28);
    [button2 setTitle:@"去支付" forState:0];
    button2.titleLabel.font = SYSTEMFONT(12);
    [button2 setTitleColor:[UIColor whiteColor] forState:0];
    button2.backgroundColor = EdlineV5_Color.baseColor;
    button2.layer.masksToBounds = YES;
    button2.layer.cornerRadius = button2.height / 2.0;
    [button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button2];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.tag = section;
    button1.frame = CGRectMake(button2.left - 12 - 70, truePriceLabel.bottom + 13, 70, 28);
    button1.titleLabel.font = SYSTEMFONT(12);
    [button1 setTitle:@"删除订单" forState:0];
    [button1 setTitleColor:EdlineV5_Color.baseColor forState:0];
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = button1.height / 2.0;
    button1.layer.borderWidth = 1;
    button1.layer.borderColor = EdlineV5_Color.baseColor.CGColor;
    [button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
    
    button1.hidden = NO;
    button2.hidden = NO;
    
    NSString *orderStatus = [NSString stringWithFormat:@"%@",_dataSource[section][@"status"]];
    if ([orderStatus isEqualToString:@"0"]) {
        // 已取消
        button2.hidden = YES;
        button1.frame = CGRectMake(MainScreenWidth - 15 - 70, truePriceLabel.bottom + 13, 70, 28);
        [button1 setTitle:@"删除订单" forState:0];
    } else if ([orderStatus isEqualToString:@"10"]) {
        // 待支付
        [button2 setTitle:@"去支付" forState:0];
        button1.hidden = YES;
    } else if ([orderStatus isEqualToString:@"20"]) {
        // 已完成
        button2.hidden = YES;
        button1.hidden = YES;
        [view setHeight:43.5 + 8];
    } else if ([orderStatus isEqualToString:@"30"]) {
        
    } else if ([orderStatus isEqualToString:@"40"]) {
        
    } else if ([orderStatus isEqualToString:@"50"]) {
        
    } else if ([orderStatus isEqualToString:@"60"]) {
        
    }
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 8, MainScreenWidth, 8)];
    line1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [view addSubview:line1];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString *orderStatus = [NSString stringWithFormat:@"%@",_dataSource[section][@"status"]];
    if ([orderStatus isEqualToString:@"20"]) {
        // 已完成
        return 0.5 + 43 + 8;
    }
    return 0.5 + 89 + 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *pass = _dataSource[indexPath.section][@"products"][indexPath.row];
    NSString *courseType = [NSString stringWithFormat:@"%@",[pass objectForKey:@"course_type"]];
    //课程类型【1：点播；2：直播；3：面试；4：班级；】
    if ([courseType isEqualToString:@"1"]) {
        CourseMainViewController *vc = [[CourseMainViewController alloc] init];
        vc.ID = [NSString stringWithFormat:@"%@",[pass objectForKey:@"id"]];
        vc.courselayer = [NSString stringWithFormat:@"%@",[pass objectForKey:@"section_level"]];
        vc.isLive = [[NSString stringWithFormat:@"%@",[pass objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
        vc.courseType = [NSString stringWithFormat:@"%@",[pass objectForKey:@"course_type"]];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([courseType isEqualToString:@"2"]) {
        
    } else if ([courseType isEqualToString:@"3"]) {
        
    } else if ([courseType isEqualToString:@"4"]) {
        
    }
    
}

- (void)getOrderList {
    if (SWNOTEmptyStr(_orderType)) {
        page = 1;
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path userOrderList:_orderType] WithAuthorization:nil paramDic:@{@"page":@(page),@"count":@"10"} finish:^(id  _Nonnull responseObject) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                }
            }
            if (_dataSource.count<10) {
                _tableView.mj_footer.hidden = YES;
            } else {
                _tableView.mj_footer.hidden = NO;
            }
            [_tableView reloadData];
        } enError:^(NSError * _Nonnull error) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
        }];
    }
}

- (void)getMoreOrderList {
    if (SWNOTEmptyStr(_orderType)) {
        page = page + 1;
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path userOrderList:_orderType] WithAuthorization:nil paramDic:@{@"page":@(page),@"count":@"10"} finish:^(id  _Nonnull responseObject) {
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                    [_dataSource addObjectsFromArray:pass];
                    if (pass.count<10) {
                        _tableView.mj_footer.hidden = YES;
                    } else {
                        _tableView.mj_footer.hidden = NO;
                    }
                }
            }
            [_tableView reloadData];
        } enError:^(NSError * _Nonnull error) {
            page--;
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
        }];
    }
}

- (void)button1Click:(UIButton *)sender {
    
}

- (void)button2Click:(UIButton *)sender {
    OrderSureViewController *vc = [[OrderSureViewController alloc] init];
    vc.order_no = [NSString stringWithFormat:@"%@",_dataSource[sender.tag][@"order_no"]];
    vc.payment = [NSString stringWithFormat:@"%@",_dataSource[sender.tag][@"payment"]];
    vc.orderTypeString = @"orderList";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
