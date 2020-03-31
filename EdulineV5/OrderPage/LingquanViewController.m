//
//  LingquanViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/31.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LingquanViewController.h"
#import "KaquanCell.h"
#import "V5_Constant.h"
#import "AppDelegate.h"

@interface LingquanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIView *bottomBackView;
@property (strong, nonatomic) UIButton *suerButton;

@end

@implementation LingquanViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = [AppDelegate delegate];
    RootV5VC * nv = (RootV5VC *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleImage.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self makeTopView];
    [self makeTableView];
    [self makeBottomView];
}

- (void)makeTopView {
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, MainScreenWidth, MainScreenHeight - 90)];
    _whiteView.layer.masksToBounds = YES;
    _whiteView.layer.cornerRadius = 17;
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_whiteView];
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 52)];
    if (_getOrUse) {
        _themeLabel.text = @"领券";
    } else {
        _themeLabel.text = @"卡券";
    }
    _themeLabel.font = SYSTEMFONT(16);
    _themeLabel.centerX = MainScreenWidth / 2.0;
    _themeLabel.textAlignment = NSTextAlignmentCenter;
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    [_whiteView addSubview:_themeLabel];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _whiteView.top + 52, MainScreenWidth, MainScreenHeight - (_whiteView.top + 52) - MACRO_UI_TABBAR_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)makeBottomView {
    _bottomBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomBackView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_bottomBackView addSubview:line];
    
    _suerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (49 - 36) / 2.0, 320, 36)];
    _suerButton.centerX = MainScreenWidth / 2.0;
    _suerButton.layer.masksToBounds = YES;
    _suerButton.layer.cornerRadius = 18;
    [_suerButton setTitle:@"确定" forState:0];
    [_suerButton setTitleColor:[UIColor whiteColor] forState:0];
    _suerButton.titleLabel.font = SYSTEMFONT(16);
    _suerButton.backgroundColor = EdlineV5_Color.dazhekaColor;
    [_suerButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBackView addSubview:_suerButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"KaquanCell1";
    KaquanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[KaquanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId cellType:[NSString stringWithFormat:@"%@",@(indexPath.row + 1)]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

- (void)sureButtonClicked:(UIButton *)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
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
