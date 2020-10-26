//
//  LiveCourseListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/10/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LiveCourseListVC.h"
#import "LiveCourseListCell.h"
#import "V5_Constant.h"
#import "AppDelegate.h"
#import "Net_Path.h"

@interface LiveCourseListVC ()<UITableViewDelegate,UITableViewDataSource, LiveCourseListCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) UIButton *topBackViewBtn;
@property (strong, nonatomic) UILabel *themeLabel;

@end

@implementation LiveCourseListVC

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = [AppDelegate delegate];
    RootV5VC * nv = (RootV5VC *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray new];
    _titleImage.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self makeTopView];
    [self makeTableView];
    [self getLiveCourseList];
}

- (void)makeTopView {
    
    _topBackViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 272)];
    _topBackViewBtn.backgroundColor = [UIColor clearColor];
    [_topBackViewBtn addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topBackViewBtn];
    
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 272, MainScreenWidth, MainScreenHeight - 272)];
    _whiteView.layer.masksToBounds = YES;
    _whiteView.layer.cornerRadius = 17;
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_whiteView];
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 52)];
    _themeLabel.text = @"课程";
    _themeLabel.font = SYSTEMFONT(16);
    _themeLabel.centerX = MainScreenWidth / 2.0;
    _themeLabel.textAlignment = NSTextAlignmentCenter;
    _themeLabel.textColor = EdlineV5_Color.textFirstColor;
    [_whiteView addSubview:_themeLabel];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _whiteView.top + 52, MainScreenWidth, MainScreenHeight - (_whiteView.top + 52))];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"LiveCourseListCell";
    LiveCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LiveCourseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
}

- (void)jumpCourseDetailPage:(NSIndexPath *)cellIndexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(liveRoomJumpCourseDetailPage:)]) {
        [_delegate liveRoomJumpCourseDetailPage:_dataSource[cellIndexPath.row]];
    }
}

- (void)sureButtonClicked:(UIButton *)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)getLiveCourseList {
        
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
