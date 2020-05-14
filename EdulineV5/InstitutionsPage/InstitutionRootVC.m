//
//  InstitutionRootVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "InstitutionRootVC.h"
#import "HomePageTeacherCell.h"
#import "HomePageCourseTypeTwoCell.h"
#import "V5_Constant.h"

@interface InstitutionRootVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *cateSourceArray;
// 讲师
@property (strong, nonatomic) NSMutableArray *teacherArray;

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIImageView *topBackImageView;
@property (strong, nonatomic) UIButton *leftBackButton;
@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *InstitutionLabel;
@property (strong, nonatomic) UILabel *introLabel;

@end

@implementation InstitutionRootVC

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel.text = @"XXX机构";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleImage.backgroundColor = EdlineV5_Color.themeColor;
    _titleImage.alpha = 0;
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.themeColor;
    _teacherArray = [NSMutableArray new];
    [_cateSourceArray addObjectsFromArray:@[@"",@"",@""]];
    
    [self makeHeaderView];
    [self makeTableView];
    _tableView.tableHeaderView = _topView;
    
    [self.view bringSubviewToFront:_titleImage];
}

- (void)makeHeaderView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MACRO_UI_UPHEIGHT + 20 + 70 + 25)];
    _topView.backgroundColor = [UIColor whiteColor];
    
    _topBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MACRO_UI_UPHEIGHT + 20 + 70 + 25)];
    _topBackImageView.backgroundColor = EdlineV5_Color.themeColor;
    _topBackImageView.image = Image(@"study_card_img");
    [_topView addSubview:_topBackImageView];
    
    _leftBackButton = [[UIButton alloc] initWithFrame:_leftButton.frame];
    [_leftBackButton setImage:Image(@"nav_back_white") forState:0];
    [_leftBackButton addTarget:self action:@selector(leftBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_leftBackButton];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, MACRO_UI_UPHEIGHT + 20, 70, 70)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 35;
    _faceImageView.image = DefaultImage;
    [_topView addSubview:_faceImageView];
    
    _InstitutionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 20, _faceImageView.top + 5, MainScreenWidth - (_faceImageView.right + 20), 23)];
    _InstitutionLabel.font = SYSTEMFONT(16);
    _InstitutionLabel.text = @"XXX机构";
    _InstitutionLabel.textColor = [UIColor whiteColor];
    [_topView addSubview:_InstitutionLabel];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 20, _InstitutionLabel.bottom + 7.5, MainScreenWidth - (_faceImageView.right + 20), 23)];
    _introLabel.font = SYSTEMFONT(12);
    _introLabel.text = @"XXX机构";
    _introLabel.textColor = [UIColor whiteColor];
    [_topView addSubview:_introLabel];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = EdlineV5_Color.backColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

// MARK: - tableview 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 56)];
    sectionHead.backgroundColor = [UIColor redColor];
    return sectionHead;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    sectionHead.backgroundColor = EdlineV5_Color.fengeLineColor;
    return sectionHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *reuse = @"HomePageCourseTypeTwoCelInstitutionl";
        HomePageCourseTypeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageCourseTypeTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setHomePageCourseTypeTwoCellInfo:@[@"",@"",@"",@"",@""]];
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *reuse = @"HomePageCourseTypeTwoCell";
        HomePageCourseTypeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[HomePageCourseTypeTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell setHomePageCourseTypeTwoCellInfo:@[@"",@"",@"",@"",@""]];
        return cell;
    } else {
        static NSString *reuse = @"homeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    } else if (indexPath.section == 1) {
        return [self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
    } else {
        return 0.0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > MACRO_UI_STATUSBAR_HEIGHT) {
        _titleImage.alpha = 1;
    }
    if (scrollView.contentOffset.y <= 0) {
        _titleImage.alpha = 0;
    }
}

- (void)leftBackButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
