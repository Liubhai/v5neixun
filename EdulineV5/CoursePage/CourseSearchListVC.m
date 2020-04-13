//
//  CourseSearchListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseSearchListVC.h"
#import "V5_Constant.h"
#import "CourseSearchListCell.h"
#import "Net_Path.h"
#import "EdulineV5_Tool.h"
#import "CourseMainViewController.h"

//分类
#import "CourseTypeVC.h"
#import "CourseSortVC.h"
#import "CourseScreenVC.h"
#import "CourseClassifyVC.h"

@interface CourseSearchListVC ()<UITextFieldDelegate,CourseTypeVCDelegate,CourseClassifyVCDelegate> {
    NSInteger page;
    
    NSString *coursetypeString;
    NSString *coursetypeIdString;
    
    NSString *courseClassifyString;
    NSString *courseClassifyIdString;
}

@property (strong ,nonatomic) UIView *headerView;
@property (strong ,nonatomic)UIButton         *classOrLiveButton;
@property (strong ,nonatomic)UIButton         *classTypeButton;
@property (strong ,nonatomic)UIButton         *moreButton;
@property (strong ,nonatomic)UIButton         *screeningButton;

@property (strong, nonatomic) UITextField *institutionSearch;

@end

@implementation CourseSearchListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
    _dataSource = [NSMutableArray new];
    _titleLabel.text = @"课程";
    _titleLabel.hidden = YES;
    _leftButton.hidden = YES;
    _cellType = NO;
    _rightButton.hidden = YES;
    if (SWNOTEmptyStr(_themeTitle)) {
        _titleLabel.text = _themeTitle;
        _leftButton.hidden = NO;
    }
    if (_isSearch) {
        _leftButton.hidden = NO;
    }
    [self makeTopSearch];
    [self addHeaderView];
    [self makeCollectionView];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainList)];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainListMoreData)];
    _collectionView.mj_footer.hidden = YES;
    [_collectionView.mj_header beginRefreshing];
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(_isSearch ? (_leftButton.right + 15) : 15, _titleLabel.top, MainScreenWidth - 30 - (_isSearch ? _leftButton.right : 0) , 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索课程" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 15, 15)];
    [button setImage:Image(@"home_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
}

- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 45)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    
    NSArray *titleArray = @[@"点播课程",@"分类",@"综合条件",@"筛选"];
    if (_cateStr != nil) {
        titleArray = @[@"点播课程",_cateStr,@"综合条件",@"筛选"];
    }
    CGFloat ButtonH = 45;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 0, ButtonW, ButtonH)];
        button.titleLabel.font = SYSTEMFONT(14);
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setImage:Image(@"sanjiao_icon_nor") forState:UIControlStateNormal];
        [button setImage:Image(@"sanjiao_icon_pre") forState:UIControlStateSelected];
        [button setTitleColor:EdlineV5_Color.textFirstColor forState:UIControlStateNormal];
        [button setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        [EdulineV5_Tool dealButtonImageAndTitleUI:button];
        [button addTarget:self action:@selector(headerButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:button];
        if (i == 0) {
            _classOrLiveButton = button;
        } else if (i == 1) {
            _classTypeButton = button;
        } else if (i == 2) {
            _moreButton = button;
        } else if (i == 3) {
//            if (SWNOTEmptyStr(_screeningStr)) {
//                if ([_screeningStr isEqualToString:@"best"]) {
//                    [button setTitle:@"精选" forState:UIControlStateNormal];
//                }
//            }
            _screeningButton = button;
        }
    }
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_headerView addSubview:lineButton];
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    if (_cellType) {
        cellLayout.itemSize = CGSizeMake((MainScreenWidth - 12) / 2.0, (MainScreenWidth/2.0 - 6 - 15) * 90 / 165.0 + 6 + 20 + 13 + 16 + 10);
        cellLayout.minimumInteritemSpacing = 6;
    } else {
        cellLayout.itemSize = CGSizeMake(MainScreenWidth, 106);
        cellLayout.minimumInteritemSpacing = 0;
        cellLayout.minimumLineSpacing = 0;
    }
    
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45) collectionViewLayout:cellLayout];
    if (_isSearch) {
        [_collectionView setHeight:MainScreenHeight - MACRO_UI_UPHEIGHT - 45];
    } else {
        [_collectionView setHeight:MainScreenHeight - MACRO_UI_UPHEIGHT - 45 - MACRO_UI_TABBAR_HEIGHT];
    }
    [_collectionView registerClass:[CourseSearchListCell class] forCellWithReuseIdentifier:@"CourseSearchListCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseSearchListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CourseSearchListCell" forIndexPath:indexPath];
    [cell setCourseListInfo:_dataSource[indexPath.row] cellIndex:indexPath cellType:_cellType];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CourseMainViewController *vc = [[CourseMainViewController alloc] init];
    vc.ID = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"id"]];
    vc.courselayer = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"section_level"]];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 order    popular    选填    排序【default : 综合; splendid : 推荐; popular : 畅销; latest : 最新; priceUp : 价格由低到高; priceDown : 价格由高到低;】
 course_type    1    选填    课程类型【1：点播；2：直播；3：面试；4：班级；】
 category    1    选填    课程分类
 price_min    55    选填    最小价格
 price_max    99    选填    最大价格
 update_status    1    选填    连载状态【1：连载中；0：已完结；】
 free    1    选填    试听【1：可试听；0：不可试听；】
 */

- (void)getCourseMainList {
    page = 1;
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseMainList] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        [_collectionView.mj_header endRefreshing];
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
                [_collectionView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [_collectionView.mj_header endRefreshing];
    }];
}

- (void)getCourseMainListMoreData {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseMainList] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
                [_collectionView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)headerButtonCilck:(UIButton *)button {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    if (button == _classOrLiveButton) {
        _classOrLiveButton.selected = !_classOrLiveButton.selected;
        _classTypeButton.selected = NO;
        _moreButton.selected = NO;
        _screeningButton.selected = NO;
        if (_classOrLiveButton.selected) {
            CourseTypeVC *vc = [[CourseTypeVC alloc] init];
            vc.notHiddenNav = YES;
            vc.isMainPage = !_isSearch;
            vc.delegate = self;
            if (SWNOTEmptyStr(coursetypeIdString)) {
                vc.typeId = coursetypeIdString;
            }
            vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45 - (_isSearch ? 0 : MACRO_UI_TABBAR_HEIGHT));
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }
    } else if (button == _classTypeButton) {
        _classTypeButton.selected = !_classTypeButton.selected;
        _classOrLiveButton.selected = NO;
        _moreButton.selected = NO;
        _screeningButton.selected = NO;
        if (_classTypeButton.selected) {
            CourseClassifyVC *vc = [[CourseClassifyVC alloc] init];
            vc.notHiddenNav = YES;
            vc.delegate = self;
            vc.isMainPage = !_isSearch;
            if (SWNOTEmptyStr(courseClassifyIdString)) {
                vc.typeId = courseClassifyIdString;
            }
            vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45 - (_isSearch ? 0 : MACRO_UI_TABBAR_HEIGHT));
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }
    } else if (button == _moreButton) {
        _moreButton.selected = !_moreButton.selected;
        _classOrLiveButton.selected = NO;
        _classTypeButton.selected = NO;
        _screeningButton.selected = NO;
        if (_moreButton.selected) {
            CourseSortVC *vc = [[CourseSortVC alloc] init];
            vc.notHiddenNav = YES;
            vc.isMainPage = !_isSearch;
            vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45 - (_isSearch ? 0 : MACRO_UI_TABBAR_HEIGHT));
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }
    } else if (button == _screeningButton) {
        _screeningButton.selected = !_screeningButton.selected;
        _classOrLiveButton.selected = NO;
        _classTypeButton.selected = NO;
        _moreButton.selected = NO;
        if (_screeningButton.selected) {
            CourseScreenVC *vc = [[CourseScreenVC alloc] init];
            vc.notHiddenNav = YES;
            vc.isMainPage = !_isSearch;
            vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45 - (_isSearch ? 0 : MACRO_UI_TABBAR_HEIGHT));
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }
    }
}

- (void)rightButtonClick:(id)sender {
    CourseSearchListVC *vc = [[CourseSearchListVC alloc] init];
    vc.isSearch = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_institutionSearch resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)chooseCourseType:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        coursetypeString = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
        coursetypeIdString = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
        _classOrLiveButton.selected = NO;
        [_classOrLiveButton setTitle:coursetypeString forState:0];
        [EdulineV5_Tool dealButtonImageAndTitleUI:_classOrLiveButton];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    }
}

- (void)chooseCourseClassify:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        courseClassifyString = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
        courseClassifyIdString = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
        _classTypeButton.selected = NO;
        [_classTypeButton setTitle:courseClassifyString forState:0];
        [EdulineV5_Tool dealButtonImageAndTitleUI:_classTypeButton];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    }
}


@end
