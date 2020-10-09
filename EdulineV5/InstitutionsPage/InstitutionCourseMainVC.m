//
//  InstitutionCourseMainVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "InstitutionCourseMainVC.h"
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

#import "TeacherCategoryVC.h"

@interface InstitutionCourseMainVC ()<UITextFieldDelegate,CourseTypeVCDelegate,CourseClassifyVCDelegate,CourseSortVCDelegate,CourseScreenVCDelegate,TeacherCategoryVCDelegate> {
    NSInteger page;
    
    // 课程类型
    NSString *coursetypeString;
    NSString *coursetypeIdString;
    
    // 课程小分类
    NSString *courseClassifyString;
    NSString *courseClassifyIdString;
    
    // 课程
    NSString *courseSortString;
    NSString *courseSortIdString;
    
    // 筛选
    NSString *screenId;
    NSString *screenPriceUpAndDown;
    NSString *minPrice;
    NSString *maxPrice;
}

@property (strong ,nonatomic) UIView *headerView;
@property (strong ,nonatomic)UIButton         *classOrLiveButton;
@property (strong ,nonatomic)UIButton         *classTypeButton;
@property (strong ,nonatomic)UIButton         *moreButton;
@property (strong ,nonatomic)UIButton         *screeningButton;

@end

@implementation InstitutionCourseMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
    _dataSource = [NSMutableArray new];
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    _titleLabel.text = @"全部课程";
    [self addHeaderView];
    [self makeCollectionView];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainList)];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainListMoreData)];
    _collectionView.mj_footer.hidden = YES;
    [_collectionView.mj_header beginRefreshing];
}

- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 45)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    
    NSArray *titleArray = @[@"课程类型",@"分类"];
    CGFloat ButtonH = 45;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 0, ButtonW, ButtonH)];
        button.titleLabel.font = SYSTEMFONT(14);
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setImage:Image(@"sanjiao_icon_nor") forState:UIControlStateNormal];
        [button setImage:[Image(@"sanjiao_icon_pre") converToOtherColor:EdlineV5_Color.themeColor] forState:UIControlStateSelected];
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
    cellLayout.itemSize = CGSizeMake(MainScreenWidth, 106);
    cellLayout.minimumInteritemSpacing = 0;
    cellLayout.minimumLineSpacing = 0;
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45) collectionViewLayout:cellLayout];
    [_collectionView setHeight:MainScreenHeight - MACRO_UI_UPHEIGHT - 45];
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
    [cell setCourseListInfo:_dataSource[indexPath.row] cellIndex:indexPath cellType:NO];
    return cell;
}


//- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
//    return size;
//}
//
//// 创建一个继承collectionReusableView的类,用法类比tableViewcell
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *reusableView = nil;
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        // 头部视图
//        // 代码初始化表头
//         [collectionView registerClass:[TeacherCourseListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TeacherCourseListHeaderView"];
//        // xib初始化表头
////        [collectionView registerNib:[UINib nibWithNibName:@"HeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
//        TeacherCourseListHeaderView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TeacherCourseListHeaderView" forIndexPath:indexPath];
//        reusableView = tempHeaderView;
//    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        // 底部视图
//    }
//    return reusableView;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CourseMainViewController *vc = [[CourseMainViewController alloc] init];
    vc.ID = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"id"]];
    vc.courselayer = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"section_level"]];
    vc.isLive = [[NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"course_type"]] isEqualToString:@"2"] ? YES : NO;
    vc.courseType = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"course_type"]];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 参数名
 示例值
 是否必填
 参数描述
 order
 popular
 选填
 排序【default : 综合; splendid : 推荐; popular : 畅销; latest : 最新;】
 price_order
 up
 选填
 价格排序【 up : 价格由低到高; down : 价格由高到低；】
 course_type
 1
 选填
 课程类型【1：点播；2：直播；3：面试；4：班级；】
 category
 1
 选填
 课程分类
 price_min
 55
 选填
 最小价格
 price_max
 99
 选填
 最大价格
 update_status
 1
 选填
 连载状态【1：连载中；0：已完结；】
 live
 on
 选填
 直播状态【on：直播中；soon：即将直播；】
 free
 1
 选填
 试听【1：可试听；0：不可试听；】
 page
 1
 必填
 当前页
 count
 15
 必填
 每页显示数量
 */

- (void)getCourseMainList {
    if (!SWNOTEmptyStr(_institutionID)) {
        [_collectionView.mj_header endRefreshing];
        return;
    }
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
    if (SWNOTEmptyStr(coursetypeIdString)) {
        [param setObject:coursetypeIdString forKey:@"course_type"];
    }
    // 小分类
    if (SWNOTEmptyStr(courseClassifyIdString)) {
        [param setObject:courseClassifyIdString forKey:@"category"];
    }
    // 排序
    if (SWNOTEmptyStr(courseSortIdString)) {
        [param setObject:courseSortIdString forKey:@"order"];
    }
    // 筛选
    if (SWNOTEmptyStr(screenId)) {
        [param setObject:screenId forKey:@""];
    }
    if (SWNOTEmptyStr(screenPriceUpAndDown)) {
        [param setObject:screenPriceUpAndDown forKey:@"price_order"];
    }
    if (SWNOTEmptyStr(minPrice)) {
        [param setObject:minPrice forKey:@"price_min"];
    }
    if (SWNOTEmptyStr(maxPrice)) {
        [param setObject:maxPrice forKey:@"price_max"];
    }
    [_collectionView collectionViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_collectionView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path institutionCourseListNet:_institutionID] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        [_collectionView.mj_header endRefreshing];
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (_dataSource.count<10) {
                    _collectionView.mj_footer.hidden = YES;
                } else {
                    [_collectionView.mj_footer setState:MJRefreshStateIdle];
                    _collectionView.mj_footer.hidden = NO;
                }
                [_collectionView collectionViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_collectionView.height];
                [_collectionView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [_collectionView.mj_header endRefreshing];
    }];
}

- (void)getCourseMainListMoreData {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    // 大类型
    if (SWNOTEmptyStr(coursetypeIdString)) {
        [param setObject:coursetypeIdString forKey:@"course_type"];
    }
    // 小分类
    if (SWNOTEmptyStr(courseClassifyIdString)) {
        [param setObject:courseClassifyIdString forKey:@"category"];
    }
    // 排序
    if (SWNOTEmptyStr(courseSortIdString)) {
        [param setObject:courseSortIdString forKey:@"order"];
    }
    // 筛选
    if (SWNOTEmptyStr(screenId)) {
        [param setObject:screenId forKey:@""];
    }
    if (SWNOTEmptyStr(screenPriceUpAndDown)) {
        [param setObject:screenPriceUpAndDown forKey:@"price_order"];
    }
    if (SWNOTEmptyStr(minPrice)) {
        [param setObject:minPrice forKey:@"price_min"];
    }
    if (SWNOTEmptyStr(maxPrice)) {
        [param setObject:maxPrice forKey:@"price_max"];
    }
    
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path institutionCourseListNet:_institutionID] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_collectionView.mj_footer.isRefreshing) {
            [_collectionView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"data"]];
                if (pass.count<10) {
                    [_collectionView.mj_footer endRefreshingWithNoMoreData];
                }
                [_dataSource addObjectsFromArray:pass];
                [_collectionView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_collectionView.mj_footer.isRefreshing) {
            [_collectionView.mj_footer endRefreshing];
        }
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
            vc.notHiddenNav = NO;
            vc.isMainPage = NO;
            vc.hiddenNavDisappear = YES;
            vc.delegate = self;
            if (SWNOTEmptyStr(coursetypeIdString)) {
                vc.typeId = coursetypeIdString;
            }
            vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45);
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }
    } else if (button == _classTypeButton) {
        _classTypeButton.selected = !_classTypeButton.selected;
        _classOrLiveButton.selected = NO;
        _moreButton.selected = NO;
        _screeningButton.selected = NO;
        if (_classTypeButton.selected) {
            TeacherCategoryVC *vc = [[TeacherCategoryVC alloc] init];
            vc.notHiddenNav = NO;
            vc.hiddenNavDisappear = YES;
            vc.typeString = @"0";
            vc.delegate = self;
            vc.mhm_id = _institutionID;
            vc.isChange = YES;
            vc.isDownExpend = YES;
            vc.tableviewHeight = MainScreenHeight - MACRO_UI_UPHEIGHT - 45;
//            [self.navigationController pushViewController:vc animated:YES];
//            CourseClassifyVC *vc = [[CourseClassifyVC alloc] init];
//            vc.notHiddenNav = NO;
//            vc.hiddenNavDisappear = YES;
//            vc.delegate = self;
//            vc.isMainPage = NO;
//            if (SWNOTEmptyStr(courseClassifyIdString)) {
//                vc.typeId = courseClassifyIdString;
//            }
            vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45);
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }
    } else if (button == _moreButton) {
        
    } else if (button == _screeningButton) {
        
    }
}

- (void)chooseCourseType:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        coursetypeString = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
        coursetypeIdString = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
        _classOrLiveButton.selected = NO;
        [_classOrLiveButton setTitle:coursetypeString forState:0];
        [EdulineV5_Tool dealButtonImageAndTitleUI:_classOrLiveButton];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
        [self getCourseMainList];
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
        [self getCourseMainList];
    }
}

- (void)sortTypeChoose:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        courseSortString = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
        courseSortIdString = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
        _moreButton.selected = NO;
        [_moreButton setTitle:courseSortString forState:0];
        [EdulineV5_Tool dealButtonImageAndTitleUI:_moreButton];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
        [self getCourseMainList];
    }
}

- (void)cleanChooseScreen:(NSDictionary *)info {
    _screeningButton.selected = NO;
    screenId = @"";
    screenPriceUpAndDown = @"";
    maxPrice = @"";
    minPrice = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    [self getCourseMainList];
}

- (void)sureChooseScreen:(NSDictionary *)info {
    _screeningButton.selected = NO;
    if (SWNOTEmptyDictionary(info)) {
        screenId = [NSString stringWithFormat:@"%@",[info objectForKey:@"screenId"]];
        screenPriceUpAndDown = [NSString stringWithFormat:@"%@",[info objectForKey:@"screenUpAndDown"]];
        maxPrice = [[NSString stringWithFormat:@"%@",[info objectForKey:@"priceMax"]] stringByReplacingOccurrencesOfString:@"育币" withString:@""];
        minPrice = [[NSString stringWithFormat:@"%@",[info objectForKey:@"priceMin"]] stringByReplacingOccurrencesOfString:@"育币" withString:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
        [self getCourseMainList];
    }
}

- (void)chooseCategoryModel:(TeacherCategoryModel *)model {
    courseClassifyString = [NSString stringWithFormat:@"%@",model.title];
    courseClassifyIdString = [NSString stringWithFormat:@"%@",model.cateGoryId];
    _classTypeButton.selected = NO;
    [_classTypeButton setTitle:courseClassifyString forState:0];
    [EdulineV5_Tool dealButtonImageAndTitleUI:_classTypeButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    [self getCourseMainList];
}

@end
