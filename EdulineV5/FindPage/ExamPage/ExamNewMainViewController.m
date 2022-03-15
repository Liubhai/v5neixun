//
//  ExamNewMainViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/10.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "ExamNewMainViewController.h"
#import "V5_Constant.h"
#import "ExamNewMainCateListVC.h"
#import "V5_UserModel.h"
#import "AppDelegate.h"
#import "Net_Path.h"

@interface ExamNewMainViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIButton *pastBtn;// 记录上一个按钮 用于判断是左滑还是右滑

@property (strong, nonatomic) UIView *topCateView;
@property (strong, nonatomic) UIScrollView *topScrollView;
@property (strong, nonatomic) UIView *cateSelectLineView;

@property (strong, nonatomic) UIScrollView *mainScrollView;//容器

@property (strong, nonatomic) NSMutableArray *cateArray;

@end

@implementation ExamNewMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.text = @"考试";
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    
    _rightButton.hidden = YES;
    _lineTL.hidden = YES;
    
//    _cateArray = [NSMutableArray new];
//    [_cateArray addObjectsFromArray:@[@{@"title":@"语文系汉语言学院",@"id":@"1"},@{@"title":@"数学",@"id":@"2"},@{@"title":@"英语",@"id":@"3"},@{@"title":@"物理系动力与平衡学院",@"id":@"4"},@{@"title":@"生物大学临床学院",@"id":@"5"},@{@"title":@"化学",@"id":@"6"}]];
    
//    [self makeTopCateView];
    [self makeScrollView];
//    [self getExamFirstTypeInfo];
}

- (void)makeTopCateView {
    _topCateView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 45)];
    _topCateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topCateView];
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 45)];
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    [_topCateView addSubview:_topScrollView];
    
    _cateSelectLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 / 2.0 + 7 + 5, 20, 2)];
    _cateSelectLineView.backgroundColor = EdlineV5_Color.baseColor;
    
    [self makeCateUI];
    
    [_topScrollView addSubview:_cateSelectLineView];
}

// MARK: - 构建分类视图
- (void)makeCateUI {
    [_topScrollView removeAllSubviews];
    CGFloat xx = 0.0;
    CGFloat ww = 0.0;
    for (int i = 0; i<_cateArray.count; i++) {
        
        ww = [[NSString stringWithFormat:@"%@",[_cateArray[i] objectForKey:@"title"]] sizeWithFont:SYSTEMFONT(16)].width + 28;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(xx, 0, ww, 44)];
        [btn setTitleColor:EdlineV5_Color.textFirstColor forState:UIControlStateSelected];
        [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
        btn.titleLabel.font = SYSTEMFONT(16);
        btn.tag = 66 + i;
        [btn setTitle:[_cateArray[i] objectForKey:@"title"] forState:0];
        [btn addTarget:self action:@selector(cateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            _cateSelectLineView.centerX = btn.centerX;
            btn.selected = YES;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];//SYSTEMFONT(18);
            _pastBtn = btn;
        }
        [_topScrollView addSubview:btn];
        xx = xx + ww;
        if (i == (_cateArray.count - 1)) {
            _topScrollView.contentSize = CGSizeMake(xx, 0);
        }
    }
}

- (void)makeScrollView {
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth, 0);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    ExamNewMainCateListVC *vc = [[ExamNewMainCateListVC alloc] init];
    vc.mainTypeArray = [NSMutableArray arrayWithArray:_cateArray];
    vc.view.frame = CGRectMake(0, 0, MainScreenWidth, _mainScrollView.height);
    [_mainScrollView addSubview:vc.view];
    [self addChildViewController:vc];
    
//    for (int i = 0; i<_cateArray.count; i++) {
//        ExamNewMainCateListVC *vc = [[ExamNewMainCateListVC alloc] init];
//        vc.circleType = [NSString stringWithFormat:@"%@",[_cateArray[i] objectForKey:@"id"]];
//        vc.mainTypeArray = [NSMutableArray arrayWithArray:_cateArray];
//        vc.mainSelectDict = [NSMutableDictionary dictionaryWithDictionary:_cateArray[i]];
//        vc.view.frame = CGRectMake(MainScreenWidth*i, 0, MainScreenWidth, _mainScrollView.height);
//        [_mainScrollView addSubview:vc.view];
//        [self addChildViewController:vc];
//    }
}

// MARK: - 滚动和点击事件最终逻辑
- (void)cateExchanged:(UIButton *)sender {
    
//    CGPoint btnPoint = [_topScrollView convertPoint:CGPointMake(sender.origin.x, sender.origin.y) toView:_topCateView];
    // 还需要继续优化成 首先分成 左滑 右滑 
    if ((sender.right - _topScrollView.contentOffset.x) >= MainScreenWidth) {
        
        if (sender.tag > _pastBtn.tag) {
            // 右滑动
            if ((sender.tag - 66) < (_cateArray.count - 1)) {
                // 每次多移动一个按钮宽度
                UIButton *nextBtn = [_topScrollView viewWithTag:sender.tag + 1];
                [_topScrollView setContentOffset:CGPointMake((_topScrollView.contentOffset.x + ((sender.right - _topScrollView.contentOffset.x) - MainScreenWidth) + nextBtn.width), 0)];
            }
        } else if (sender.tag < _pastBtn.tag) {
            // 左滑动
            
        } else {
            
        }
    } else if ((sender.right - _topScrollView.contentOffset.x) < sender.width) {
        if ((sender.tag - 66) == 0) {
            // 每次多移动一个按钮宽度
            [_topScrollView setContentOffset:CGPointMake(0, 0)];
        } else if ((sender.tag - 66) > 0) {
            UIButton *btn = [_topScrollView viewWithTag:sender.tag - 1];
            [_topScrollView setContentOffset:CGPointMake(_topScrollView.contentOffset.x - btn.width - (sender.right - _topScrollView.contentOffset.x), 0)];
        }
    }
    
    for (UIButton *object in _topScrollView.subviews) {
        if ([object isKindOfClass:[UIButton class]]) {
            if (object.tag == sender.tag) {
                object.selected = YES;
                object.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
            } else {
                object.selected = NO;
                object.titleLabel.font = SYSTEMFONT(16);
            }
        }
    }
    if (_cateSelectLineView) {
        [UIView animateWithDuration:0.2 animations:^{
            
        } completion:^(BOOL finished) {
            self.cateSelectLineView.centerX = sender.centerX;
        }];
    }
}


// MARK: - 分类按钮点击事件
- (void)cateButtonClick:(UIButton *)sender {
    [self.mainScrollView setContentOffset:CGPointMake(MainScreenWidth * (sender.tag - 66), 0) animated:YES];
    [self cateExchanged:sender];
    _pastBtn = sender;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / MainScreenWidth;
    self.mainScrollView.contentOffset = CGPointMake(index * MainScreenWidth, 0);
    [self cateExchanged:[_topCateView viewWithTag:index + 66]];
    _pastBtn = [_topCateView viewWithTag:index + 66];
}

- (void)getExamFirstTypeInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path examFirstTypeNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]) {
            [_cateArray removeAllObjects];
            [_cateArray addObjectsFromArray:responseObject[@"data"]];
            [self makeTopCateView];
            [self makeScrollView];
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

@end
