//
//  CourseClassifyVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/7.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseClassifyVC.h"
#import "V5_Constant.h"
#import "CourseCommonCell.h"

@interface CourseClassifyVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *firstArray;
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) NSMutableArray *secondArray;
@property (strong, nonatomic) NSMutableArray *thirdArray;

@end

@implementation CourseClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _titleImage.hidden = YES;
    _firstArray = [NSMutableArray new];
    [_firstArray addObjectsFromArray:@[@{@"title":@"点播课程"},@{@"title":@"直播课程"},@{@"title":@"专辑课程"},@{@"title":@"面授课程"}]];
    _secondArray = [NSMutableArray new];
    _thirdArray = [NSMutableArray new];
    [self maketableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenCourseTypeVC:) name:@"hiddenCourseAll" object:nil];
}

- (void)maketableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _firstArray.count * 43.5)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(MainScreenWidth / 4.0, 0, MainScreenWidth * 3 / 4.0, _tableView.height)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _firstArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"SearchHistoryListCell";
    CourseCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[CourseCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setCourseCommonCellInfo:_firstArray[indexPath.row] searchKeyWord:_typeId];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _typeId = [NSString stringWithFormat:@"%@",[_firstArray[indexPath.row] objectForKey:@"title"]];
    [self makeScrollViewSubView:_firstArray];
    [UIView animateWithDuration:0.25 animations:^{
        _tableView.frame = CGRectMake(0, 0, MainScreenWidth / 4.0, _firstArray.count * 43.5);
        _mainScrollView.hidden = NO;
    }];
    [_tableView reloadData];
}

// MARK: - 布局右边分类视图
- (void)makeScrollViewSubView:(NSMutableArray *)subArray {
    if (_mainScrollView) {
        [_mainScrollView removeAllSubviews];
    }
    CGFloat hotYY = 0;
    CGFloat secondSpace = 6;
    for (int j = 0; j < subArray.count; j++) {
        UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, hotYY, MainScreenWidth, 0)];
        hotView.backgroundColor = [UIColor whiteColor];
        [_mainScrollView addSubview:hotView];
        
        NSString *secondTitle = @"热门搜索";
        CGFloat secondBtnWidth = [secondTitle sizeWithFont:SYSTEMFONT(15)].width + 4 + 7;
        UIButton *secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, secondBtnWidth, 60)];
        [secondBtn setImage:Image(@"erji_more") forState:0];
        [secondBtn setTitle:secondTitle forState:0];
        [secondBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        secondBtn.titleLabel.font = SYSTEMFONT(15);
        [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -secondBtn.currentImage.size.width, 0, secondBtn.currentImage.size.width)];
        [secondBtn setImageEdgeInsets:UIEdgeInsetsMake(0, secondBtnWidth-7, 0, -(secondBtnWidth - 7))];
        [hotView addSubview:secondBtn];
        
        if (subArray.count) {
            CGFloat topSpace = 20.0;
            CGFloat rightSpace = 15.0;
            CGFloat btnInSpace = 10.0;
            CGFloat XX = 15.0;
            CGFloat YY = 0.0 + secondBtn.bottom;
            CGFloat btnHeight = 32.0;
            for (int i = 0; i<subArray.count; i++) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, 0, btnHeight)];
                [btn setTitle:[subArray[i] objectForKey:@"title"] forState:0];
                btn.titleLabel.font = SYSTEMFONT(14);
                [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
                btn.backgroundColor = EdlineV5_Color.backColor;
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = btnHeight / 2.0;
                CGFloat btnWidth = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2;
                if ((btnWidth + XX) > (MainScreenWidth * 3/4.0 - 15)) {
                    XX = 15.0;
                    YY = YY + topSpace + btnHeight;
                }
                btn.frame = CGRectMake(XX, YY, btnWidth, btnHeight);
                XX = btn.right + rightSpace;
                if (i == subArray.count - 1) {
                    [hotView setHeight:btn.bottom];
                }
                [hotView addSubview:btn];
            }
        } else {
            [hotView setHeight:secondBtn.bottom];
        }
        hotYY = hotView.bottom;
        if (j == subArray.count - 1) {
            _mainScrollView.contentSize = CGSizeMake(0, hotYY);
        }
    }
}


- (void)hiddenCourseTypeVC:(NSNotification *)notice {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
