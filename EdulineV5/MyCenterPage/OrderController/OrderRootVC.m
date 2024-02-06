//
//  OrderRootVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "OrderRootVC.h"
#import "OrderTypeViewController.h"
#import "V5_Constant.h"
#import "OrderScreenViewController.h"

@interface OrderRootVC ()<UIScrollViewDelegate,OrderScreenViewControllerDelegate> {
    NSInteger currentSelect;
    
    // 筛选
    NSString *screenTitle;
    NSString *screenType;
}

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIButton *allButton;
@property (strong, nonatomic) UIButton *needDealButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *finishButton;
@property (strong, nonatomic) UIButton *otherButton;
@property (strong, nonatomic) NSMutableArray *typeArray;

@property (strong, nonatomic) UIScrollView *mainScrollView;

// 存放整个列表类型的时间选择记录
@property (strong, nonatomic) NSMutableArray *timeTypeArray;

@end

@implementation OrderRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"我的订单";
    _rightButton.hidden = NO;
    [_rightButton setImage:[Image(@"lesson_screen_sel") converToMainColor] forState:0];
    currentSelect = 0;
    _typeArray = [NSMutableArray new];
//    _timeTypeArray = [NSMutableArray new];
    
//    [_timeTypeArray addObjectsFromArray:@[@{@"title":@"全部",@"type":@"all",@"timeType":@"",@"timeTitle":@""},@{@"title":@"待支付",@"type":@"waiting",@"timeType":@"",@"timeTitle":@""},@{@"title":@"已取消",@"type":@"cancel",@"timeType":@"",@"timeTitle":@""},@{@"title":@"已完成",@"type":@"finish",@"timeType":@"",@"timeTitle":@""}]];
    
    [_typeArray addObjectsFromArray:@[@{@"title":@"全部",@"type":@"all"},@{@"title":@"已支付",@"type":@"finish"},@{@"title":@"待支付",@"type":@"waiting"},@{@"title":@"已取消",@"type":@"cancel"}]];
    
    [self makeTopView];
    [self makeScrollView];
}

- (void)makeTopView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 45)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 / 2.0 + 7 + 5, 20, 2)];
    _lineView.backgroundColor = EdlineV5_Color.baseColor;
    [_topView addSubview:_lineView];
    CGFloat WW = MainScreenWidth / _typeArray.count;
    for (int i = 0; i<_typeArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*WW, 0, WW, _topView.height)];
        [btn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
        [btn setTitleColor:EdlineV5_Color.baseColor forState:UIControlStateSelected];
        btn.titleLabel.font = SYSTEMFONT(14);
        btn.tag = i;
        [btn setTitle:[_typeArray[i] objectForKey:@"title"] forState:0];
        [btn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([_currentType isEqualToString:[_typeArray[i] objectForKey:@"type"]]) {
            btn.selected = YES;
            _lineView.centerX = btn.centerX;
            currentSelect = i;
        } else {
            btn.selected = NO;
        }
        if (i == 0) {
            _allButton = btn;
        } else if (i == 1) {
            _needDealButton = btn;
        } else if (i == 2) {
            _cancelButton = btn;
        } else if (i == 3) {
            _finishButton = btn;
        } else if (i == 4) {
            _otherButton = btn;
        }
        [_topView addSubview:btn];
    }
    [_topView bringSubviewToFront:_lineView];
}

- (void)makeScrollView {
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,_topView.bottom, MainScreenWidth, MainScreenHeight - _topView.bottom)];
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth*_typeArray.count, 0);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    for (int i = 0; i<_typeArray.count; i++) {
        OrderTypeViewController *vc = [[OrderTypeViewController alloc] init];
        vc.orderType = [NSString stringWithFormat:@"%@",[_typeArray[i] objectForKey:@"type"]];
        vc.view.frame = CGRectMake(MainScreenWidth*i, 0, MainScreenWidth, _mainScrollView.height);
        [_mainScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
    [self.mainScrollView setContentOffset:CGPointMake(MainScreenWidth * currentSelect, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        if (scrollView.contentOffset.x <= 0) {
            self.lineView.centerX = self.allButton.centerX;
            self.allButton.selected = YES;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = NO;
            self.finishButton.selected = NO;
            self.otherButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.lineView.centerX = self.cancelButton.centerX;
            self.allButton.selected = NO;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = YES;
            self.finishButton.selected = NO;
            self.otherButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            self.lineView.centerX = self.needDealButton.centerX;
            self.allButton.selected = NO;
            self.needDealButton.selected = YES;
            self.cancelButton.selected = NO;
            self.finishButton.selected = NO;
            self.otherButton.selected = NO;
        }else if (scrollView.contentOffset.x >= 3*MainScreenWidth && scrollView.contentOffset.x <= 3*MainScreenWidth){
            self.lineView.centerX = self.finishButton.centerX;
            self.allButton.selected = NO;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = NO;
            self.finishButton.selected = YES;
            self.otherButton.selected = NO;
        }else if (scrollView.contentOffset.x >= 4*MainScreenWidth){
            self.lineView.centerX = self.otherButton.centerX;
            self.allButton.selected = NO;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = NO;
            self.finishButton.selected = NO;
            self.otherButton.selected = YES;
        }
    }
}

- (void)topButtonClick:(UIButton *)sender {
    [self.mainScrollView setContentOffset:CGPointMake(MainScreenWidth * sender.tag, 0) animated:YES];
}

- (void)rightButtonClick:(id)sender {
    _rightButton.selected = !_rightButton.selected;
    if (_rightButton.selected) {
        OrderScreenViewController *vc = [[OrderScreenViewController alloc] init];
        vc.delegate = self;
//        NSInteger index = _mainScrollView.contentOffset.x / MainScreenWidth;
//        NSString *currentOrderType = [_typeArray[index] objectForKey:@"type"];
//        for (int i = 0; i<_timeTypeArray.count; i++) {
//            if ([[_timeTypeArray[i] objectForKey:@"type"] isEqualToString:currentOrderType]) {
//                vc.screenTitle = [_timeTypeArray[i] objectForKey:@"timeTitle"];
//                vc.screenType = [_timeTypeArray[i] objectForKey:@"timeType"];
//                break;
//            }
//        }
        vc.notHiddenNav = NO;
        vc.hiddenNavDisappear = YES;
        vc.screenTitle = screenTitle;
        vc.screenType = screenType;
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenOrderScreenAll" object:nil];
    }
}

- (void)sureChooseOrderScreen:(NSDictionary *)orderScreenInfo {
    if (SWNOTEmptyDictionary(orderScreenInfo)) {
        screenTitle = [NSString stringWithFormat:@"%@",[orderScreenInfo objectForKey:@"screenTitle"]];
        screenType = [NSString stringWithFormat:@"%@",[orderScreenInfo objectForKey:@"screenType"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenOrderScreenAll" object:nil];
        _rightButton.selected = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"relodOrderData" object:nil userInfo:@{@"orderTime":screenType}];
//        NSInteger index = _mainScrollView.contentOffset.x / MainScreenWidth;
//        NSString *currentOrderType = [_typeArray[index] objectForKey:@"type"];
//        [self changeTimeChooseData:screenTitle timeType:screenType];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"relodOrderData" object:nil userInfo:@{@"orderType":currentOrderType,@"orderTime":screenType}];
    }
}

// MARK: - 改变时间选择数组数据源
- (void)changeTimeChooseData:(NSString *)timeTitle timeType:(NSString *)timeType {
    NSInteger index = _mainScrollView.contentOffset.x / MainScreenWidth;
    NSString *currentOrderType = [_typeArray[index] objectForKey:@"type"];
    for (int i = 0; i<_timeTypeArray.count; i++) {
        if ([[_timeTypeArray[i] objectForKey:@"type"] isEqualToString:currentOrderType]) {
            NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_timeTypeArray[i]];
            [pass setObject:timeTitle forKey:@"timeTitle"];
            [pass setObject:timeType forKey:@"timeType"];
            [_timeTypeArray replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:pass]];
            break;
        }
    }
}

@end
