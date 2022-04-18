//
//  MyCertificateListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/30.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "MyCertificateListVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "OrderScreenViewController.h"
#import "MyCertificateListCell.h"

@interface MyCertificateListVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, OrderScreenViewControllerDelegate> {
    NSInteger page;
    
    // 筛选
    NSString *screenTitle;
    NSString *screenType;
    BOOL isStart;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UITextField *institutionSearch;

/// 筛选视图
@property (strong, nonatomic) UIView *screenView;
@property (strong, nonatomic) UIView *screenBackView;

@property (strong, nonatomic) UIButton *lowBtn;
@property (strong, nonatomic) UIButton *highBtn;

@property (strong, nonatomic) UIButton *clearBtn;
@property (strong, nonatomic) UIButton *sureBtn;

/// 时间选择器
@property (strong, nonatomic) UIView *datePickerView;
@property (strong, nonatomic) UIView *datePickerBackView;
@property (strong, nonatomic) UIButton *middlePickerButton;
@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation MyCertificateListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    
    isStart = YES;
    
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"lesson_screen_nor") forState:0];
    [_rightButton setImage:[Image(@"lesson_screen_nor") converToMainColor] forState:UIControlStateSelected];
    
    _dataSource = [NSMutableArray new];
    page = 1;
    [self makeTopSearch];
    [self makeTableView];
    [self makeScreenUI];
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(_leftButton.right, 0, MainScreenWidth - _rightButton.width - _leftButton.right , 30)];
    _institutionSearch.centerY = _titleLabel.centerY;
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入证书名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = _institutionSearch.height / 2.0;
    _institutionSearch.backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 42, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(17, 7.5, 15, 15)];
    [button setImage:Image(@"home_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = EdlineV5_Color.backColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getOrderList)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreOrderList)];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"MyCertificateListCell";
    MyCertificateListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[MyCertificateListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setMyCertificateListCellInfo:_dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 123 + 12;//[self tableView:self.tableView cellForRowAtIndexPath:indexPath].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)getOrderList {
    page = 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    if (SWNOTEmptyStr(_institutionSearch.text)) {
        [param setObject:_institutionSearch.text forKey:@"title"];
    }
    
    if (SWNOTEmptyStr(_highBtn.titleLabel.text) && ![_highBtn.titleLabel.text containsString:@"时间"] ) {
        [param setObject:[self getTimeStrWithString:_highBtn.titleLabel.text] forKey:@"start_time"];
    }
    
    if (SWNOTEmptyStr(_lowBtn.titleLabel.text) && ![_lowBtn.titleLabel.text containsString:@"时间"] ) {
        [param setObject:[self getTimeStrWithString:_lowBtn.titleLabel.text] forKey:@"end_time"];
    }
    
    [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path certificateListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
            }
        }
        if (_dataSource.count<10) {
            _tableView.mj_footer.hidden = YES;
        } else {
            _tableView.mj_footer.hidden = NO;
        }
        [_tableView tableViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
        [_tableView reloadData];
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreOrderList {
    page = page + 1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@"10" forKey:@"count"];
    if (SWNOTEmptyStr(_institutionSearch.text)) {
        [param setObject:_institutionSearch.text forKey:@"title"];
    }
    if (SWNOTEmptyStr(_highBtn.titleLabel.text) && ![_highBtn.titleLabel.text containsString:@"时间"] ) {
        [param setObject:[self getTimeStrWithString:_highBtn.titleLabel.text] forKey:@"start_time"];
    }
    if (SWNOTEmptyStr(_lowBtn.titleLabel.text) && ![_lowBtn.titleLabel.text containsString:@"时间"] ) {
        [param setObject:[self getTimeStrWithString:_lowBtn.titleLabel.text] forKey:@"end_time"];
    }
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path certificateListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
                [_dataSource addObjectsFromArray:pass];
                if (pass.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
                }
            }
        }
        [_tableView reloadData];
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _rightButton.selected = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenOrderScreenAll" object:nil];
    _screenView.hidden = YES;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_institutionSearch resignFirstResponder];
        [self getOrderList];
        return NO;
    }
    return YES;
}

- (void)rightButtonClick:(id)sender {
    _rightButton.selected = !_rightButton.selected;
    [_institutionSearch resignFirstResponder];
    if (_rightButton.selected) {
//        OrderScreenViewController *vc = [[OrderScreenViewController alloc] init];
//        vc.delegate = self;
//        vc.screenTitle = screenTitle;
//        vc.screenType = screenType;
//        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
//        [self.view addSubview:vc.view];
//        [self addChildViewController:vc];
        _screenView.hidden = NO;
    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenOrderScreenAll" object:nil];
        _screenView.hidden = YES;
    }
}

- (void)sureChooseOrderScreen:(NSDictionary *)orderScreenInfo {
    if (SWNOTEmptyDictionary(orderScreenInfo)) {
        screenTitle = [NSString stringWithFormat:@"%@",[orderScreenInfo objectForKey:@"screenTitle"]];
        screenType = [NSString stringWithFormat:@"%@",[orderScreenInfo objectForKey:@"screenType"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenOrderScreenAll" object:nil];
        _rightButton.selected = NO;
        //
        [self getOrderList];
    }
}

// MARK: - 筛选视图构建
- (void)makeScreenUI {
    
    _screenView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _screenView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
    [self.view addSubview:_screenView];
    _screenView.hidden = YES;
    
    _screenBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 157)];
    _screenBackView.backgroundColor = [UIColor whiteColor];
    [_screenView addSubview:_screenBackView];
    
    UILabel *themeTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    themeTitle.text = @"按时间筛选";
    themeTitle.font = SYSTEMFONT(14);
    themeTitle.textColor = EdlineV5_Color.textThirdColor;
    [_screenBackView addSubview:themeTitle];
    
    _highBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, themeTitle.bottom, (MainScreenWidth - 30 - 12 - 25)/2.0, 32)];
    [_highBtn setTitle:@"起始时间" forState:0];
    [_highBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _highBtn.titleLabel.font = SYSTEMFONT(14);
    _highBtn.backgroundColor = EdlineV5_Color.backColor;
    _highBtn.layer.masksToBounds = YES;
    _highBtn.layer.cornerRadius = _highBtn.height / 2.0;
    [_highBtn addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_screenBackView addSubview:_highBtn];
    
    _lowBtn = [[UIButton alloc] initWithFrame:CGRectMake(_highBtn.right + 25, themeTitle.bottom, (MainScreenWidth - 30 - 12 - 25)/2.0, 32)];
    [_lowBtn setTitle:@"结束时间" forState:0];
    [_lowBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _lowBtn.titleLabel.font = SYSTEMFONT(14);
    _lowBtn.backgroundColor = EdlineV5_Color.backColor;
    _lowBtn.layer.masksToBounds = YES;
    _lowBtn.layer.cornerRadius = _lowBtn.height / 2.0;
    [_lowBtn addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_screenBackView addSubview:_lowBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 157 - 45, MainScreenWidth, 1)];
    line.backgroundColor = EdlineV5_Color.backColor;
    [_screenBackView addSubview:line];
    
    _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 157 - 44, MainScreenWidth/2.0, 44)];
    [_clearBtn setTitle:@"重置" forState:0];
    [_clearBtn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    _clearBtn.titleLabel.font = SYSTEMFONT(16);
    [_clearBtn addTarget:self action:@selector(cleanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_screenBackView addSubview:_clearBtn];
    
    _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0, 157 - 44, MainScreenWidth/2.0, 44)];
    [_sureBtn setTitle:@"确定" forState:0];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    _sureBtn.backgroundColor = EdlineV5_Color.themeColor;
    _sureBtn.titleLabel.font = SYSTEMFONT(16);
    [_sureBtn addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_screenBackView addSubview:_sureBtn];
}

- (void)startButtonClick:(UIButton *)sender {
    [self makeDatePicker:YES];
}

- (void)finishButtonClick:(UIButton *)sender {
    [self makeDatePicker:NO];
}

- (void)cleanButtonClick:(UIButton *)sender {
    // 重置
    [_highBtn setTitle:@"起始时间" forState:0];
    [_highBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    
    [_lowBtn setTitle:@"结束时间" forState:0];
    [_lowBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    
    _rightButton.selected = NO;
    _screenView.hidden = YES;
    [_tableView.mj_header beginRefreshing];
}

- (void)sureButtonClicked:(UIButton *)sender {
    _rightButton.selected = NO;
    _screenView.hidden = YES;
    [_tableView.mj_header beginRefreshing];
}

- (NSString *)getTimeStrWithString:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳
    return timeStr;
}

- (void)makeDatePicker:(BOOL)start {
    isStart = start;
    if (!_datePicker) {
        
        _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        _datePickerView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
        [self.view addSubview:_datePickerView];
        
        _datePickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _datePickerView.bottom - 137 - 80 - 42, MainScreenWidth, 137 + 80 + 42)];
        _datePickerBackView.backgroundColor = [UIColor whiteColor];
        [_datePickerView addSubview:_datePickerBackView];
        
        UIButton *cancelPickerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30 + 32, 42)];
        [cancelPickerButton setTitle:@"取消" forState:0];
        [cancelPickerButton setTitleColor:EdlineV5_Color.textThirdColor forState:0];
        [cancelPickerButton addTarget:self action:@selector(cancelPickerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        cancelPickerButton.titleLabel.font = SYSTEMFONT(16);
        [_datePickerBackView addSubview:cancelPickerButton];
        
        _middlePickerButton = [[UIButton alloc] initWithFrame:CGRectMake(cancelPickerButton.right, 0, 100, 42)];
        [_middlePickerButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        _middlePickerButton.titleLabel.font = SYSTEMFONT(16);
        [_datePickerBackView addSubview:_middlePickerButton];
        _middlePickerButton.centerX = _datePickerBackView.width / 2.0;
        
        UIButton *surePickerButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30 - 32, 0, 30 + 32, 42)];
        [surePickerButton setTitle:@"完成" forState:0];
        [surePickerButton setTitleColor:EdlineV5_Color.themeColor forState:0];
        surePickerButton.titleLabel.font = SYSTEMFONT(16);
        [surePickerButton addTarget:self action:@selector(surePickerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerBackView addSubview:surePickerButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 41, MainScreenWidth, 1)];
        line.backgroundColor = EdlineV5_Color.backColor;
        [_datePickerBackView addSubview:line];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 42, MainScreenWidth, 137 + 80)];
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePickerBackView addSubview:_datePicker];
    }
    _datePickerView.hidden = NO;
    [_datePicker setDate:[NSDate date] animated:YES];
    if (start) {
        [_middlePickerButton setTitle:@"起始时间" forState:0];
    } else {
        [_middlePickerButton setTitle:@"结束时间" forState:0];
    }
}

- (void)cancelPickerButtonClick {
    _datePickerView.hidden = YES;
}

- (void)surePickerButtonClick {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *dateString = [formatter stringFromDate:_datePicker.date];
    if (isStart) {
        [_highBtn setTitle:dateString forState:0];
        [_highBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    } else {
        [_lowBtn setTitle:dateString forState:0];
        [_lowBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    }
    _datePickerView.hidden = YES;
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
