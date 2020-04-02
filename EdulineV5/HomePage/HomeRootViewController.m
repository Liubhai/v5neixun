//
//  HomeRootViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "HomeRootViewController.h"
#import "AliyunVodPlayerView.h"
#import "AliyunUtil.h"
#import "CourseMainViewController.h"
#import "AVC_VP_VideoPlayViewController.h"
#import "CourseSearchListVC.h"
#import "CourseSearchHistoryVC.h"

@interface HomeRootViewController ()<UITextFieldDelegate>

@property (nonatomic,strong, nullable)AliyunVodPlayerView *playerView;
@property (strong, nonatomic) UITextField *institutionSearch;

@end

@implementation HomeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"首页";
    [self makeTopSearch];
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(15, _titleLabel.top, MainScreenWidth - 30, 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索课程" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 15, 15)];
    [button setImage:Image(@"home_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CourseSearchHistoryVC *vc = [[CourseSearchHistoryVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    CourseSearchListVC *vc = [[CourseSearchListVC alloc] init];
//    vc.isSearch = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

@end
