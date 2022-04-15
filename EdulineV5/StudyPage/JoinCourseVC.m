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
#import "CourseSortVC.h"

@interface JoinCourseVC ()<UIScrollViewDelegate,CourseSortVCDelegate> {
    NSString *courseSortIdString;
    NSString *courseSortString;
}

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIButton *needDealButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *finishButton;
@property (strong, nonatomic) UIButton *otherButton;
@property (strong, nonatomic) UIButton *outdateButton;
@property (strong, nonatomic) NSMutableArray *typeArray;

@property (strong, nonatomic) UIScrollView *mainScrollView;
@end

@implementation JoinCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    courseSortIdString = @"";
    courseSortString = @"";
    _titleLabel.text = [_courseType isEqualToString:@"4"] ? @"我的计划" : @"我的课程";
//    [_rightButton setImage:Image(@"lesson_screen_nor") forState:0];
//    _rightButton.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    _typeArray = [NSMutableArray new];
    if ([_courseType isEqualToString:@"4"]) {
        [_typeArray addObjectsFromArray:@[@{@"title":@"全部",@"type":@"1"},@{@"title":@"学习中",@"type":@"2"},@{@"title":@"未开始",@"type":@"3"},@{@"title":@"已完成",@"type":@"4"},@{@"title":@"已到期",@"type":@"5"}]];
    }
    
    [self makeTopView];
    [self makeScrollView];
}

- (void)makeTopView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 0)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    if (SWNOTEmptyArr(_typeArray)) {
        _topView.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 45);
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
            if (i == 0) {
                btn.selected = YES;
                _lineView.centerX = btn.centerX;
                _needDealButton = btn;
            } else if (i == 1) {
                _cancelButton = btn;
            } else if (i == 2) {
                _finishButton = btn;
            } else if (i == 3) {
                _otherButton = btn;
            } else if (i == 4) {
                _outdateButton = btn;
            }
            [_topView addSubview:btn];
        }
        [_topView bringSubviewToFront:_lineView];
    }
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
    
    if (SWNOTEmptyArr(_typeArray)) {
        for (int i = 0; i<_typeArray.count; i++) {
            JoinCourseTypeVC *vc = [[JoinCourseTypeVC alloc] init];
            vc.courseType = @"4";
            vc.typeString = [NSString stringWithFormat:@"%@",[_typeArray[i] objectForKey:@"type"]];
            vc.view.frame = CGRectMake(MainScreenWidth*i, 0, MainScreenWidth, _mainScrollView.height);
            [_mainScrollView addSubview:vc.view];
            [self addChildViewController:vc];
        }
    } else {
        JoinCourseTypeVC *vc = [[JoinCourseTypeVC alloc] init];
        vc.courseType = @"1";
        vc.view.frame = CGRectMake(0, 0, MainScreenWidth, _mainScrollView.height);
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
            self.outdateButton.selected = NO;
        } else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.lineView.centerX = self.finishButton.centerX;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = NO;
            self.finishButton.selected = YES;
            self.otherButton.selected = NO;
            self.outdateButton.selected = NO;
        } else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            self.lineView.centerX = self.cancelButton.centerX;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = YES;
            self.finishButton.selected = NO;
            self.otherButton.selected = NO;
            self.outdateButton.selected = NO;
        } else if (scrollView.contentOffset.x >= 3*MainScreenWidth && scrollView.contentOffset.x <= 3*MainScreenWidth){
            self.lineView.centerX = self.otherButton.centerX;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = NO;
            self.finishButton.selected = NO;
            self.otherButton.selected = YES;
            self.outdateButton.selected = NO;
        } else if (scrollView.contentOffset.x >= 4*MainScreenWidth && scrollView.contentOffset.x <= 4*MainScreenWidth){
            self.lineView.centerX = self.outdateButton.centerX;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = NO;
            self.finishButton.selected = NO;
            self.otherButton.selected = NO;
            self.outdateButton.selected = YES;
        }
    }
}

- (void)topButtonClick:(UIButton *)sender {
    [self.mainScrollView setContentOffset:CGPointMake(MainScreenWidth * sender.tag, 0) animated:YES];
}

- (void)rightButtonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    _rightButton.selected = !_rightButton.selected;
    if (_rightButton.selected) {
        CourseSortVC *vc = [[CourseSortVC alloc] init];
        vc.notHiddenNav = NO;
        vc.hiddenNavDisappear = YES;
        vc.isMainPage = NO;
        vc.pageClass = @"joinCourse";
        vc.delegate = self;
        if (SWNOTEmptyStr(courseSortIdString)) {
            vc.typeId = courseSortIdString;
        }
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    }
}

// MARK: - 筛选点击a代理
- (void)sortTypeChoose:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        courseSortString = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
        courseSortIdString = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
        _rightButton.selected = !_rightButton.selected;
        NSInteger currentTag = _mainScrollView.contentOffset.x/MainScreenWidth;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"courseStudyTypeProgressChange" object:nil userInfo:@{@"StudyTypeProgress":courseSortIdString,@"currentType":[_typeArray[currentTag] objectForKey:@"type"]}];
    }
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
