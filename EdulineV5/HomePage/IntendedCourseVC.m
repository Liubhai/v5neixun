//
//  IntendedCourseVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/13.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "IntendedCourseVC.h"
#import "V5_Constant.h"
#import "CourseCommonCell.h"
#import "Net_Path.h"

@interface IntendedCourseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *firstArray;
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) NSMutableArray *secondArray;
@property (strong, nonatomic) NSMutableArray *thirdArray;

@end

@implementation IntendedCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
//    self.view.hidden = YES;
//    _titleImage.hidden = YES;
    _titleLabel.text = _isChange ? @"选择意向课程" : @"更改意向课程";
    _firstArray = [NSMutableArray new];
    _secondArray = [NSMutableArray new];
    _thirdArray = [NSMutableArray new];
    [self maketableView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenCourseTypeVC:) name:@"hiddenCourseAll" object:nil];
    [self getCourseClassifyList];
}

- (void)maketableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(MainScreenWidth / 4.0, MACRO_UI_UPHEIGHT, MainScreenWidth * 3 / 4.0, _tableView.height)];
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
        cell = [[CourseCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse showOneLine:NO];
    }
    [cell setCourseCommonCellInfo:_firstArray[indexPath.row] searchKeyWord:@"111"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    _typeId = [NSString stringWithFormat:@"%@",[_firstArray[indexPath.row] objectForKey:@"id"]];
    if (SWNOTEmptyArr([_firstArray[indexPath.row] objectForKey:@"child"])) {
        [self makeScrollViewSubView:_firstArray[indexPath.row]];
            [UIView animateWithDuration:0.25 animations:^{
                [_tableView setWidth:MainScreenWidth / 4.0];
                _mainScrollView.hidden = NO;
            }];
            [_tableView reloadData];
    } else {
//        if (_delegate && [_delegate respondsToSelector:@selector(chooseCourseClassify:)]) {
//            [_delegate chooseCourseClassify:_firstArray[indexPath.row]];
//        }
    }
}

// MARK: - 布局右边分类视图
- (void)makeScrollViewSubView:(NSDictionary *)selectedInfo {
    if (_mainScrollView) {
        [_mainScrollView removeAllSubviews];
    }
    CGFloat hotYY = 0;
    CGFloat secondSpace = 6;
    [_secondArray removeAllObjects];
    [_secondArray addObjectsFromArray:[NSArray arrayWithArray:[selectedInfo objectForKey:@"child"]]];
    for (int j = 0; j < _secondArray.count; j++) {
        UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, hotYY, MainScreenWidth, 0)];
        hotView.backgroundColor = [UIColor whiteColor];
        hotView.tag = 10 + j;
        [_mainScrollView addSubview:hotView];
        
        NSString *secondTitle = [NSString stringWithFormat:@"%@",[_secondArray[j] objectForKey:@"title"]];//@"热门搜索";
        CGFloat secondBtnWidth = [secondTitle sizeWithFont:SYSTEMFONT(15)].width + 4 + 7;
        UIButton *secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, secondBtnWidth, 60)];
        secondBtn.tag = 100 + j;
        [secondBtn setImage:Image(@"erji_more") forState:0];
        [secondBtn setTitle:secondTitle forState:0];
        [secondBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        secondBtn.titleLabel.font = SYSTEMFONT(15);
        [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -secondBtn.currentImage.size.width, 0, secondBtn.currentImage.size.width)];
        [secondBtn setImageEdgeInsets:UIEdgeInsetsMake(0, secondBtnWidth-7, 0, -(secondBtnWidth - 7))];
        [secondBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [hotView addSubview:secondBtn];
        [_thirdArray removeAllObjects];
        [_thirdArray addObjectsFromArray:[NSArray arrayWithArray:[_secondArray[j] objectForKey:@"child"]]];
        if (_thirdArray.count) {
            CGFloat topSpacee = 20.0;
            CGFloat rightSpace = 15.0;
            CGFloat btnInSpace = 10.0;
            CGFloat XX = 15.0;
            CGFloat YY = 0.0 + secondBtn.bottom;
            CGFloat btnHeight = 32.0;
            for (int i = 0; i<_thirdArray.count; i++) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, 0, btnHeight)];
                btn.tag = 200 + i;
                [btn addTarget:self action:@selector(thirdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:[NSString stringWithFormat:@"%@",[_thirdArray[i] objectForKey:@"title"]] forState:0];
                btn.titleLabel.font = SYSTEMFONT(14);
                [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
                btn.backgroundColor = EdlineV5_Color.backColor;
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = btnHeight / 2.0;
                CGFloat btnWidth = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2;
                if ((btnWidth + XX) > (MainScreenWidth * 3/4.0 - 15)) {
                    XX = 15.0;
                    YY = YY + topSpacee + btnHeight;
                }
                btn.frame = CGRectMake(XX, YY, btnWidth, btnHeight);
                XX = btn.right + rightSpace;
                if (i == _thirdArray.count - 1) {
                    [hotView setHeight:btn.bottom];
                }
                [hotView addSubview:btn];
            }
        } else {
            [hotView setHeight:secondBtn.bottom];
        }
        hotYY = hotView.bottom;
        if (j == _secondArray.count - 1) {
            _mainScrollView.contentSize = CGSizeMake(0, hotYY);
        }
    }
}

- (void)hiddenCourseTypeVC:(NSNotification *)notice {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)getCourseClassifyList {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseClassifyList] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]) {
            [_firstArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
            _tableView.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT);
            [_tableView reloadData];
//            self.view.hidden = NO;
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)secondBtnClick:(UIButton *)sender {
//    if (_delegate && [_delegate respondsToSelector:@selector(chooseCourseClassify:)]) {
//        [_delegate chooseCourseClassify:_secondArray[sender.tag - 100]];
//    }
}

- (void)thirdBtnClick:(UIButton *)sender {
//    if (_delegate && [_delegate respondsToSelector:@selector(chooseCourseClassify:)]) {
//        [_delegate chooseCourseClassify:_thirdArray[sender.tag - 200]];
//    }
}
@end
