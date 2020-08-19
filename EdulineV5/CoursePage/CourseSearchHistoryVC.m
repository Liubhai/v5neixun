//
//  CourseSearchHistoryVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/2.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseSearchHistoryVC.h"
#import "V5_Constant.h"
#import "SearchHistoryListCell.h"
#import "Net_Path.h"
#import "CourseSearchListVC.h"

@interface CourseSearchHistoryVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITextField *institutionSearch;
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *searchDataSource;
@property (strong, nonatomic) NSMutableArray *hotDataSource;
@property (strong, nonatomic) UIView *hotView;
@property (strong, nonatomic) UIView *historyView;

@end

@implementation CourseSearchHistoryVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self searchHotSearchInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _searchDataSource = [NSMutableArray new];
    _hotDataSource = [NSMutableArray new];
    
    _rightButton.hidden = NO;
    [_rightButton setTitle:@"搜索" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [_rightButton setImage:nil forState:0];
    [self makeTopSearch];
    [self makeMainScrollView];
//    [self maketableView];
    _tableView.hidden = YES;
    
    [self searchHotSearchInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.top, _titleLabel.width, 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索课程" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 17 + 15 + 10, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;
    _institutionSearch.clearButtonMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(17, 7.5, 15, 15)];
    [button setImage:Image(@"home_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
}

- (void)makeMainScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
}

- (void)maketableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"SearchHistoryListCell";
    SearchHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[SearchHistoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setSearchHistoryListCellInfo:_searchDataSource[indexPath.row] searchKeyWord:_institutionSearch.text];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_institutionSearch resignFirstResponder];
}

- (void)makeScrollViewUI {
    if (!_mainScrollView) {
        return;
    }
    [_mainScrollView removeAllSubviews];
    if (!_hotView) {
        _hotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0)];
        _hotView.backgroundColor = [UIColor whiteColor];
    }
    [_mainScrollView addSubview:_hotView];
    [_hotView removeAllSubviews];
    
    UIImageView *hotIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 12, 16)];
    hotIcon.image = Image(@"search_hot");
    [_hotView addSubview:hotIcon];
    
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(hotIcon.right + 7, 0, 100, 60)];
    hotLabel.font = SYSTEMFONT(14);
    hotLabel.textColor = EdlineV5_Color.textFirstColor;
    hotLabel.text = @"热门搜索";
    [_hotView addSubview:hotLabel];
    hotIcon.centerY = hotLabel.centerY;
    
    
    if (_hotDataSource.count) {
        CGFloat topSpacee = 20.0;
        CGFloat rightSpace = 15.0;
        CGFloat btnInSpace = 10.0;
        CGFloat XX = 15.0;
        CGFloat YY = 0.0 + hotLabel.bottom;
        CGFloat btnHeight = 32.0;
        for (int i = 0; i<_hotDataSource.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, 0, btnHeight)];
            [btn addTarget:self action:@selector(courseTitleButClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:_hotDataSource[i] forState:0];
            btn.titleLabel.font = SYSTEMFONT(14);
            [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
            btn.backgroundColor = EdlineV5_Color.backColor;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = btnHeight / 2.0;
            CGFloat btnWidth = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2;
            if ((btnWidth + XX) > (MainScreenWidth - 15)) {
                XX = 15.0;
                YY = YY + topSpacee + btnHeight;
            }
            btn.frame = CGRectMake(XX, YY, btnWidth, btnHeight);
            XX = btn.right + rightSpace;
            if (i == _hotDataSource.count - 1) {
                [_hotView setHeight:btn.bottom];
            }
            [_hotView addSubview:btn];
        }
    } else {
        [_hotView setHeight:hotLabel.bottom];
    }
    
    
    // 历史搜索
    if (!_historyView) {
        _historyView = [[UIView alloc] initWithFrame:CGRectMake(0, _hotView.bottom, MainScreenWidth, 0)];
        _historyView.backgroundColor = [UIColor whiteColor];
    }
    [_mainScrollView addSubview:_historyView];
    [_historyView removeAllSubviews];
    
    UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    historyLabel.font = SYSTEMFONT(14);
    historyLabel.textColor = EdlineV5_Color.textFirstColor;
    historyLabel.text = @"历史搜索";
    [_historyView addSubview:historyLabel];
    
    UIButton *clearHistoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 32, 0, 32, 60)];
    [clearHistoryBtn setTitle:@"清空" forState:0];
    [clearHistoryBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    clearHistoryBtn.titleLabel.font = SYSTEMFONT(14);
    [clearHistoryBtn addTarget:self action:@selector(clearHistoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_historyView addSubview:clearHistoryBtn];
    
    if (_searchDataSource.count) {
        CGFloat topSpacee = 20.0;
        CGFloat rightSpace = 15.0;
        CGFloat btnInSpace = 10.0;
        CGFloat XX = 15.0;
        CGFloat YY = 0.0 + historyLabel.bottom;
        CGFloat btnHeight = 32.0;
        for (int i = 0; i<_searchDataSource.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, 0, btnHeight)];
            [btn addTarget:self action:@selector(courseTitleButClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:_searchDataSource[i] forState:0];
            btn.titleLabel.font = SYSTEMFONT(14);
            [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
            btn.backgroundColor = EdlineV5_Color.backColor;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = btnHeight / 2.0;
            CGFloat btnWidth = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2;
            if ((btnWidth + XX) > (MainScreenWidth - 15)) {
                XX = 15.0;
                YY = YY + topSpacee + btnHeight;
            }
            btn.frame = CGRectMake(XX, YY, btnWidth, btnHeight);
            XX = btn.right + rightSpace;
            if (i == _searchDataSource.count - 1) {
                [_historyView setHeight:btn.bottom];
            }
            [_historyView addSubview:btn];
        }
    } else {
        [_historyView setHeight:hotLabel.bottom];
    }
    _mainScrollView.contentSize = CGSizeMake(0, (_historyView.bottom > _mainScrollView.height) ? _historyView.bottom : _mainScrollView.height);
}

- (void)textfieldDidChanged:(NSNotification *)notice {
    UITextField *textfield = (UITextField *)notice.object;
    _mainScrollView.hidden = NO;
//    if (textfield.text.length>0) {
//        _mainScrollView.hidden = YES;
//        _tableView.hidden = YES;
//    } else {
//        _mainScrollView.hidden = NO;
//        _tableView.hidden = YES;
//    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_institutionSearch resignFirstResponder];
        [self jumpSearchListMainPage];
        return NO;
    }
    return YES;
}

- (void)jumpSearchListMainPage {
    
    if (!SWNOTEmptyStr(_institutionSearch.text)) {
        [self showHudInView:self.view showHint:@"请输入搜索课程的名字"];
        return;
    }
    // 把搜索历史数据存本地
    if ([_searchDataSource containsObject:_institutionSearch.text]) {
        [_searchDataSource removeObject:_institutionSearch.text];
    }
    [_searchDataSource addObject:_institutionSearch.text];
    
    NSArray *pass = [NSArray arrayWithArray:_searchDataSource];
    [[NSUserDefaults standardUserDefaults] setObject:pass forKey:@"homepagesearchArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CourseSearchListVC *vc = [[CourseSearchListVC alloc] init];
    vc.isSearch = YES;
    vc.searchKeyWord = _institutionSearch.text;
    vc.hiddenNavDisappear = YES;
    vc.notHiddenNav = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 课程名称按钮点击事件
- (void)courseTitleButClick:(UIButton *)sender {
    // 把搜索历史数据存本地
    if ([_searchDataSource containsObject:sender.titleLabel.text]) {
        [_searchDataSource removeObject:sender.titleLabel.text];
    }
    [_searchDataSource addObject:sender.titleLabel.text];
    
    NSArray *pass = [NSArray arrayWithArray:_searchDataSource];
    [[NSUserDefaults standardUserDefaults] setObject:pass forKey:@"homepagesearchArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CourseSearchListVC *vc = [[CourseSearchListVC alloc] init];
    vc.isSearch = YES;
    vc.searchKeyWord = sender.titleLabel.text;
    vc.hiddenNavDisappear = YES;
    vc.notHiddenNav = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 清空历史搜索记录按钮点击事件
- (void)clearHistoryBtnClick:(UIButton *)sender {
    
    [_searchDataSource removeAllObjects];
    NSArray *pass = [NSArray arrayWithArray:_searchDataSource];
    [[NSUserDefaults standardUserDefaults] setObject:pass forKey:@"homepagesearchArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self makeScrollViewUI];
    
}

- (void)rightButtonClick:(id)sender {
    [_institutionSearch resignFirstResponder];
    [self jumpSearchListMainPage];
}

- (void)searchHotSearchInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path hotSearchNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            [_hotDataSource removeAllObjects];
            [_hotDataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
            [_searchDataSource removeAllObjects];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"homepagesearchArray"]) {
                [_searchDataSource addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"homepagesearchArray"]];
            }
            [self makeScrollViewUI];
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

@end
