//
//  IncomeDetailVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/13.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "IncomeDetailVC.h"
#import "V5_Constant.h"
#import "BalanceDetailCell.h"
#import "CourseSortVC.h"

@interface IncomeDetailVC ()<UITableViewDelegate, UITableViewDataSource, CourseSortVCDelegate> {
    NSString *courseSortIdString;
    NSString *courseSortString;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIButton *incomeButton;
@property (strong, nonatomic) UIButton *timeButton;
@property (strong, nonatomic) UILabel *allIncomeLabel;



@end

@implementation IncomeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [NSMutableArray new];
    _titleLabel.text = @"明细";
    [self makeTopView];
    [self makeTabelView];
}

- (void)makeTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 54)];
    topView.backgroundColor = EdlineV5_Color.backColor;
    [self.view addSubview:topView];
    
    _incomeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 54)];
    _incomeButton.titleLabel.font = SYSTEMFONT(14);
    _incomeButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_incomeButton setTitle:@"全部" forState:UIControlStateNormal];
    [_incomeButton setImage:Image(@"sanjiao_icon_nor") forState:UIControlStateNormal];
    [_incomeButton setImage:[Image(@"sanjiao_icon_pre") converToOtherColor:EdlineV5_Color.themeColor] forState:UIControlStateSelected];
    [_incomeButton setTitleColor:EdlineV5_Color.textFirstColor forState:UIControlStateNormal];
    [_incomeButton setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    [EdulineV5_Tool dealButtonImageAndTitleUI:_incomeButton];
    [_incomeButton addTarget:self action:@selector(headerButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_incomeButton];
    
    _timeButton = [[UIButton alloc] initWithFrame:CGRectMake(_incomeButton.right, 0, 70, 54)];
    _timeButton.titleLabel.font = SYSTEMFONT(14);
    _timeButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_timeButton setTitle:@"时间" forState:UIControlStateNormal];
    [_timeButton setImage:Image(@"sanjiao_icon_nor") forState:UIControlStateNormal];
    [_timeButton setImage:[Image(@"sanjiao_icon_pre") converToOtherColor:EdlineV5_Color.themeColor] forState:UIControlStateSelected];
    [_timeButton setTitleColor:EdlineV5_Color.textFirstColor forState:UIControlStateNormal];
    [_timeButton setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    [EdulineV5_Tool dealButtonImageAndTitleUI:_timeButton];
    [_timeButton addTarget:self action:@selector(headerButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_timeButton];
    
    _allIncomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, 0, 100, 54)];
    _allIncomeLabel.text = @"统计 ¥232.32";
    _allIncomeLabel.font = SYSTEMFONT(15);
    _allIncomeLabel.textColor = EdlineV5_Color.textThirdColor;
    _allIncomeLabel.textAlignment = NSTextAlignmentRight;
    [topView addSubview:_allIncomeLabel];
}

- (void)makeTabelView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 54, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 54)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstData)];
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
//    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
//    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;//_dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"BalanceDetailCell";
    BalanceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[BalanceDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77.5;
}

- (void)headerButtonCilck:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
    sender.selected = !sender.selected;
    if (sender.selected) {
        CourseSortVC *vc = [[CourseSortVC alloc] init];
        vc.notHiddenNav = NO;
        vc.hiddenNavDisappear = YES;
        vc.isMainPage = NO;
        vc.pageClass = (sender == _incomeButton) ? @"incomeType" : @"incomeTime";
        vc.delegate = self;
        if (SWNOTEmptyStr(courseSortIdString)) {
            vc.typeId = courseSortIdString;
        }
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 54, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 54);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    }
}

- (void)sortTypeChoose:(NSDictionary *)info {
    if (SWNOTEmptyDictionary(info)) {
        courseSortString = [NSString stringWithFormat:@"%@",[info objectForKey:@"title"]];
        courseSortIdString = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
        if (_incomeButton.selected) {
            _incomeButton.selected = NO;
            [_incomeButton setTitle:courseSortString forState:0];
            [EdulineV5_Tool dealButtonImageAndTitleUI:_incomeButton];
        }
        if (_timeButton.selected) {
            _timeButton.selected = NO;
            [_timeButton setTitle:courseSortString forState:0];
            [EdulineV5_Tool dealButtonImageAndTitleUI:_timeButton];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCourseAll" object:nil];
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
