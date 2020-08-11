//
//  InstitutionsChooseVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "InstitutionsChooseVC.h"
#import "V5_Constant.h"

@interface InstitutionsChooseVC ()<UITextFieldDelegate, UIScrollViewDelegate>

@end

@implementation InstitutionsChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _searchDataSource = [NSMutableArray new];
    [self makeSubView];
    [self getLocalInstitutionSearchData];
    // Do any additional setup after loading the view.
}

- (void)makeSubView {
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 268)];
    _backImageView.image = Image(@"searchorgan_bg");//[Image(@"searchorgan_bg") converToOtherColor:EdlineV5_Color.themeColor];
    [self.view addSubview:_backImageView];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 54, 44);
    [_leftBtn setImage:Image(@"close_button_white") forState:0];
    [self.view addSubview:_leftBtn];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _backImageView.height - 64 - 40, 200, 40)];
    _nameLabel.text = @"搜索机构";
    _nameLabel.font = SYSTEMFONT(28);
    _nameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_nameLabel];
    
    _searchTextF = [[UITextField alloc] initWithFrame:CGRectMake(30, _backImageView.height - 55 / 2.0, MainScreenWidth - 60, 55)];
    _searchTextF.delegate = self;
    _searchTextF.backgroundColor = [UIColor whiteColor];
    _searchTextF.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _searchTextF.layer.cornerRadius = 4;
    _searchTextF.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    _searchTextF.layer.shadowOpacity = 1;// 阴影透明度，默认0
    _searchTextF.layer.shadowOffset = CGSizeMake(0, 1);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    _searchTextF.layer.shadowRadius = 12;
    _searchTextF.textColor = EdlineV5_Color.textThirdColor;
    _searchTextF.font = SYSTEMFONT(15);
    _searchTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入机构名称" attributes:@{NSFontAttributeName:SYSTEMFONT(15),NSForegroundColorAttributeName:EdlineV5_Color.textThirdColor}];
    _searchTextF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    _searchTextF.leftViewMode = UITextFieldViewModeAlways;
    _searchTextF.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 22 * 2 + 20, 22)];
    _searchTextF.rightViewMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(22, 1, 20, 20)];
    [button setImage:[Image(@"searchorgan_button_blue") converToOtherColor:EdlineV5_Color.themeColor] forState:UIControlStateNormal];
    [_searchTextF.rightView addSubview:button];
    
    [self.view addSubview:_searchTextF];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT - 34, 80, 34)];
    [moreBtn setImage:[Image(@"searchorgan_next_icon_blue") converToMainColor] forState:0];
    [moreBtn setTitle:@"跳过" forState:0];
    moreBtn.titleLabel.font = SYSTEMFONT(16);
    [moreBtn setTitleColor:EdlineV5_Color.themeColor forState:0];
    [EdulineV5_Tool dealButtonImageAndTitleUI:moreBtn];
    moreBtn.centerX = MainScreenWidth / 2.0;
//    [moreBtn addTarget:self action:@selector(moreJoinCourseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
}

- (void)getLocalInstitutionSearchData {
    [_searchDataSource removeAllObjects];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LocalInstitutionSearchData"]) {
        [_searchDataSource addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"LocalInstitutionSearchData"]];
    }
    [self makeScrollViewUI];
}

// MARK: - 清空历史搜索记录按钮点击事件
- (void)clearHistoryBtnClick:(UIButton *)sender {
    
    [_searchDataSource removeAllObjects];
    NSArray *pass = [NSArray arrayWithArray:_searchDataSource];
    [[NSUserDefaults standardUserDefaults] setObject:pass forKey:@"LocalInstitutionSearchData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self makeScrollViewUI];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)makeScrollViewUI {
    // 历史搜索
    if (!_historyView) {
        _historyView = [[UIView alloc] initWithFrame:CGRectMake(0, _searchTextF.bottom + 30, MainScreenWidth, MainScreenHeight - (_searchTextF.bottom + 30) - MACRO_UI_TABBAR_HEIGHT - 22.5 - 20)];
        _historyView.backgroundColor = [UIColor whiteColor];
    }
    [self.view addSubview:_historyView];
    [_historyView removeAllSubviews];
    
    UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 30)];
    historyLabel.font = SYSTEMFONT(14);
    historyLabel.textColor = EdlineV5_Color.textFirstColor;
    historyLabel.text = @"历史搜索";
    [_historyView addSubview:historyLabel];
    
    UIButton *clearHistoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30 - 32, 0, 32, 30)];
    [clearHistoryBtn setTitle:@"清空" forState:0];
    [clearHistoryBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    clearHistoryBtn.titleLabel.font = SYSTEMFONT(14);
    [clearHistoryBtn addTarget:self action:@selector(clearHistoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_historyView addSubview:clearHistoryBtn];
    
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, historyLabel.bottom + 5, 100, 30)];
    noDataLabel.font = SYSTEMFONT(14);
    noDataLabel.textColor = EdlineV5_Color.textThirdColor;
    noDataLabel.text = @"暂无内容";
    noDataLabel.hidden = SWNOTEmptyArr(_searchDataSource) ? YES : NO;
    [_historyView addSubview:noDataLabel];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, historyLabel.bottom + 5, MainScreenWidth, _historyView.height - (historyLabel.bottom + 5))];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [_historyView addSubview:_mainScrollView];
    _mainScrollView.hidden = SWNOTEmptyArr(_searchDataSource) ? NO : YES;
    if (_searchDataSource.count) {
        CGFloat topSpacee = 20.0;
        CGFloat rightSpace = 15.0;
        CGFloat btnInSpace = 10.0;
        CGFloat XX = 30;
        CGFloat YY = 10;
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
            if ((btnWidth + XX) > (MainScreenWidth - 30)) {
                XX = 30;
                YY = YY + topSpacee + btnHeight;
            }
            btn.frame = CGRectMake(XX, YY, btnWidth, btnHeight);
            XX = btn.right + rightSpace;
            if (i == _searchDataSource.count - 1) {
                _mainScrollView.contentSize = CGSizeMake(0, btn.bottom);
            }
            [_mainScrollView addSubview:btn];
        }
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
