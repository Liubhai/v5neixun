//
//  ShopCarManagerVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/30.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ShopCarManagerVC.h"
#import "KaquanCell.h"
#import "ShopCarCell.h"
#import "V5_Constant.h"
#import "LingquanViewController.h"
#import "ShopCarManagerFinalVC.h"

@interface ShopCarManagerVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourse;

@end

@implementation ShopCarManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"购物车";
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"管理" forState:0];
    [_rightButton setTitle:@"完成" forState:UIControlStateSelected];
    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    _rightButton.hidden = NO;
    _dataSourse = [NSMutableArray new];
    [self makeTableView];
    [self makeDownView];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

- (void)makeDownView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    NSString *openText = @"全选";
    CGFloat openWidth = [openText sizeWithFont:SYSTEMFONT(13)].width + 4 + 20;
    CGFloat space = 2.0;
    
    _allSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, openWidth, 30)];
    [_allSelectBtn setImage:Image(@"checkbox_orange") forState:UIControlStateSelected];
    [_allSelectBtn setImage:Image(@"checkbox_def") forState:0];
    [_allSelectBtn setTitle:@"全选" forState:0];
    [_allSelectBtn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
    _allSelectBtn.titleLabel.font = SYSTEMFONT(13);
    _allSelectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _allSelectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_allSelectBtn addTarget:self action:@selector(headSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _allSelectBtn.centerY = 49/2.0;
    [_bottomView addSubview:_allSelectBtn];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 110, 0, 110, 36)];
    [_submitButton setTitle:@"去结算" forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height / 2.0;
    _submitButton.centerY = _allSelectBtn.centerY;
    [_submitButton addTarget:self action:@selector(submiteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_submitButton];
    
    _finalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_submitButton.left - 200 - 15, 0, 200, 49)];
    _finalPriceLabel.textColor = EdlineV5_Color.faildColor;
    _finalPriceLabel.font = SYSTEMFONT(15);
    _finalPriceLabel.text = @"合计: ¥190.00";
    _finalPriceLabel.textAlignment = NSTextAlignmentRight;
    [_bottomView addSubview:_finalPriceLabel];
    
    NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:_finalPriceLabel.text];
    [pass addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:NSMakeRange(0, 3)];
    _finalPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_bottomView addSubview:line];
    
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0, 0, MainScreenWidth/2.0, 49)];
    [_deleteBtn setTitleColor:EdlineV5_Color.youhuijuanColor forState:0];
    _deleteBtn.titleLabel.font = SYSTEMFONT(16);
    [_deleteBtn setTitle:@"删除" forState:0];
    [_bottomView addSubview:_deleteBtn];
    _deleteBtn.hidden = YES;
    
    _midLine = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0, 0, 0.5, 12)];
    _midLine.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_bottomView addSubview:_midLine];
    _midLine.centerY = _deleteBtn.centerY;
    _midLine.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 70)];
    head.backgroundColor = [UIColor whiteColor];
    UIView *jiange = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 9.5)];
    jiange.backgroundColor = EdlineV5_Color.fengeLineColor;
    [head addSubview:jiange];
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 24.5, 30, 30)];
    [selectBtn setImage:Image(@"checkbox_orange") forState:UIControlStateSelected];
    [selectBtn setImage:Image(@"checkbox_def") forState:0];
    [selectBtn addTarget:self action:@selector(headSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [head addSubview:selectBtn];
    UILabel *jigouTitle = [[UILabel alloc] initWithFrame:CGRectMake(selectBtn.right + 7, 9.5, 150, 60)];
    jigouTitle.textColor = EdlineV5_Color.textFirstColor;
    jigouTitle.text = [NSString stringWithFormat:@"机构名称%@",@(section)];
    [head addSubview:jigouTitle];
    UIButton *lingquan = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, 9.5, 30, 60)];
    [lingquan setTitle:@"领券" forState:0];
    [lingquan setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    lingquan.titleLabel.font = SYSTEMFONT(13);
    [lingquan addTarget:self action:@selector(lingquanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [head addSubview:lingquan];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 69.5, MainScreenWidth, 0.5)];
    line.backgroundColor = EdlineV5_Color.fengeLineColor;
    [head addSubview:line];
    return head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"ShopCarCell";
    ShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ShopCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId cellType:YES];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

- (void)headSelectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)rightButtonClick:(id)sender {
    _rightButton.selected = !_rightButton.selected;
    if (_rightButton.selected) {
        _allSelectBtn.centerX = MainScreenWidth / 4.0;
        _midLine.hidden = NO;
        _deleteBtn.hidden = NO;
        _finalPriceLabel.hidden = YES;
        _submitButton.hidden = YES;
    } else {
        [_allSelectBtn setLeft:10];
        _midLine.hidden = YES;
        _deleteBtn.hidden = YES;
        _finalPriceLabel.hidden = NO;
        _submitButton.hidden = NO;
    }
}

- (void)lingquanButtonClicked:(UIButton *)sender {
    LingquanViewController *vc = [[LingquanViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
}

- (void)submiteButtonClick:(UIButton *)sender {
    ShopCarManagerFinalVC *vc = [[ShopCarManagerFinalVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
