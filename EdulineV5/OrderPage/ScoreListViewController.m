//
//  ScoreListViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ScoreListViewController.h"
#import "V5_Constant.h"
#import "AppDelegate.h"
#import "Net_Path.h"
#import "ScoreListCell.h"

@interface ScoreListViewController ()<UITableViewDelegate,UITableViewDataSource,scoreListCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) UILabel *themeLabel;

//@property (strong, nonatomic) UILabel *dfScoreTitle;
//@property (strong, nonatomic) UILabel *dfScoreIntro;
//@property (strong, nonatomic) UIButton *dfScoreChooseButton;

@property (strong, nonatomic) UIView *bottomBackView;
@property (strong, nonatomic) UIButton *suerButton;

//@property (strong, nonatomic) ScoreListModel *topScoreModel;

@end

@implementation ScoreListViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = [AppDelegate delegate];
    RootV5VC * nv = (RootV5VC *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _dataSource = [NSMutableArray new];
    _changeStatusArray = [NSMutableArray new];
    
//    _topScoreModel = [ScoreListModel new];
//    _topScoreModel.is_default = YES;
    
    if (_currentSelectModel) {
        // 检索数据源
        for (int i = 0; i < _dataSource.count; i++) {
            ScoreListModel *model = _dataSource[i];
            if ([model.credit isEqualToString:_currentSelectModel.credit]) {
                model.is_selected = YES;
            } else {
                model.is_selected = NO;
            }
            [_dataSource replaceObjectAtIndex:i withObject:model];
        }
    }
    
    _titleImage.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelfVC)];
    [self.view addGestureRecognizer:tap];
    [self makeTopView];
    [self makeTableView];
    [self makeBottomView];
}

- (void)makeTopView {
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 361.5 + 49 - MACRO_UI_TABBAR_HEIGHT , MainScreenWidth, MainScreenHeight - 90)];
    _whiteView.layer.masksToBounds = YES;
    _whiteView.layer.cornerRadius = 17;
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_whiteView];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 108.5 - 50)];
    _themeLabel.text = @"积分抵扣";
    _themeLabel.font = SYSTEMFONT(16);
    _themeLabel.centerX = MainScreenWidth / 2.0;
    _themeLabel.textAlignment = NSTextAlignmentCenter;
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    [_whiteView addSubview:_themeLabel];
    
//    _dfScoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, _themeLabel.bottom, 150, 50)];
//    _dfScoreTitle.font = SYSTEMFONT(15);
//    _dfScoreTitle.textColor = EdlineV5_Color.textFirstColor;
//    ScoreListModel *dfS = _dataSource[0];
//
//    _dfScoreTitle.text = [NSString stringWithFormat:@"可使用积分%@",dfS.credit];
//    [_whiteView addSubview:_dfScoreTitle];
//
//    _dfScoreChooseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 5 - 40, _themeLabel.bottom + 5, 40, 40)];
//    [_dfScoreChooseButton setImage:Image(@"checkbox_def") forState:0];
//    [_dfScoreChooseButton setImage:[Image(@"checkbox_blue") converToMainColor] forState:UIControlStateSelected];
//    [_dfScoreChooseButton addTarget:self action:@selector(dfScoreSeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_whiteView addSubview:_dfScoreChooseButton];
//    _dfScoreChooseButton.selected = _topScoreModel.is_selected;
//
//    _dfScoreIntro = [[UILabel alloc] initWithFrame:CGRectMake(_dfScoreChooseButton.left - 150, _themeLabel.bottom, 150, 50)];
//    _dfScoreIntro.font = SYSTEMFONT(13);
//    _dfScoreIntro.textColor = EdlineV5_Color.textThirdColor;
//    _dfScoreIntro.textAlignment = NSTextAlignmentRight;
//    _dfScoreIntro.text = [NSString stringWithFormat:@"可抵%@%@",IOSMoneyTitle,dfS.credit];
//    [_whiteView addSubview:_dfScoreIntro];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _whiteView.top + 58.5, MainScreenWidth, MainScreenHeight - (_whiteView.top + 58.5) - MACRO_UI_TABBAR_HEIGHT)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
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
    _suerButton.backgroundColor = EdlineV5_Color.themeColor;
    [_suerButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBackView addSubview:_suerButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"ScoreListCell";
    ScoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ScoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setScoreCellInfo:_dataSource[indexPath.row] cellIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)sureButtonClicked:(UIButton *)sender {
    
    ScoreListModel *current_model;
    for (int i = 0; i < _dataSource.count; i++) {
        ScoreListModel *model = _dataSource[i];
        if (model.is_selected) {
            current_model = model;
            break;
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(scoreChooseModel:)]) {
        [_delegate scoreChooseModel:current_model];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)hiddenSelfVC {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

// MARK: - 顶部默认积分选择按钮点击事件
- (void)dfScoreSeleteButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
//    _topScoreModel.is_selected = sender.selected;
    if (sender.selected) {
        for (int i = 0; i < _dataSource.count; i++) {
            ScoreListModel *model = _dataSource[i];
            model.is_selected = NO;
            [_dataSource replaceObjectAtIndex:i withObject:model];
        }
        [_tableView reloadData];
    }
}

// MARK: - cell代理
- (void)scoreChoose:(ScoreListCell *)scoreCell {
    for (int i = 0; i < _dataSource.count; i++) {
        ScoreListModel *model = _dataSource[i];
        if (i == scoreCell.cellIndexpath.row) {
            model.is_selected = !model.is_selected;
        } else {
            model.is_selected = NO;
        }
        [_dataSource replaceObjectAtIndex:i withObject:model];
    }
    [_tableView reloadData];
}

@end
