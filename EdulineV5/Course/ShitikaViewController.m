//
//  ShitikaViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ShitikaViewController.h"
#import "V5_Constant.h"
#import "ShitikaCell.h"
#import "KaquanCell.h"
#import "ShopCarCell.h"

@interface ShitikaViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ShitikaCellDelegate>

@property (strong, nonatomic) UIView *topBackView;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UITextField *enterTextView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourse;

@end

@implementation ShitikaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"实体卡";
    _dataSourse = [NSMutableArray new];
    [self makeTopView];
    [self makeTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterTextFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc {
    
}

- (void)makeTableView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 30)];
    themeLabel.text = @"实体卡优惠";
    themeLabel.font = SYSTEMFONT(14);
    themeLabel.textColor = EdlineV5_Color.textFirstColor;
    [headerView addSubview:themeLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 60, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 60)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = headerView;
    [self.view addSubview:_tableView];
}

- (void)makeTopView {
    _topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 60)];
    _topBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topBackView];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 80, 12, 80, 36)];
    _sureButton.titleLabel.font = SYSTEMFONT(16);
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 4;
    [_sureButton setTitle:@"兑换" forState:0];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:0];
    [_sureButton setBackgroundColor:EdlineV5_Color.disableColor];
    [_topBackView addSubview:_sureButton];
    
    _enterTextView = [[UITextField alloc] initWithFrame:CGRectMake(15, 12, MainScreenWidth - 80 - 15 * 3, 36)];
    _enterTextView.font = SYSTEMFONT(14);
    _enterTextView.layer.masksToBounds = YES;
    _enterTextView.layer.cornerRadius = 4;
    _enterTextView.textColor = EdlineV5_Color.textFirstColor;
    _enterTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 输入实体卡卡号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _enterTextView.layer.masksToBounds = YES;
    _enterTextView.layer.cornerRadius = 4;
    _enterTextView.layer.borderWidth = 1;
    _enterTextView.layer.borderColor = EdlineV5_Color.enterLayerBorderColor.CGColor;
    _enterTextView.returnKeyType = UIReturnKeyDone;
    _enterTextView.delegate = self;
    [_topBackView addSubview:_enterTextView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;//_dataSourse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"ShitikaCell";
    ShitikaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ShitikaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 99;
}

- (void)usercardButton:(ShitikaCell *)cell {
    cell.userButton.selected = !cell.userButton.selected;
    if (cell.userButton.selected) {
        [cell.userButton setBackgroundColor:[UIColor whiteColor]];
    } else {
        [cell.userButton setBackgroundColor:EdlineV5_Color.buttonNormalColor];
    }
}

- (void)enterTextFieldDidChanged:(NSNotification *)notice {
//    UITextField *textfield = (UITextField *)notice.object;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
