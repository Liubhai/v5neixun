//
//  CircleRootViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/5/14.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "CircleRootViewController.h"
#import "V5_Constant.h"
#import "CircleListVC.h"
#import "CirclePostViewController.h"
#import "V5_UserModel.h"
#import "AppDelegate.h"

@interface CircleRootViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIButton *recommendButton;// 推荐
@property (strong, nonatomic) UIButton *hotButton;// 推荐
@property (strong, nonatomic) UIButton *newestButton;// 推荐
@property (strong, nonatomic) UIView *lineView;//

@property (strong, nonatomic) UIScrollView *mainScrollView;//容器

@property (strong, nonatomic) NSMutableArray *typeArray;

@end

@implementation CircleRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.text = @"圈子";
    _rightButton.hidden = NO;
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"发布" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.layarLineColor;
    
    _typeArray = [NSMutableArray new];
    [_typeArray addObjectsFromArray:@[@{@"title":@"推荐",@"type":@"recommend"},@{@"title":@"广场",@"type":@"hot"},@{@"title":@"关注",@"type":@"newest"}]];
    
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
    CGFloat WW = 70;
    for (int i = 0; i<_typeArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*WW, 0, WW, _topView.height)];
        [btn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        [btn setTitleColor:EdlineV5_Color.baseColor forState:UIControlStateSelected];
        btn.titleLabel.font = SYSTEMFONT(18);
        btn.tag = 66 + i;
        [btn setTitle:[_typeArray[i] objectForKey:@"title"] forState:0];
        [btn addTarget:self action:@selector(cateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            _lineView.centerX = btn.centerX;
            btn.selected = YES;
            _recommendButton = btn;
        } else if (i == 1) {
            _hotButton = btn;
        } else if (i == 2) {
            _newestButton = btn;
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
        CircleListVC *vc = [[CircleListVC alloc] init];
        vc.circleType = [NSString stringWithFormat:@"%@",[_typeArray[i] objectForKey:@"type"]];
        vc.view.frame = CGRectMake(MainScreenWidth*i, 0, MainScreenWidth, _mainScrollView.height);
        [_mainScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
}

// MARK: - 滚动和点击事件最终逻辑
- (void)cateExchanged:(UIButton *)sender {
    for (UIButton *object in _topView.subviews) {
        if ([object isKindOfClass:[UIButton class]]) {
            if (object.tag == sender.tag) {
                object.selected = YES;
            } else {
                object.selected = NO;
            }
        }
    }
    if (_lineView) {
        [UIView animateWithDuration:0.2 animations:^{
            
        } completion:^(BOOL finished) {
            self.lineView.centerX = sender.centerX;
        }];
    }
}


// MARK: - 分类按钮点击事件
- (void)cateButtonClick:(UIButton *)sender {
    [self.mainScrollView setContentOffset:CGPointMake(MainScreenWidth * (sender.tag - 66), 0) animated:YES];
    [self cateExchanged:sender];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / MainScreenWidth;
    self.mainScrollView.contentOffset = CGPointMake(index * MainScreenWidth, 0);
    [self cateExchanged:[_topView viewWithTag:index + 66]];
}

// MARK: - 发布按钮点击事件
- (void)rightButtonClick:(id)sender {
    if (!SWNOTEmptyStr([V5_UserModel oauthToken])) {
        [AppDelegate presentLoginNav:self];
        return;
    }
    CirclePostViewController *vc = [[CirclePostViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
