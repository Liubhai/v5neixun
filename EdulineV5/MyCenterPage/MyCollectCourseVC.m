//
//  MyCollectCourseVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/13.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyCollectCourseVC.h"
#import "V5_Constant.h"
#import "CollectionListVC.h"
#import "LBHScrollView.h"
#import "MyCollectionCourseManagerVC.h"

@interface MyCollectCourseVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIButton *allButton;
@property (strong, nonatomic) UIButton *needDealButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *finishButton;
@property (strong, nonatomic) UIButton *otherButton;
@property (strong, nonatomic) NSMutableArray *typeArray;

@property (strong, nonatomic) UIScrollView *mainScrollView;

@end

@implementation MyCollectCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"我的收藏";
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"管理" forState:0];
    [_rightButton setTitle:@"取消" forState:UIControlStateSelected];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:UIControlStateSelected];
    _rightButton.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    
    _typeArray = [NSMutableArray new];
    [_typeArray addObjectsFromArray:@[@{@"title":@"公开课程",@"type":@"video"},@{@"title":@"培训计划",@"type":@"classes"}]];
    
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
        btn.tag = 66 + i;
        [btn setTitle:[_typeArray[i] objectForKey:@"title"] forState:0];
        [btn addTarget:self action:@selector(cateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            _lineView.centerX = btn.centerX;
            btn.selected = YES;
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
        CollectionListVC *vc = [[CollectionListVC alloc] init];
        vc.courseType = [NSString stringWithFormat:@"%@",[_typeArray[i] objectForKey:@"type"]];
        vc.view.frame = CGRectMake(MainScreenWidth*i, 0, MainScreenWidth, _mainScrollView.height);
        [_mainScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"canScrollTable" object:nil userInfo:@{@"can":@"0"}];
//    if (scrollView == _mainScrollView) {
//        if (scrollView.contentOffset.x <= 0) {
//            self.lineView.centerX = self.allButton.centerX;
//            self.allButton.selected = YES;
//            self.needDealButton.selected = NO;
//            self.cancelButton.selected = NO;
//            self.finishButton.selected = NO;
//            self.otherButton.selected = NO;
//        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
//            self.lineView.centerX = self.cancelButton.centerX;
//            self.allButton.selected = NO;
//            self.needDealButton.selected = NO;
//            self.cancelButton.selected = YES;
//            self.finishButton.selected = NO;
//            self.otherButton.selected = NO;
//        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
//            self.lineView.centerX = self.needDealButton.centerX;
//            self.allButton.selected = NO;
//            self.needDealButton.selected = YES;
//            self.cancelButton.selected = NO;
//            self.finishButton.selected = NO;
//            self.otherButton.selected = NO;
//        }else if (scrollView.contentOffset.x >= 3*MainScreenWidth && scrollView.contentOffset.x <= 3*MainScreenWidth){
//            self.lineView.centerX = self.finishButton.centerX;
//            self.allButton.selected = NO;
//            self.needDealButton.selected = NO;
//            self.cancelButton.selected = NO;
//            self.finishButton.selected = YES;
//            self.otherButton.selected = NO;
//        }else if (scrollView.contentOffset.x >= 4*MainScreenWidth){
//            self.lineView.centerX = self.otherButton.centerX;
//            self.allButton.selected = NO;
//            self.needDealButton.selected = NO;
//            self.cancelButton.selected = NO;
//            self.finishButton.selected = NO;
//            self.otherButton.selected = YES;
//        }
//    }
//}

- (void)topButtonClick:(UIButton *)sender {
    [self.mainScrollView setContentOffset:CGPointMake(MainScreenWidth * sender.tag, 0) animated:YES];
}

- (void)rightButtonClick:(id)sender {
    _rightButton.selected = !_rightButton.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showManagerBottomView" object:nil userInfo:@{@"show":(_rightButton.selected ? @"1" : @"0")}];
//    MyCollectionCourseManagerVC *vc = [[MyCollectionCourseManagerVC alloc] init];
//    NSInteger i = 0;
//    for (UIButton *btn in _topView.subviews) {
//        if ([btn isKindOfClass:[UIButton class]]) {
//            if (btn.selected) {
//                i = btn.tag;
//            }
//        }
//    }
//    vc.courseType = [NSString stringWithFormat:@"%@",[_typeArray[i] objectForKey:@"type"]];
//    [self.navigationController pushViewController:vc animated:YES];
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
            _lineView.centerX = sender.centerX;
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


@end
