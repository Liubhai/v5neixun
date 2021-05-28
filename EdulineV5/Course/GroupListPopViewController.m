//
//  GroupListPopViewController.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/23.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "GroupListPopViewController.h"
#import "GrouListCell.h"
#import "GroupDetailViewController.h"
#import "OrderViewController.h"
#import "Net_Path.h"

@interface GroupListPopViewController ()<GrouListCellDelegate> {
    NSInteger timeCount;
    NSTimer *groupTimer;
}

@end

@implementation GroupListPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _dataSource = [NSMutableArray new];
    timeCount = 0;
    if (groupTimer) {
        [groupTimer invalidate];
        groupTimer = nil;
    }
    _tableView = [[LBHTableView alloc] initWithFrame:CGRectMake(30, 0, MainScreenWidth - 60, 280)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 7;
    _tableView.centerY = MainScreenHeight / 2.0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _groupTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tableView.left, _tableView.top - 40 + 3, MainScreenWidth - 60, 40)];
    _groupTitleLabel.text = @"正在拼团";
    _groupTitleLabel.backgroundColor = [UIColor whiteColor];
    _groupTitleLabel.font = SYSTEMFONT(18);
    _groupTitleLabel.textColor = EdlineV5_Color.textFirstColor;
    _groupTitleLabel.textAlignment = NSTextAlignmentCenter;
    _groupTitleLabel.layer.masksToBounds = YES;
    UIBezierPath * path1 = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = _groupTitleLabel.bounds;
    maskLayer1.path = path1.CGPath;
    _groupTitleLabel.layer.mask = maskLayer1;
    [self.view addSubview:_groupTitleLabel];
    
    _applyPintuanButtonBackView = [[UIView alloc] initWithFrame:CGRectMake(_tableView.left, _tableView.bottom - 3, _tableView.width, 64)];
    _applyPintuanButtonBackView.backgroundColor = [UIColor whiteColor];
    _applyPintuanButtonBackView.layer.masksToBounds = YES;
    UIBezierPath * path2 = [UIBezierPath bezierPathWithRoundedRect:_applyPintuanButtonBackView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _groupTitleLabel.bounds;
    maskLayer2.path = path2.CGPath;
    _applyPintuanButtonBackView.layer.mask = maskLayer2;
    [self.view addSubview:_applyPintuanButtonBackView];
    
    
    _applyPintuanButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 16, MainScreenWidth - 45 * 2, 32)];
    [_applyPintuanButton setTitle:@"发起拼团" forState:0];
    [_applyPintuanButton setTitleColor:[UIColor whiteColor] forState:0];
    _applyPintuanButton.titleLabel.font = SYSTEMFONT(15);
    _applyPintuanButton.layer.masksToBounds = YES;
    _applyPintuanButton.layer.cornerRadius = 2.0;
    _applyPintuanButton.backgroundColor = EdlineV5_Color.courseActivityGroupColor;
    [_applyPintuanButtonBackView addSubview:_applyPintuanButton];
    [_applyPintuanButton addTarget:self action:@selector(applyPintuan) forControlEvents:UIControlEventTouchUpInside];
    
    // 关闭按钮
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _applyPintuanButtonBackView.bottom + 25, 44, 44)];
    _closeButton.centerX = MainScreenWidth / 2.0;
    [_closeButton setImage:Image(@"close_button_white") forState:0];
    [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
    [self getPintuanListData];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"groulistcell";
    GrouListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GrouListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setGroupListInfo:_dataSource[indexPath.row] timeCount:timeCount];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// MARK: - 加入团的点击事件 GrouListCellDelegate
- (void)joinGroupByGroupId:(NSString *)groupID groupInfo:(NSDictionary *)groupInfo {
    [self joinPintuanBeforeNet:groupID groupInfo:groupInfo];
}

- (void)applyPintuan {
    [self applyPintuanBeforeNet];
}

// MARK: - 关闭按钮
- (void)closeButtonClick {
    if (groupTimer) {
        [groupTimer invalidate];
        groupTimer = nil;
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)eventCellTimerDown {
    timeCount++;
    [_tableView reloadData];
}

// MARK: - 发起拼团前的一个请求
- (void)applyPintuanBeforeNet {
    if (SWNOTEmptyDictionary(_videoDataSource)) {
        if (SWNOTEmptyDictionary(_videoDataSource[@"promotion"])) {
            [Net_API requestPOSTWithURLStr:[Net_Path groupApplyNet] WithAuthorization:nil paramDic:@{@"promotion_id":[NSString stringWithFormat:@"%@",_videoDataSource[@"promotion"][@"id"]]} finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        OrderViewController *vc = [[OrderViewController alloc] init];
                        vc.orderTypeString = @"course";
                        vc.orderId = _courseId;
                        vc.isTuanGou = YES;
                        vc.promotion_id = [NSString stringWithFormat:@"%@",_videoDataSource[@"promotion"][@"id"]];
                        vc.orderInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                        [self.parentViewController.navigationController pushViewController:vc animated:YES];
                        [self closeButtonClick];
                    } else {
                        [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    }
                }
            } enError:^(NSError * _Nonnull error) {
                
            }];
        }
    }
}

// MARK: - 参加拼团前的一个请求
- (void)joinPintuanBeforeNet:(NSString *)tuanId groupInfo:(NSDictionary *)groupInfo {
    if (SWNOTEmptyStr(tuanId)) {
        [Net_API requestPOSTWithURLStr:[Net_Path joinPintuanNet] WithAuthorization:nil paramDic:@{@"tuan_id":tuanId} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    OrderViewController *vc = [[OrderViewController alloc] init];
                    vc.orderTypeString = @"course";
                    vc.orderId = _courseId;
                    vc.isTuanGou = YES;
                    vc.promotion_id = [NSString stringWithFormat:@"%@",groupInfo[@"promotion_id"]];
                    vc.orderInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                    [self.parentViewController.navigationController pushViewController:vc animated:YES];
                    [self closeButtonClick];
                } else {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 获取拼团列表
- (void)getPintuanListData {
    if (SWNOTEmptyDictionary(_videoDataSource)) {
        if (SWNOTEmptyDictionary(_videoDataSource[@"promotion"])) {
            NSString *promotionId = [NSString stringWithFormat:@"%@",_videoDataSource[@"promotion"][@"id"]];
            if (SWNOTEmptyStr(promotionId)) {
                [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.frame.size.height];
                [Net_API requestGETSuperAPIWithURLStr:[Net_Path pintuanListNet] WithAuthorization:nil paramDic:@{@"promotion_id":promotionId} finish:^(id  _Nonnull responseObject) {
                    if (SWNOTEmptyDictionary(responseObject)) {
                        if ([[responseObject objectForKey:@"code"] integerValue]) {
                            [_dataSource removeAllObjects];
                            [_dataSource addObjectsFromArray:responseObject[@"data"]];
                            [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.frame.size.height];
                            [_tableView reloadData];
                            if (_dataSource.count) {
                                groupTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(eventCellTimerDown) userInfo:nil repeats:YES];
                            }
                        }
                    }
                } enError:^(NSError * _Nonnull error) {
                    
                }];
            }
        }
    }
}

- (void)dealloc {
    if (groupTimer) {
        [groupTimer invalidate];
        groupTimer = nil;
    }
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        [groupTimer invalidate];
        groupTimer = nil;
    }
}

@end
