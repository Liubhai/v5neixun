//
//  StudyRootVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/2.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "StudyRootVC.h"
#import "StudyTimeCell.h"
#import "StudyLatestCell.h"
#import "StudyCourseCell.h"
#import "V5_Constant.h"
#import "JoinCourseVC.h"

@interface StudyRootVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger currentCourseType;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *courseArray;
@property (strong, nonatomic) NSMutableArray *liveArray;
@property (strong, nonatomic) NSMutableArray *classArray;
@property (strong, nonatomic) NSMutableArray *offlineArray;

@property (strong, nonatomic) UIButton *courseBtn;
@property (strong, nonatomic) UIButton *liveBtn;
@property (strong, nonatomic) UIButton *classBtn;
@property (strong, nonatomic) UIButton *offlineBtn;

@property (strong, nonatomic) UIView *changeTypeBackView;
@property (strong, nonatomic) UIButton *changeTypeBtn;

@end

@implementation StudyRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    currentCourseType = 0;
    
    _courseArray = [NSMutableArray new];
    _liveArray = [NSMutableArray new];
    _classArray = [NSMutableArray new];
    _offlineArray = [NSMutableArray new];
    
    _titleImage.hidden = YES;
    
    [self makeTableView];
}

- (void)makeChangeTypeBackView {
    
    CGRect btn111 = [self.tableView rectForHeaderInSection:2];
    CGPoint btnPoint = CGPointMake(btn111.origin.x + MainScreenWidth - 15 - 123, btn111.origin.y + 16 + 30 + 5 - self.tableView.contentOffset.y);
    
    if (!_changeTypeBackView) {
        _changeTypeBackView = [[UIView alloc] init];
        _changeTypeBackView.frame = CGRectMake(btnPoint.x, btnPoint.y, 123, 77);
        
        _changeTypeBackView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _changeTypeBackView.layer.cornerRadius = 2;
        _changeTypeBackView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        _changeTypeBackView.layer.shadowOffset = CGSizeMake(0,1);
        _changeTypeBackView.layer.shadowOpacity = 1;
        _changeTypeBackView.layer.shadowRadius = 5;
        
        UIButton *joinFirstBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, _changeTypeBackView.width, 32)];
        joinFirstBtn.tag = 10;
        [joinFirstBtn setTitle:@"最近加入的优先" forState:0];
        [joinFirstBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        [joinFirstBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        joinFirstBtn.titleLabel.font = SYSTEMFONT(13);
        [joinFirstBtn addTarget:self action:@selector(changeTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_changeTypeBackView addSubview:joinFirstBtn];
        
        UIButton *studyFirstBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, joinFirstBtn.bottom, _changeTypeBackView.width, 32)];
        joinFirstBtn.tag = 11;
        [studyFirstBtn setTitle:@"最近加入的优先" forState:0];
        [studyFirstBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        [studyFirstBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        studyFirstBtn.titleLabel.font = SYSTEMFONT(13);
        [studyFirstBtn addTarget:self action:@selector(changeTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_changeTypeBackView addSubview:studyFirstBtn];
        _changeTypeBackView.hidden = YES;
        [self.view addSubview:_changeTypeBackView];
    }
    _changeTypeBackView.frame = CGRectMake(btnPoint.x, btnPoint.y, 123, 77);
    _changeTypeBackView.hidden = !_changeTypeBackView.hidden;
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_LIUHAI_HEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_LIUHAI_HEIGHT - MACRO_UI_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getStudyInfo)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
//    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *reuse = @"StudyTimeCell";
        StudyTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[StudyTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *reuse = @"StudyLatestCell";
        StudyLatestCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[StudyLatestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setLatestLearnInfo:nil];
        return cell;
    } else {
        static NSString *reuse = @"StudyCourseCell";
        StudyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[StudyCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *theme = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
        theme.text = @"最近在学";
        theme.font = SYSTEMFONT(16);
        theme.textColor = EdlineV5_Color.textFirstColor;
        [view addSubview:theme];
        
        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, 0, 30, 40)];
        [moreButton setTitle:@"更多" forState:0];
        [moreButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
        moreButton.titleLabel.font = SYSTEMFONT(14);
        [view addSubview:moreButton];
        
        return view;
    } else {
        //study_shaixuan
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10 + 28 + 13 + 22 + 20)];
        view.backgroundColor = [UIColor whiteColor];
        // 10 28 13 22 20 // 16
        
        UILabel *theme = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 22)];
        theme.text = @"加入的课程";
        theme.font = SYSTEMFONT(16);
        theme.textColor = EdlineV5_Color.textFirstColor;
        [view addSubview:theme];
        
        if (!_changeTypeBtn) {
            _changeTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 5 - 30, 0, 30, 30)];
            _changeTypeBtn.centerY = theme.centerY;
            [_changeTypeBtn setImage:Image(@"study_shaixuan") forState:0];
            [_changeTypeBtn addTarget:self action:@selector(makeChangeTypeBackView) forControlEvents:UIControlEventTouchUpInside];
        }
        [view addSubview:_changeTypeBtn];
        
        NSArray *courseTypeArray = @[@"点播",@"直播",@"专辑",@"面授"];
        for (int i = 0; i < courseTypeArray.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + 77 * i, theme.bottom + 13, 65, 28)];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 14;
            [btn setTitle:courseTypeArray[i] forState:0];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
            btn.titleLabel.font = SYSTEMFONT(14);
            [btn setBackgroundColor:EdlineV5_Color.fengeLineColor];
            [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            if (i == currentCourseType) {
                btn.selected = YES;
                btn.backgroundColor = EdlineV5_Color.themeColor;
            } else {
                btn.selected = NO;
                [btn setBackgroundColor:EdlineV5_Color.fengeLineColor];
            }
            if (i == 0) {
                _courseBtn = btn;
            } else if (i == 1) {
                _liveBtn = btn;
            } else if (i == 2) {
                _classBtn = btn;
            } else if (i == 3) {
                _offlineBtn = btn;
            }
        }
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
        view.backgroundColor = EdlineV5_Color.fengeLineColor;
        return view;
    } else {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 18 * 3)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 17, 80, 20)];
        [moreBtn setImage:Image(@"study_more") forState:0];
        [moreBtn setTitle:@"查看更多" forState:0];
        moreBtn.titleLabel.font = SYSTEMFONT(13);
        [moreBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
        [EdulineV5_Tool dealButtonImageAndTitleUI:moreBtn];
        moreBtn.centerX = MainScreenWidth / 2.0;
        [moreBtn addTarget:self action:@selector(moreJoinCourseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:moreBtn];
        
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    } else if (section == 1) {
        return 40;
    } else {
        return 10 + 28 + 13 + 22 + 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    } else if (section == 1) {
        return 10;
    } else {
        return 18 * 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    } else if (indexPath.section == 1) {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    } else {
        return 106;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect btn111 = [self.tableView rectForHeaderInSection:2];
    CGPoint btnPoint = CGPointMake(btn111.origin.x + MainScreenWidth - 15 - 123, btn111.origin.y + 16 + 30 + 5 - scrollView.contentOffset.y);
    _changeTypeBackView.frame = CGRectMake(btnPoint.x, btnPoint.y, 123, 77);
}

- (void)typeBtnClick:(UIButton *)sender {
    if (sender == _courseBtn) {
        _courseBtn.selected = YES;
        [_courseBtn setBackgroundColor:EdlineV5_Color.themeColor];
        _liveBtn.selected = NO;
        [_liveBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _classBtn.selected = NO;
        [_classBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _offlineBtn.selected = NO;
        [_offlineBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        currentCourseType = 0;
    } else if (sender == _liveBtn) {
        _courseBtn.selected = NO;
        [_courseBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _liveBtn.selected = YES;
        [_liveBtn setBackgroundColor:EdlineV5_Color.themeColor];
        _classBtn.selected = NO;
        [_classBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _offlineBtn.selected = NO;
        [_offlineBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        currentCourseType = 1;
    } else if (sender == _classBtn) {
        _courseBtn.selected = NO;
        [_courseBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _liveBtn.selected = NO;
        [_liveBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _classBtn.selected = YES;
        [_classBtn setBackgroundColor:EdlineV5_Color.themeColor];
        _offlineBtn.selected = NO;
        [_offlineBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        currentCourseType = 2;
    } else if (sender == _offlineBtn) {
        _courseBtn.selected = NO;
        [_courseBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _liveBtn.selected = NO;
        [_liveBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _classBtn.selected = NO;
        [_classBtn setBackgroundColor:EdlineV5_Color.fengeLineColor];
        _offlineBtn.selected = YES;
        [_offlineBtn setBackgroundColor:EdlineV5_Color.themeColor];
        currentCourseType = 3;
    }
}

- (void)changeTypeButtonClick:(UIButton *)sender {
    _changeTypeBackView.hidden = YES;
}

- (void)moreJoinCourseButtonClick:(UIButton *)sender {
    JoinCourseVC *vc = [[JoinCourseVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getStudyInfo {
    
}

@end
