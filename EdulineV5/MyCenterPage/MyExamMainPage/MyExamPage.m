//
//  MyExamPage.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/3.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "MyExamPage.h"
#import "V5_Constant.h"
#import "CourseSortVC.h"

#import "ExamRecordList.h"

#import "ExamRecordManagerVC.h"

@interface MyExamPage ()<CourseSortVCDelegate> {
    // 课程
    NSString *courseSortString;
    NSString *courseSortIdString;
}

@property (strong, nonatomic) UIButton *topCateButton;// 顶部分类按钮
@property (strong, nonatomic) ExamRecordList *collectionVC;
@property (strong, nonatomic) ExamRecordList *errorExamListVC;
@property (strong, nonatomic) ExamRecordManagerVC *publicAndTestExamListVC;

@end

@implementation MyExamPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.hidden = YES;
    
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"管理" forState:0];
    [_rightButton setTitle:@"取消" forState:UIControlStateSelected];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:UIControlStateSelected];
    _rightButton.hidden = YES;
    
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.layarLineColor;
    
    _topCateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80 + 4 + 13, _titleLabel.height)];
    _topCateButton.titleLabel.font = SYSTEMFONT(18);
    [_topCateButton setTitle:@"考试记录" forState:UIControlStateNormal];
    [_topCateButton setImage:Image(@"myexam_down_icon") forState:0];
    [_topCateButton setImage:Image(@"myexam_up_icon") forState:UIControlStateSelected];
    [_topCateButton setTitleColor:EdlineV5_Color.textFirstColor forState:UIControlStateNormal];
    [EdulineV5_Tool dealButtonImageAndTitleUIWidthSpace:_topCateButton space:6];
    [_topCateButton addTarget:self action:@selector(headerButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    _topCateButton.center = _titleLabel.center;
    [_titleImage addSubview:_topCateButton];
    
    [self addPublicAndTestExamListVC];
    courseSortString = @"考试记录";
    courseSortIdString = @"examRecord";
    // Do any additional setup after loading the view.
}

- (void)rightButtonClick:(id)sender {
    _rightButton.selected = !_rightButton.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showManagerBottomView" object:nil userInfo:@{@"show":(_rightButton.selected ? @"1" : @"0")}];
}

- (void)headerButtonCilck:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    _topCateButton.selected = !_topCateButton.selected;
    if (_topCateButton.selected) {
        CourseSortVC *vc = [[CourseSortVC alloc] init];
        vc.notHiddenNav = NO;
        vc.isMainPage = NO;
        vc.hiddenNavDisappear = YES;
        vc.pageClass = @"myExamType";
        vc.delegate = self;
        if (SWNOTEmptyStr(courseSortIdString)) {
            vc.typeId = courseSortIdString;
        }
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    }
}

// MARK: - 顶部下拉选择代理(@[@{@"title":@"考试记录",@"id":@"examRecord"},@{@"title":@"错题本",@"id":@"errorExam"},@{@"title":@"题目收藏",@"id":@"examCollect"}])
- (void)sortTypeChoose:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        courseSortString = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
        courseSortIdString = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
        if ([courseSortIdString isEqualToString:@"examCollect"]) {
            _rightButton.hidden = NO;
            [self addCollectionListVC];
        } else if ([courseSortIdString isEqualToString:@"examRecord"]) {
            _rightButton.hidden = YES;
            [self addPublicAndTestExamListVC];
        } else {
            [self addErrorExamListVC];
            _rightButton.hidden = YES;
        }
        
        _topCateButton.selected = NO;
        [_topCateButton setTitle:courseSortString forState:0];
        [EdulineV5_Tool dealButtonImageAndTitleUIWidthSpace:_topCateButton space:6];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
//        [self getCourseMainList];
    }
}

- (void)addCollectionListVC {
    if (!_collectionVC) {
        _collectionVC = [[ExamRecordList alloc] init];
        _collectionVC.examListType = @"collect";
        _collectionVC.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
        [self.view addSubview:_collectionVC.view];
        [self addChildViewController:_collectionVC];
    }
    _collectionVC.view.hidden = NO;
    
    if (_errorExamListVC) {
        _errorExamListVC.view.hidden = YES;
    }
    
    if (_publicAndTestExamListVC) {
        _publicAndTestExamListVC.view.hidden = YES;
    }
}

- (void)addErrorExamListVC {
    if (!_errorExamListVC) {
        _errorExamListVC = [[ExamRecordList alloc] init];
        _errorExamListVC.examListType = @"error";
        _errorExamListVC.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
        [self.view addSubview:_errorExamListVC.view];
        [self addChildViewController:_errorExamListVC];
    }
    _errorExamListVC.view.hidden = NO;
    
    if (_collectionVC) {
        _collectionVC.view.hidden = YES;
    }
    
    if (_publicAndTestExamListVC) {
        _publicAndTestExamListVC.view.hidden = YES;
    }
}

- (void)addPublicAndTestExamListVC {
    if (!_publicAndTestExamListVC) {
        _publicAndTestExamListVC = [[ExamRecordManagerVC alloc] init];
        _publicAndTestExamListVC.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
        [self.view addSubview:_publicAndTestExamListVC.view];
        [self addChildViewController:_publicAndTestExamListVC];
    }
    _publicAndTestExamListVC.view.hidden = NO;
    
    if (_collectionVC) {
        _collectionVC.view.hidden = YES;
    }
    
    if (_errorExamListVC) {
        _errorExamListVC.view.hidden = YES;
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
