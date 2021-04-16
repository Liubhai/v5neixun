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

@interface GroupListPopViewController ()<GrouListCellDelegate> {
    NSInteger timeCount;
    NSTimer *groupTimer;
}

@end

@implementation GroupListPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
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
    
    groupTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(eventCellTimerDown) userInfo:nil repeats:YES];
    
    _groupTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tableView.left, _tableView.top - 40 + 3, MainScreenWidth - 60, 40)];
    _groupTitleLabel.text = @"正在开团";
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
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"groulistcell";
    GrouListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GrouListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    [cell setGroupListInfo:_dataSource[indexPath.row] timeCount:timeCount];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;//_dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// MARK: - 加入团的点击事件 GrouListCellDelegate
- (void)joinGroupByGroupId:(NSString *)groupID groupInfo:(NSDictionary *)groupInfo {
//    ClassAndLivePayViewController *vc = [[ClassAndLivePayViewController alloc] init];
//    vc.dict = _videoDataSource;
//    vc.typeStr = _courseType;
//    vc.cid = [_videoDataSource stringValueForKey:@"id"];
//    vc.activityInfo = [NSDictionary dictionaryWithDictionary:_activityInfo];
//    vc.isJoinGroup = YES;
//    vc.isBuyAlone = YES;
//    [self.parentViewController.navigationController pushViewController:vc animated:YES];
    GroupDetailViewController *vc = [[GroupDetailViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)applyPintuan {
    OrderViewController *vc = [[OrderViewController alloc] init];
    vc.orderTypeString = @"course";
    vc.orderId = _courseId;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
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

@end
