//
//  JoinCourseVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "JoinCourseVC.h"
#import "V5_Constant.h"
#import "JoinCourseTypeVC.h"

@interface JoinCourseVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIButton *needDealButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *finishButton;
@property (strong, nonatomic) UIButton *otherButton;
@property (strong, nonatomic) NSMutableArray *typeArray;

@property (strong, nonatomic) UIScrollView *mainScrollView;
@end

@implementation JoinCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"加入的课程";
    [_rightButton setImage:Image(@"lesson_screen_nor") forState:0];
    _rightButton.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    _typeArray = [NSMutableArray new];
    [_typeArray addObjectsFromArray:@[@{@"title":@"点播",@"type":@"course"},@{@"title":@"直播",@"type":@"live"},@{@"title":@"专辑",@"type":@"class"},@{@"title":@"面授",@"type":@"offline"}]];
    
    [self makeTopView];
    [self makeScrollView];
}

- (void)makeTopView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 45)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 - 2, 20, 2)];
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
        if (i == 0) {
            _lineView.centerX = btn.centerX;
            _needDealButton = btn;
        } else if (i == 1) {
            _cancelButton = btn;
        } else if (i == 2) {
            _finishButton = btn;
        } else if (i == 3) {
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
        JoinCourseTypeVC *vc = [[JoinCourseTypeVC alloc] init];
        vc.courseType = [NSString stringWithFormat:@"%@",[_typeArray[i] objectForKey:@"type"]];
        vc.view.frame = CGRectMake(MainScreenWidth*i, 0, MainScreenWidth, _mainScrollView.height);
        [_mainScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        if (scrollView.contentOffset.x <= 0) {
            self.lineView.centerX = self.needDealButton.centerX;
            self.needDealButton.selected = YES;
            self.cancelButton.selected = NO;
            self.finishButton.selected = NO;
            self.otherButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.lineView.centerX = self.finishButton.centerX;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = NO;
            self.finishButton.selected = YES;
            self.otherButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            self.lineView.centerX = self.cancelButton.centerX;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = YES;
            self.finishButton.selected = NO;
            self.otherButton.selected = NO;
        }else if (scrollView.contentOffset.x >= 3*MainScreenWidth && scrollView.contentOffset.x <= 3*MainScreenWidth){
            self.lineView.centerX = self.otherButton.centerX;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
