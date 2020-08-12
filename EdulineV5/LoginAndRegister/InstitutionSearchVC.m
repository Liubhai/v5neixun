//
//  InstitutionSearchVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/12.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "InstitutionSearchVC.h"
#import "V5_Constant.h"
#import "SearchHistoryListCell.h"
#import "Net_Path.h"

@interface InstitutionSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITextField *institutionSearch;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *searchDataSource;
@property (strong, nonatomic) NSMutableArray *localArray;

@end

@implementation InstitutionSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _searchDataSource = [NSMutableArray new];
    _localArray = [NSMutableArray new];
    _rightButton.hidden = NO;
    [_rightButton setTitle:@"搜索" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [_rightButton setImage:nil forState:0];
    [self makeTopSearch];
    [self maketableView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.top, _titleLabel.width, 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入机构名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;
    _institutionSearch.clearButtonMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 15, 15)];
    [button setImage:Image(@"home_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_institutionSearch resignFirstResponder];
        [self jumpSearchListMainPage];
        return NO;
    }
    return YES;
}

- (void)rightButtonClick:(id)sender {
    [_institutionSearch resignFirstResponder];
    [self jumpSearchListMainPage];
}

- (void)jumpSearchListMainPage {
    
    if (!SWNOTEmptyStr(_institutionSearch.text)) {
        [self showHudInView:self.view showHint:@"请输入搜索课程的名字"];
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LocalInstitutionSearchData"]) {
        [_localArray removeAllObjects];
        [_localArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"LocalInstitutionSearchData"]];
    }
    // 把搜索历史数据存本地
    if ([_localArray containsObject:_institutionSearch.text]) {
        [_localArray removeObject:_institutionSearch.text];
    }
    [_localArray addObject:_institutionSearch.text];
    
    NSArray *pass = [NSArray arrayWithArray:_localArray];
    [[NSUserDefaults standardUserDefaults] setObject:pass forKey:@"LocalInstitutionSearchData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocalInstitutionData" object:nil];
    
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
