//
//  CourseMainViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/16.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseMainViewController.h"
#import "V5_Constant.h"
#import "StarEvaluator.h"
#import "EdulineV5_Tool.h"
#import "CourseDownView.h"

#define FaceImageHeight 207

@interface CourseMainViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource> {
    // 新增内容
    CGFloat sectionHeight;
}

/**封面*/
@property (strong, nonatomic) UIImageView *faceImageView;

/**顶部内容*/
@property (strong, nonatomic) UIView *courseContentView;
@property (strong, nonatomic) UIImageView *lianzaiIcon;
@property (strong, nonatomic) UILabel *courseTitleLabel;
@property (strong, nonatomic) UILabel *courseScore;
@property (strong, nonatomic) StarEvaluator *courseStar;
@property (strong, nonatomic) UILabel *courseLearn;
@property (strong, nonatomic) UILabel *coursePrice;
@property (strong, nonatomic) UIView *lineView1;

/**优惠卷*/
@property (strong, nonatomic) UIView *couponContentView;
@property (strong, nonatomic) UIImageView *couponIcon;
@property (strong, nonatomic) UILabel *couponLabel;
@property (strong, nonatomic) UIImageView *couponRightIcon;
@property (strong, nonatomic) UIView *lineView2;

/** 机构和讲师移动到头部视图里面了 */
@property (strong, nonatomic) UIView *teachersHeaderBackView;
@property (strong, nonatomic) UIScrollView *teachersHeaderScrollView;
@property (strong, nonatomic) NSDictionary *schoolInfo;
@property (strong, nonatomic) NSDictionary *teacherInfoDict;

@property (strong, nonatomic) NSMutableArray *tabClassArray;

///新增内容
@property (strong, nonatomic) LBHTableView *tableView;
@property (nonatomic, retain) UIScrollView *mainScroll;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, strong) UIView *buttonBackView;
@property (nonatomic, strong) UIButton *introButton;
@property (nonatomic, strong) UIButton *courseButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *questionButton;
@property (nonatomic, strong) UIView *blueLineView;

/// 底部全部设置为全局变量为了好处理交互
@property (nonatomic, strong) UIView *bg;

/**更多按钮弹出视图*/
@property (strong ,nonatomic)UIView   *allWindowView;

@property (strong, nonatomic) CourseDownView *courseDownView;

@end

@implementation CourseMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tabClassArray = [NSMutableArray arrayWithArray:@[@"简介",@"目录",@"点评"]];
    
    self.canScroll = YES;
    _titleLabel.text = @"课程详情";
    _titleImage.backgroundColor = BasidColor;
    
    [self makeHeaderView];
    [self makeSubViews];
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 - self.headerView.height;
    [self makeTableView];
    [self.view bringSubviewToFront:_titleImage];
    _titleImage.backgroundColor = [UIColor clearColor];
    _titleLabel.hidden = YES;
    _lineTL.hidden = YES;
    [self makeDownView];
    
}

- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200)];
    _headerView.backgroundColor = [UIColor whiteColor];
}

- (void)makeTableView {
    _tableView = [[LBHTableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - 50) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
}

- (void)makeSubViews {
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, FaceImageHeight)];
    _faceImageView.image = Image(@"lesson_img");
    [_headerView addSubview:_faceImageView];
    
    _courseContentView = [[UIView alloc] initWithFrame:CGRectMake(0, _faceImageView.bottom, MainScreenWidth, 86 + 4)];
    [_headerView addSubview:_courseContentView];
    _lianzaiIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 32, 16)];
    _lianzaiIcon.image = Image(@"icon_lianzai");
    [_courseContentView addSubview:_lianzaiIcon];
    
    _courseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lianzaiIcon.right + 8, 12, MainScreenWidth - (_lianzaiIcon.right + 8) - 15, 32)];
    _courseTitleLabel.textColor = EdlineV5_Color.textFirstColor;
    _courseTitleLabel.font = SYSTEMFONT(16);
    _courseTitleLabel.text = @"面授课考试标题显示标题文字有点标题显";
    [_courseContentView addSubview:_courseTitleLabel];
    _lianzaiIcon.centerY = _courseTitleLabel.centerY;
    
    _courseScore = [[UILabel alloc] initWithFrame:CGRectMake(15, _courseTitleLabel.bottom, 33, 34)];
    _courseScore.text = @"4.1分";
    _courseScore.textColor = EdlineV5_Color.textzanColor;
    _courseScore.font = SYSTEMFONT(13);
    [_courseContentView addSubview:_courseScore];
    
    /** 不带边框星星 **/
    _courseStar = [[StarEvaluator alloc] initWithFrame:CGRectMake(_courseScore.right + 3, _courseScore.top, 76, 12)];
    _courseStar.centerY = _courseScore.centerY;
    [_courseContentView addSubview:_courseStar];
    _courseStar.userInteractionEnabled = NO;
    [_courseStar setStarValue:4.1];
    
    _courseLearn = [[UILabel alloc] initWithFrame:CGRectMake(_courseStar.right + 8, _courseScore.top, 58, 34)];
    _courseLearn.font = SYSTEMFONT(12);
    _courseLearn.textColor = EdlineV5_Color.textThirdColor;
    _courseLearn.text = @"12人在学";
    [_courseContentView addSubview:_courseLearn];
    
    _coursePrice = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 75, _courseScore.top, 75, 34)];
    _coursePrice.textAlignment = NSTextAlignmentRight;
    _coursePrice.text = @"¥1,199";
    _coursePrice.textColor = EdlineV5_Color.faildColor;
    _coursePrice.font = SYSTEMFONT(18);
    [_courseContentView addSubview:_coursePrice];
    _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _courseScore.bottom + 10, MainScreenWidth, 4)];
    _lineView1.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_courseContentView addSubview:_lineView1];
    [_courseContentView setHeight:_lineView1.bottom];
    
    /**优惠卷*/
    _couponContentView = [[UIView alloc] initWithFrame:CGRectMake(0, _courseContentView.bottom, MainScreenWidth, 52)];
    [_headerView addSubview:_couponContentView];
    
    _couponIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 24, 24)];
    _couponIcon.image = Image(@"icon_quan");
    [_couponContentView addSubview:_couponIcon];
    
    _couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(_couponIcon.right + 8, 0, 150, 48)];
    _couponLabel.text = @"课程相关优惠券";
    _couponLabel.font = SYSTEMFONT(14);
    [_couponContentView addSubview:_couponLabel];
    _couponIcon.centerY = _couponLabel.centerY;
    
    _couponRightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 8 - 22, 0, 22, 22)];
    _couponRightIcon.centerY = _couponLabel.centerY;
    _couponRightIcon.image = Image(@"quan_more");
    [_couponContentView addSubview:_couponRightIcon];
    _lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _couponLabel.bottom, MainScreenWidth, 4)];
    _lineView2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_couponContentView addSubview:_lineView2];
    /**机构讲师*/
    [self makeTeacherAndOrganizationUI];
    [_headerView setHeight:_teachersHeaderBackView.bottom];
}

- (void)makeDownView {
    _courseDownView = [[CourseDownView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50, MainScreenWidth, 50)];
    [self.view addSubview:_courseDownView];
}

// MARK - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifireAC =@"ActivityListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifireAC];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifireAC];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return sectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_bg == nil) {
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, sectionHeight)];
        _bg.backgroundColor = [UIColor whiteColor];
    } else {
        _bg.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight);
    }
    if (sectionHeight>1) {
        if (_recordButton == nil) {
            for (int i = 0; i < _tabClassArray.count; i++) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth*i/_tabClassArray.count * 1.0, 0, MainScreenWidth/_tabClassArray.count * 1.0, 47)];
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:_tabClassArray[i] forState:0];
                btn.titleLabel.font = SYSTEMFONT(15);
                [btn setTitleColor:[UIColor blackColor] forState:0];
                [btn setTitleColor:BasidColor forState:UIControlStateSelected];
                if (i == 0) {
                    self.introButton = btn;
                } else if (i == 1) {
                    self.courseButton = btn;
                } else if (i == 2) {
                    self.commentButton = btn;
                }
                [_bg addSubview:btn];
            }
            self.introButton.selected = YES;
            
            UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 45.5, MainScreenWidth, 1)];
            grayLine.backgroundColor = EdlineV5_Color.fengeLineColor;
            [_bg addSubview:grayLine];
            
            self.blueLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, MainScreenWidth / 5.0, 2)];
            self.blueLineView.backgroundColor = EdlineV5_Color.themeColor;
            self.blueLineView.centerX = self.introButton.centerX;
            [_bg addSubview:self.blueLineView];
            
        }
        
        if (self.mainScroll == nil) {
            self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,47, MainScreenWidth, sectionHeight - 47)];
            self.mainScroll.contentSize = CGSizeMake(MainScreenWidth*_tabClassArray.count, 0);
            self.mainScroll.pagingEnabled = YES;
            self.mainScroll.showsHorizontalScrollIndicator = NO;
            self.mainScroll.showsVerticalScrollIndicator = NO;
            self.mainScroll.bounces = NO;
            self.mainScroll.delegate = self;
            [_bg addSubview:self.mainScroll];
        } else {
            self.mainScroll.frame = CGRectMake(0,47, MainScreenWidth, sectionHeight - 47);
        }
    }
    return _bg;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)buttonClick:(UIButton *)sender{
    
    if (sender == self.introButton) {
        [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender == self.courseButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth, 0) animated:YES];
    } else if (sender == self.commentButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 2, 0) animated:YES];
    } else if (sender == self.recordButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 3, 0) animated:YES];
    } else if (sender == self.questionButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 4, 0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScroll) {
        if (scrollView.contentOffset.x <= 0) {
            self.blueLineView.centerX = self.introButton.centerX;
            self.introButton.selected = YES;
            self.courseButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.blueLineView.centerX = self.commentButton.centerX;
            self.commentButton.selected = YES;
            self.introButton.selected = NO;
            self.courseButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            self.blueLineView.centerX = self.courseButton.centerX;
            self.courseButton.selected = YES;
            self.introButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = NO;
        }else if (scrollView.contentOffset.x >= 3*MainScreenWidth && scrollView.contentOffset.x <= 3*MainScreenWidth){
            self.blueLineView.centerX = self.recordButton.centerX;
            self.courseButton.selected = NO;
            self.introButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = YES;
            self.questionButton.selected = NO;
        }else if (scrollView.contentOffset.x >= 4*MainScreenWidth){
            self.blueLineView.centerX = self.questionButton.centerX;
            self.courseButton.selected = NO;
            self.introButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = YES;
        }
    } if (scrollView == self.tableView) {
        CGFloat bottomCellOffset = self.headerView.height - MACRO_UI_UPHEIGHT;
        if (scrollView.contentOffset.y > bottomCellOffset - 0.5) {
            _titleImage.backgroundColor = EdlineV5_Color.themeColor;
            _titleLabel.hidden = NO;
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
            }
        }else{
            _titleImage.backgroundColor = [UIColor clearColor];
            _titleLabel.hidden = YES;
            if (!self.canScroll) {//子视图没到顶部
                scrollView.contentOffset = CGPointMake(0, 0);
//                if (self.canScrollAfterVideoPlay) {
//                    scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
//                } else {
//                    scrollView.contentOffset = CGPointMake(0, 0);
//                }
            }
        }
    }
}

// MARK: - 机构和讲师头像信息滚动视图
- (void)makeTeacherAndOrganizationUI {
    if (_teachersHeaderBackView == nil) {
        _teachersHeaderBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _couponContentView.bottom, MainScreenWidth, 59)];
        [_headerView addSubview:_teachersHeaderBackView];
        
        _teachersHeaderScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 55)];
        _teachersHeaderScrollView.showsVerticalScrollIndicator = NO;
        _teachersHeaderScrollView.showsHorizontalScrollIndicator = NO;
        [_teachersHeaderBackView addSubview:_teachersHeaderScrollView];
        
        UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, _teachersHeaderScrollView.bottom, MainScreenWidth, 4)];
        downLine.backgroundColor = EdlineV5_Color.fengeLineColor;
        [_teachersHeaderBackView addSubview:downLine];
        
        [_teachersHeaderBackView setHeight:0];
        _teachersHeaderBackView.hidden = YES;
    }
}

// MARK: - 机构讲师信息赋值
- (void)setTeacherAndOrganizationData {
    if (SWNOTEmptyDictionary(_schoolInfo)) {
        [_teachersHeaderBackView setTop:_couponContentView.bottom];
        [_teachersHeaderBackView setHeight:59];
        _teachersHeaderBackView.hidden = NO;
        UIImageView *schoolFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 40, 40)];
        UITapGestureRecognizer *schoolTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(instViewClick:)];
        [schoolFace addGestureRecognizer:schoolTap];
        schoolFace.userInteractionEnabled = YES;
        schoolFace.layer.masksToBounds = YES;
        schoolFace.layer.cornerRadius = 20;
        schoolFace.clipsToBounds = YES;
        schoolFace.contentMode = UIViewContentModeScaleAspectFill;
        [schoolFace sd_setImageWithURL:[NSURL URLWithString:[_schoolInfo objectForKey:@"cover"]] placeholderImage:Image(@"站位图")];
        [_teachersHeaderScrollView addSubview:schoolFace];
        UILabel *schoolName = [[UILabel alloc] initWithFrame:CGRectMake(schoolFace.right + 5, 15, 0, 14)];
        schoolName.textColor = EdlineV5_Color.textFirstColor;
        schoolName.font = SYSTEMFONT(13);
        schoolName.text = [NSString stringWithFormat:@"%@",[_schoolInfo objectForKey:@"title"]];
        [_teachersHeaderScrollView addSubview:schoolName];
        UILabel *schoolOwn = [[UILabel alloc] initWithFrame:CGRectMake(schoolFace.right + 5, schoolName.bottom, 0, 18)];
        schoolOwn.text = @"所属机构";
        schoolOwn.textColor = EdlineV5_Color.textThirdColor;
        schoolOwn.font = SYSTEMFONT(10);
        [_teachersHeaderScrollView addSubview:schoolOwn];
        CGFloat schoolnameWidth = [schoolName.text sizeWithFont:schoolName.font].width + 4;
        CGFloat schoolOwnWidth = [schoolOwn.text sizeWithFont:schoolOwn.font].width + 4;
        [schoolName setWidth:schoolnameWidth];
        [schoolOwn setWidth:schoolOwnWidth];
        if (SWNOTEmptyDictionary(_teacherInfoDict)) {
            UIImageView *teacherFace = [[UIImageView alloc] initWithFrame:CGRectMake(schoolnameWidth > schoolOwnWidth ? (schoolName.right + 20) : (schoolOwn.right + 20), 7, 40, 40)];
            UITapGestureRecognizer *teacherTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teacherViewClick:)];
            [teacherFace addGestureRecognizer:teacherTap];
            teacherFace.userInteractionEnabled = YES;
            teacherFace.layer.masksToBounds = YES;
            teacherFace.layer.cornerRadius = 20;
            teacherFace.clipsToBounds = YES;
            teacherFace.contentMode = UIViewContentModeScaleAspectFill;
            [teacherFace sd_setImageWithURL:[NSURL URLWithString:[_teacherInfoDict objectForKey:@"headimg"]] placeholderImage:Image(@"站位图")];
            [_teachersHeaderScrollView addSubview:teacherFace];
            UILabel *teacherName = [[UILabel alloc] initWithFrame:CGRectMake(teacherFace.right + 5, 15, 0, 14)];
            teacherName.textColor = EdlineV5_Color.textFirstColor;
            teacherName.font = SYSTEMFONT(13);
            teacherName.text = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"name"]];
            [_teachersHeaderScrollView addSubview:teacherName];
            UILabel *taecherOwn = [[UILabel alloc] initWithFrame:CGRectMake(teacherFace.right + 5, teacherName.bottom, 0, 18)];
            taecherOwn.text = @"主讲老师";
            taecherOwn.textColor = EdlineV5_Color.textThirdColor;
            taecherOwn.font = SYSTEMFONT(10);
            [_teachersHeaderScrollView addSubview:taecherOwn];
            CGFloat teacherNameWidth = [teacherName.text sizeWithFont:teacherName.font].width + 4;
            CGFloat taecherOwnWidth = [taecherOwn.text sizeWithFont:taecherOwn.font].width + 4;
            [teacherName setWidth:teacherNameWidth];
            [taecherOwn setWidth:taecherOwnWidth];
        }
    }
    [_headerView setHeight:_teachersHeaderBackView.bottom];
    _tableView.tableHeaderView = _headerView;
    [_tableView reloadData];
}

// MARK: - 讲师点击事件
- (void)teacherViewClick:(UIGestureRecognizer *)ges {
    
}

// MARK: - 机构点击事件
- (void)instViewClick:(UIGestureRecognizer *)ges {
    if (SWNOTEmptyDictionary(_schoolInfo)) {
        
    }
}

- (void)rightButtonClick:(id)sender {
    
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds =YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    _allWindowView = allWindowView;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WidthRatio,55 * HeightRatio,100 * WidthRatio,100 * HeightRatio)];
    moreView.frame = CGRectMake(MainScreenWidth - 120 * WidthRatio,55 * HeightRatio,100 * WidthRatio,100 * HeightRatio);
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    
    NSArray *imageArray = @[@"ico_collect@3x",@"class_share",@"class_down"];
    NSArray *titleArray = @[@"+收藏",@"分享",@"下载"];
//    if ([_collectStr integerValue] == 1) {
//        imageArray = @[@"ic_collect_press@3x",@"class_share",@"class_down"];
//        titleArray = @[@"-收藏",@"分享",@"下载"];
//    }
    CGFloat ButtonW = 100 * WidthRatio;
    CGFloat ButtonH = 33 * HeightRatio;
    for (int i = 0 ; i < 3 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0 * WidthRatio, ButtonH * i, ButtonW, ButtonH)];
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
        button.titleLabel.font = SYSTEMFONT(14);
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        button.imageEdgeInsets =  UIEdgeInsetsMake(0,0,0,20 * WidthRatio);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20 * WidthRatio, 0, 0);
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [moreView addSubview:button];
    }
}

// MARK: - 更多按钮点击事件
- (void)moreButtonClick:(UIButton *)sender {
    
}

// MARK: - 更多视图背景图点击事件
- (void)allWindowViewClick:(UITapGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

@end
