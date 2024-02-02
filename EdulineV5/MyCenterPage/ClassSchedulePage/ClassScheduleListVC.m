//
//  ClassScheduleListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/12/19.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "ClassScheduleListVC.h"
#import "V5_Constant.h"
#import "WeekDayPublicView.h"
#import "ClassScheduleCell.h"
#import "Net_Path.h"
#import "V5_UserModel.h"
#import "WkWebViewController.h"

/** CC直播 */
#import "CCPlayerController.h"
#import "CCSDK/CCLiveUtil.h"
#import "CCSDK/RequestData.h"
#import "CCPlayBackController.h"
#import "CCSDK/RequestDataPlayBack.h"

/** CC云课堂 */
#import <HSRoomUI/HSRoomUI.h>
#import "CCScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CCLoginViewController.h"
#import "CCLoginDirectionViewController.h"
#import <CCClassRoomBasic/CCClassRoomBasic.h>
#import <HSRoomUI/HSRoomUI.h>
#import "CCTicketVoteView.h"
#import "CCTickeResultView.h"
#import "CCBrainView.h"
#import "CCClassCodeView.h"
#import "CCUrlLoginView.h"
#import "CCRoomDecModel.h"
#import "CCPlayViewController.h"
#import "CCPushViewController.h"
#import "YUNLanguage.h"

#import "AppDelegate.h"

#import "FSCalendar.h"

@interface ClassScheduleListVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, WeekDayPublicViewDelegate, WKUIDelegate,WKNavigationDelegate,RequestDataDelegate,RequestDataPlayBackDelegate, CCClassCodeViewDelegate,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,FSCalendarHeaderViewDelegate> {
    NSInteger page;
    
    // 筛选
    NSString *screenTitle;
    NSString *screenType;
    BOOL isStart;
}

@property (nonatomic, strong) FSCalendar *calendar;
@property (strong, nonatomic) UIButton *leftPageButton;
@property (strong, nonatomic) UIButton *rightPageButton;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *dataSectionSource;

@property (strong, nonatomic) WeekDayPublicView *weekview;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, copy) NSString *roomName;//房间名
@property (nonatomic,strong)RequestDataPlayBack         *requestDataPlayBack;
@property (nonatomic, strong) NSDictionary *ccInfoDict;

/** 云课堂 */
@property(nonatomic, strong)CCClassCodeView *classCodeView;
@property(nonatomic, strong)CCUrlLoginView *urlLoginView;
@property(nonatomic, strong)CCRoomDecModel *descModel;
@property(nonatomic, assign)BOOL isUrlLogin;
@property(nonatomic, strong) CCPlayViewController *playVC;
@property(nonatomic, strong) CCPushViewController *pushVC;
@property(nonatomic,strong)LoadingView          *loadingView;

@property(nonatomic,strong)HSLiveViewController *liveVC;
@property (assign, nonatomic) CCRole role;//角色
@property (assign, nonatomic) NSInteger ccClassRoomrole;//角色
@property(nonatomic, assign)BOOL needPassword;
@property(nonatomic, copy)NSString *sessionID;
@property(nonatomic, strong)id loginInfo;
@property(nonatomic, assign)BOOL isLandSpace;
@property(nonatomic, assign)BOOL isLoading;

@end

@implementation ClassScheduleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = EdlineV5_Color.backColor;
    self.titleLabel.text = @"直播课表";
    
//    _rightButton.hidden = NO;
//    [_rightButton setImage:nil forState:0];
//    [_rightButton setTitle:@"今天" forState:0];
//    [_rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    
    _ccInfoDict = [[NSDictionary alloc] init];
    
//    [self makeWeekView];
    
    _dataSource = [NSMutableArray new];
    _dataSectionSource = [NSMutableArray new];
    page = 1;
    
    [self getClassSectionList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ScanSuccess:) name:@"ScanSuccess" object:nil];
}

- (void)makeWeekView {
    _weekview = [[WeekDayPublicView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 78)];
    _weekview.delegate = self;
    [self.view addSubview:_weekview];
}

- (void)makeCalendarView {
    _calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 280)];
    _calendar.calendarHeaderView.delegate = self;
    _calendar.delegate = self;
    _calendar.dataSource = self;
    [self.view addSubview:_calendar];
    [_calendar selectDate:[NSDate date]];
    _calendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
    FSCalendarAppearance *appearance = self.calendar.appearance;
    appearance.hasClassScheduleArray = [NSMutableArray arrayWithArray:_dataSectionSource];
    appearance.eventDefaultColor = EdlineV5_Color.themeColor;
    appearance.eventSelectionColor = EdlineV5_Color.themeColor;
    appearance.caseOptions =  FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    appearance.headerDateFormat = @"yyyy年MM月";
    appearance.headerMinimumDissolvedAlpha = 0;
    appearance.headerTitleColor = HEXCOLOR(0x303133);
    appearance.headerTitleFont = DWBoldFont(18);
    appearance.headerTitleAlignment = NSTextAlignmentLeft;
    appearance.headerTitleOffset = CGPointMake(47, 0);
    appearance.weekdayTextColor = RGBA(183, 186, 193);
    appearance.weekdayFont = [UIFont systemFontOfSize:12];
    appearance.titleDefaultColor = UIColor.blackColor;
    appearance.titleFont = DWBoldFont(15);
    appearance.selectionColor = EdlineV5_Color.themeColor;//rgba(214, 0, 15, 1);
    appearance.titleTodayColor = rgba(214, 0, 15, 1);
    appearance.todayColor = nil;
    appearance.titleTodayColor = appearance.headerTitleColor;
    
    
    _rightPageButton = [[UIButton alloc] initWithFrame:CGRectMake(145, _calendar.top + 3.87, 34.8, 34.8)];
    [_rightPageButton setImage:Image(@"course_right_icon") forState:0];
    [self.view addSubview:_rightPageButton];
    [_rightPageButton addTarget:self action:@selector(pageRiliButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _leftPageButton = [[UIButton alloc] initWithFrame:CGRectMake(15, _calendar.top + 3.87, 34.8, 34.8)];
    [_leftPageButton setImage:Image(@"course_left_icon") forState:0];
    [self.view addSubview:_leftPageButton];
    [_leftPageButton addTarget:self action:@selector(pageRiliButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pageRiliButtonClick:(UIButton *)sender {
    if (_calendar) {
        if (sender == _leftPageButton) {
            [_calendar pageButtonClick:NO];
        } else {
            [_calendar pageButtonClick:YES];
        }
    }
}

- (void)makeTopView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, _calendar.bottom, MainScreenWidth, 48)];
    _topView.backgroundColor = EdlineV5_Color.backColor;
    [self.view addSubview:_topView];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, _topView.height)];
    _countLabel.textColor = EdlineV5_Color.textThirdColor;
    _countLabel.font = SYSTEMFONT(13);
    [_topView addSubview:_countLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_topView.width - 15 - 150, 0, 150, _topView.height)];
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    _timeLabel.text = currentDay;
    
    [_topView addSubview:_timeLabel];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topView.bottom, MainScreenWidth, MainScreenHeight - _topView.bottom)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = EdlineV5_Color.backColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getOrderList)];
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreOrderList)];
//    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
    [EdulineV5_Tool adapterOfIOS11With:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"MyCertificateListCell";
    ClassScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[ClassScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setClassScheduleCellInfo:_dataSource[indexPath.row] isTeacher:_isTeacher];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isTeacher) {
        return 120 + 12 - 32 + 5;
    }
    return 120 + 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isTeacher) {
        return;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:_dataSource[indexPath.row]];
    NSString *statusString = [NSString stringWithFormat:@"%@",dict[@"live_status"]];
    NSString *liveType = [NSString stringWithFormat:@"%@",dict[@"sec_live"][@"live_type"]];
    NSDictionary *sec_live_dict = [NSDictionary dictionaryWithDictionary:dict[@"sec_live"]];
    //    【957：未开始；999：直播中；992：已结束；】
    if ([statusString isEqualToString:@"957"]) {
        [self showHudInView:self.view showHint:@"直播未开始"];
    } else if ([statusString isEqualToString:@"999"]) {
        if (!SWNOTEmptyDictionary(sec_live_dict)) {
            [self showHudInView:self.view showHint:@"直播未开始"];
            return;
        }
        if ([liveType isEqualToString:@"2"]) {
            [self integrationSDK:dict];
        } else if ([liveType isEqualToString:@"3"]) {
            [self parseCodeStr:@"" ccinfo:dict];
        } else {
        }
    } else if ([statusString isEqualToString:@"992"]) {
        if (!SWNOTEmptyDictionary(sec_live_dict)) {
            [self showHudInView:self.view showHint:@"直播无回放"];
            return;
        }
        if ([liveType isEqualToString:@"2"]) {
            [self integrationPlayBackSDK:dict];
        } else if ([liveType isEqualToString:@"3"]) {
            [self ccClassRoomPlayBack:dict];
        } else {
        }
    }
}

// MARK: - fs日历代理
- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date{
    NSDateFormatter *ndfdefault = [[NSDateFormatter alloc] init];
    [ndfdefault setDateFormat:@"yyyy-MM-dd"];
    if ([[ndfdefault stringFromDate:date] isEqualToString:[ndfdefault stringFromDate:[NSDate date]]]) {
        return @"今";
    } else {
        NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
        [ndf setDateFormat:@"d"];
        return [ndf stringFromDate:date];
    }
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _timeLabel.text = [dateFormatter stringFromDate:date];//选中年月日
    [self getOrderList];
}

- (void)backToToday {
    [_calendar selectDate:[NSDate date]];
}

- (void)getClassSectionList {
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    NSDate * date = [NSDate date];//当前时间
    NSDate *previousDay = [NSDate dateWithTimeInterval:-24*60*60*365 sinceDate:date];//前i天
    NSDate *lastDay = [NSDate dateWithTimeInterval:+24*60*60*365 sinceDate:date];//后i天
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *thePreviousDay = [dateFormatter stringFromDate:previousDay];
    NSString *theLastDay = [dateFormatter stringFromDate:lastDay];
    
    [param setObject:thePreviousDay forKey:@"startdate"];
    [param setObject:theLastDay forKey:@"enddate"];
    // teacher、student
    [param setObject:_isTeacher ? @"teacher" : @"student" forKey:@"identity"];

    [Net_API requestGETSuperAPIWithURLStr:[Net_Path classSrctionListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSectionSource removeAllObjects];
                NSMutableArray *dateSection = [[NSMutableArray alloc] init];
                [dateSection addObjectsFromArray:[responseObject objectForKey:@"data"]];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                for (NSDictionary *dict in dateSection) {
                    NSString *dateString = [NSString stringWithFormat:@"%@",dict[@"timestamp"]];
                    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:dateString.integerValue];
                    NSString *theDay = [dateFormatter stringFromDate:nowDate];
                    [_dataSectionSource addObject:theDay];
                }
                [self makeCalendarView];
                
                [self makeTopView];
                
                [self makeTableView];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getOrderList {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_timeLabel.text)) {
        [param setObject:_timeLabel.text forKey:@"date"];
    }
    
    [param setObject:_isTeacher ? @"teacher" : @"student" forKey:@"identity"];
    
    [_tableView tableViewDisplayWitMsg:@"今日无课~" img:@"placeholder_empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_tableView.height];

    [Net_API requestGETSuperAPIWithURLStr:[Net_Path classScheduleListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
            }
        }
//        if (_dataSource.count<10) {
//            _tableView.mj_footer.hidden = YES;
//        } else {
//            _tableView.mj_footer.hidden = NO;
//        }
        NSString *countString = [NSString stringWithFormat:@"共%@节课",@(_dataSource.count)];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:countString];
        
        [att addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:NSMakeRange(1, countString.length - 2 - 1)];
        _countLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:att];
        
        [_tableView tableViewDisplayWitMsg:@"今日无课~" img:@"placeholder_empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_tableView.height];
        [_tableView reloadData];
    } enError:^(NSError * _Nonnull error) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }];
}

- (void)getMoreOrderList {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (SWNOTEmptyStr(_timeLabel.text)) {
        [param setObject:_timeLabel.text forKey:@"date"];
    }
    [param setObject:_isTeacher ? @"teacher" : @"student" forKey:@"identity"];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path classScheduleListNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                NSArray *pass = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
                [_dataSource addObjectsFromArray:pass];
                if (pass.count<10) {
                    _tableView.mj_footer.hidden = YES;
                } else {
                    _tableView.mj_footer.hidden = NO;
                }
            }
        }
        [_tableView reloadData];
    } enError:^(NSError * _Nonnull error) {
        page--;
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)rightButtonClick:(id)sender {
//    [_weekview fastReturnToToday];
    [_calendar selectDate:[NSDate date]];
}

- (void)selectedDay:(NSArray *)yymmddwwArray {
    if (SWNOTEmptyArr(yymmddwwArray)) {
        NSString *yyString = [NSString stringWithFormat:@"%@",yymmddwwArray[1]];
        if (yyString.length<2) {
            yyString = [NSString stringWithFormat:@"0%@",yymmddwwArray[1]];
        }
        NSString *ddString = [NSString stringWithFormat:@"%@",yymmddwwArray[2]];
        if (ddString.length<2) {
            ddString = [NSString stringWithFormat:@"0%@",yymmddwwArray[2]];
        }
        _timeLabel.text = [NSString stringWithFormat:@"%@-%@-%@",yymmddwwArray[0],yyString,ddString];
        [_tableView.mj_header beginRefreshing];
    }
}

// MARK: - CC直播
/**
 *    @brief    配置SDK
 */
-(void)integrationSDK:(NSDictionary *)ccInfo{
    
    _ccInfoDict = [NSDictionary dictionaryWithDictionary:ccInfo];
    
    PlayParameter *parameter = [[PlayParameter alloc] init];
    parameter.userId = [NSString stringWithFormat:@"%@",ccInfo[@"sec_live"][@"cc_userid"]];
    parameter.roomId = [NSString stringWithFormat:@"%@",ccInfo[@"sec_live"][@"cc_room_id"]];
    parameter.viewerName = [V5_UserModel uname];
    parameter.token = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    parameter.security = YES;//是否使用https (已弃用)
    parameter.viewerCustomua = @"";//自定义参数
    parameter.tpl = 20;
    RequestData *requestData = [[RequestData alloc] initLoginWithParameter:parameter];
    requestData.delegate = self;
}

#pragma mark- 必须实现的代理方法RequestDataDelegate
//@optional
/**
 *    @brief    请求成功
 */
-(void)loginSucceedPlay {
    
    NSString *userid = [NSString stringWithFormat:@"%@",_ccInfoDict[@"sec_live"][@"cc_userid"]];
    NSString *roomid = [NSString stringWithFormat:@"%@",_ccInfoDict[@"sec_live"][@"cc_room_id"]];
    
    SaveToUserDefaults(WATCH_USERID,userid);
    SaveToUserDefaults(WATCH_ROOMID,roomid);
    SaveToUserDefaults(WATCH_USERNAME,[V5_UserModel uname]);
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    SaveToUserDefaults(WATCH_PASSWORD,ak);
    
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    CCPlayerController *playForPCVC = [[CCPlayerController alloc] initWithRoomName:self.roomName];
    playForPCVC.modalPresentationStyle = 0;
    [self presentViewController:playForPCVC animated:YES completion:^{
    }];
}
/**
 *    @brief    登录请求失败
 */
-(void)loginFailed:(NSError *)error reason:(NSString *)reason {
    NSString *message = nil;
    if (reason == nil) {
        message = [error localizedDescription];
    } else {
        message = reason;
    }
    
    NSLog(@"CC直播登陆请求失败原因 = %@",message);
}
/**
 *    @brief  获取房间信息
 *    房间名称：dic[@"name"];
 */
-(void)roomInfo:(NSDictionary *)dic {
    _roomName = dic[@"name"];
}

// MARK: - CC直播回放

/**
 配置SDK
 */
-(void)integrationPlayBackSDK:(NSDictionary *)ccInfo{
    
    _ccInfoDict = [NSDictionary dictionaryWithDictionary:ccInfo];
    
    NSString *userid = [NSString stringWithFormat:@"%@",ccInfo[@"sec_live"][@"cc_userid"]];
    NSString *roomid = [NSString stringWithFormat:@"%@",ccInfo[@"sec_live"][@"cc_room_id"]];
    NSString *replay_id = [NSString stringWithFormat:@"%@",ccInfo[@"sec_live"][@"cc_replay_id"]];
    if (!SWNOTEmptyStr(replay_id)) {
        [self showHudInView:self.view showHint:@"直播无回放"];
        return;
    }
    PlayParameter *parameter = [[PlayParameter alloc] init];
    parameter.userId = userid;
    parameter.roomId = roomid;
    parameter.recordId = replay_id;
    parameter.viewerName = [V5_UserModel uname];
    parameter.token = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    parameter.security = NO;
    
    self.requestDataPlayBack = [[RequestDataPlayBack alloc] initLoginWithParameter:parameter];
    self.requestDataPlayBack.delegate = self;
}

#pragma mark- 必须实现的代理方法RequestDataPlayBackDelegate
/**
 *    @brief    请求成功
 */
-(void)loginSucceedPlayBack {
    
    NSString *userid = [NSString stringWithFormat:@"%@",_ccInfoDict[@"sec_live"][@"cc_userid"]];
    NSString *roomid = [NSString stringWithFormat:@"%@",_ccInfoDict[@"sec_live"][@"cc_room_id"]];
    NSString *replay_id = [NSString stringWithFormat:@"%@",_ccInfoDict[@"sec_live"][@"cc_replay_id"]];
    
    SaveToUserDefaults(PLAYBACK_USERID,userid);
    SaveToUserDefaults(PLAYBACK_ROOMID,roomid);
    SaveToUserDefaults(PLAYBACK_RECORDID,replay_id);
    SaveToUserDefaults(PLAYBACK_USERNAME,[V5_UserModel uname]);
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    SaveToUserDefaults(PLAYBACK_PASSWORD,ak);
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    CCPlayBackController *playBackVC = [[CCPlayBackController alloc] init];
    playBackVC.modalPresentationStyle = 0;
    [self presentViewController:playBackVC animated:YES completion:^{
        _requestDataPlayBack = nil;
    }];
}

// MARK: - CC云课堂

// MARK: - 课堂链接方式
-(void)parseCodeStr:(NSString *)result ccinfo:(NSDictionary *)ccInfo {
    
    NSString *userid = [NSString stringWithFormat:@"%@",ccInfo[@"sec_live"][@"cc_userid"]];
    NSString *roomid = [NSString stringWithFormat:@"%@",ccInfo[@"sec_live"][@"cc_room_id"]];
    NSString *replay_id = [NSString stringWithFormat:@"%@",ccInfo[@"sec_live"][@"cc_replay_id"]];
    
    /**
     讲师：http://cloudclass.csslcloud.net/index/presenter/?roomid=856D003D0C44B80D9C33DC5901307461&userid=56761A7379431808
     助教：http://cloudclass.csslcloud.net/index/assistant/?roomid=856D003D0C44B80D9C33DC5901307461&userid=56761A7379431808
     学员：http://cloudclass.csslcloud.net/index/talker/?roomid=856D003D0C44B80D9C33DC5901307461&userid=56761A7379431808
     隐身者：http://cloudclass.csslcloud.net/index/inspector/?roomid=856D003D0C44B80D9C33DC5901307461&userid=56761A7379431808
     旁听:https://view.csslcloud.net/api/view/index?roomid=856D003D0C44B80D9C33DC5901307461&userid=56761A7379431808
     */
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    result = [NSString stringWithFormat:@"https://class.csslcloud.net/index/talker/?roomid=%@&userid=%@&username=%@&password=%@&autoLogin=true&template=32",roomid,userid,[V5_UserModel uname],ak];
//    if ([_currentCourseFinalModel.model.section_live.identify isEqualToString:@"presenter"]) {
//        result = [NSString stringWithFormat:@"https://class.csslcloud.net/index/presenter/?roomid=%@&userid=%@&username=%@&password=%@&autoLogin=true",_currentCourseFinalModel.model.section_live.cc_room_id,_currentCourseFinalModel.model.section_live.cc_userid,[V5_UserModel uname],ak];
//    } else if ([_currentCourseFinalModel.model.section_live.identify isEqualToString:@"assistant"]) {
//        result = [NSString stringWithFormat:@"https://class.csslcloud.net/index/assistant/?roomid=%@&userid=%@&username=%@&password=%@&autoLogin=true",_currentCourseFinalModel.model.section_live.cc_room_id,_currentCourseFinalModel.model.section_live.cc_userid,[V5_UserModel uname],ak];
//    } else if ([_currentCourseFinalModel.model.section_live.identify isEqualToString:@"talker"]) {
//        result = [NSString stringWithFormat:@"https://class.csslcloud.net/index/talker/?roomid=%@&userid=%@&username=%@&password=%@&autoLogin=true",_currentCourseFinalModel.model.section_live.cc_room_id,_currentCourseFinalModel.model.section_live.cc_userid,[V5_UserModel uname],ak];
//    } else if ([_currentCourseFinalModel.model.section_live.identify isEqualToString:@"inspector"]) {
//        result = [NSString stringWithFormat:@"https://class.csslcloud.net/index/inspector/?roomid=%@&userid=%@&username=%@&password=%@&autoLogin=true",_currentCourseFinalModel.model.section_live.cc_room_id,_currentCourseFinalModel.model.section_live.cc_userid,[V5_UserModel uname],ak];
//    } else if ([_currentCourseFinalModel.model.section_live.identify isEqualToString:@"view"]) {
//        result = [NSString stringWithFormat:@"https://view.csslcloud.net/api/view/index?roomid=%@&userid=%@&username=%@&password=%@&autoLogin=true",_currentCourseFinalModel.model.section_live.cc_room_id,_currentCourseFinalModel.model.section_live.cc_userid,[V5_UserModel uname],ak];
//    }
    
    NSRange rangeRoomId = [result rangeOfString:@"roomid="];
    NSRange rangeUserId = [result rangeOfString:@"userid="];
    WS(ws)
    if (!StrNotEmpty(result) || rangeRoomId.location == NSNotFound || rangeUserId.location == NSNotFound)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:HDClassLocalizeString(@"解析错误错误") message:HDClassLocalizeString(@"课堂链接错误") preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:HDClassLocalizeString(@"好") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:okAction];
        [ws presentViewController:alertController animated:YES completion:nil];
    } else {
        NSString *resultNew = [result stringByReplacingOccurrencesOfString:@"#" withString:@"index"];

        NSDictionary *roomInfo = [HDSTool parseURLParam:resultNew];
        NSString *roomId = roomInfo[@"roomid"];
        NSString *userId = roomInfo[@"userid"];
        NSInteger mode = [roomInfo[@"template"]integerValue];
        
        NSInteger autoLogin = [roomInfo[@"autoLogin"]boolValue];
        NSString *password = roomInfo[@"password"];
        NSString *username = roomInfo[@"username"];

        HDSTool *tool = [HDSTool sharedTool];
        tool.rid = roomId;
        tool.uid = userId;
        tool.roomMode = mode;
        tool.autoLogin = autoLogin;
        tool.password = password;
        tool.username = username;

        if (!roomId || !userId) {
            return;
        }
        resultNew = [HDSTool getUrlStringWithString:resultNew];
        NSURL *url = [NSURL URLWithString:resultNew];
        NSString *path = [[url path]lastPathComponent];
        NSString *role = path;

        SaveToUserDefaults(LIVE_USERID,userId);
        SaveToUserDefaults(LIVE_ROOMID,roomId);

        NSString *urlDealed = [[CCScanViewController new]dealURLClassToCCAPI:result];
        [[CCStreamerBasic sharedStreamer]setServerDomain:urlDealed area:nil];
        
        __weak typeof(self) weakSelf = self;
        userId = [userId stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [self getRoomDescWithRoomID:roomId classNo:nil completion:^(BOOL result, NSError *error, id info) {
            CCRoomDecModel *model = (CCRoomDecModel *)info;
            if (result)
            {
                if ([model.result isEqualToString:@"OK"])
                {
                    HDSTool *tool = [HDSTool sharedTool];
                    tool.roomSubMode = model.data.layout_mode;

                    SaveToUserDefaults(LIVE_ROOMNAME, model.data.name);
                    SaveToUserDefaults(LIVE_ROOMDESC, model.data.desc);
                    NSInteger authKey = [CCRoomDecModel authTypeKeyForRole:role model:model.data];
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[@"userID"] = userId;
                    userInfo[@"roomID"] = roomId;
                    userInfo[@"role"] = role;
                    userInfo[@"authtype"] = @(authKey);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScanSuccess" object:nil userInfo:userInfo];
                }
                else
                {
                    [CCTool showMessage:model.errorMsg];
                }
            }
            else
            {
            }
        }];
    }
}

- (void)ScanSuccess:(NSNotification *)noti
{
    NSString *userId = noti.userInfo[@"userID"];
    NSString *roomId = noti.userInfo[@"roomID"];
    NSString *role = noti.userInfo[@"role"];
    NSInteger authtype = [noti.userInfo[@"authtype"] integerValue];
    BOOL needPassword = authtype == 2 ? NO : YES;
    BOOL liveVCNeedPassword;
    NSInteger role1 = [CCTool roleFromRoleString:role];
    self.ccClassRoomrole = role1;
    self.role = role1;
    
    if (role1 == CCRole_Teacher || role1 == CCRole_Assistant)
    {
        liveVCNeedPassword = YES;
    }
    else
    {
        if (role1 == CCRole_Teacher)
        {
            liveVCNeedPassword = YES;
        }
        else
        {
            liveVCNeedPassword = needPassword;
        }
    }
    
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    SaveToUserDefaults(SET_USER_NAME, [V5_UserModel uname]);
    SaveToUserDefaults(SET_USER_PWD, ak);//@"671309"
    SaveToUserDefaults(LIVE_USERID, userId);
    SaveToUserDefaults(LIVE_ROOMID, roomId);
    
    SaveToUserDefaults(LIVE_ROLE, @(role1));

    NSString *isp = GetFromUserDefaults(SERVER_AREA_NAME);

    NSString *uname = [V5_UserModel uname];
    
    NSString *upwd = ak;//@"671309"//(liveVCNeedPassword ? ak : @"");;
    
    NSString *roleString = [NSString stringWithFormat:@"%@", @(self.role)];

    __weak typeof(self) weakSelf = self;
    __block NSString *sessionStr = nil;
    
    NSDictionary *authInfo = @{
        @"roomid": roomId,    //房间id
        @"userid": userId,    //账户id
        @"role": roleString,       //角色    //'0': 教师 '1': 互动者 '2': 旁听者
        @"password": upwd,         //密码。
        @"name": uname,            //昵称/用户名
        @"custominfo":@"ios"       //自定义字段
    };
    
//    [[CCStreamerBasic sharedStreamer] authWithRoomId:roomId accountId:userId role:self.ccClassRoomrole password:upwd nickName:uname completion:^(BOOL result, NSError *error, id info) {
    [[CCStreamerBasic sharedStreamer] authWithInfo:authInfo completion:^(BOOL result, NSError *error, id info) {
        if (!result)
        {
            [CCTool showMessageError:error];
            return;
        }
        NSDictionary *dic = (NSDictionary *)info;
        NSString *res = dic[@"result"];
        NSString *errmsg = @"";
        if ([res isEqualToString:@"FAIL"])
        {
            errmsg  = dic[@"errorMsg"];
            [CCTool showMessage:errmsg];
            return ;
        }
        NSDictionary *dataDic = dic[@"data"];
        sessionStr = [dataDic objectForKey:@"sessionid"];
        SaveToUserDefaults(Login_UID, [dataDic objectForKey:@"userid"]);
        {
            weakSelf.sessionID = sessionStr;
            CCEncodeConfig *config = [[CCEncodeConfig alloc] init];
            config.reslution = CCResolution_240;
            
            NSString *accountid = userId;
            NSString *sessionid = self.sessionID;
            
            [weakSelf initVC];
            
            HDSTool *tool = [HDSTool sharedTool];
            if (tool.roomMode == 32) {
//                [weakSelf.loadingView removeFromSuperview];

                [weakSelf streamLoginSuccess:@{}];
                return;
            }

            [[CCStreamerBasic sharedStreamer] joinWithAccountID:accountid sessionID:sessionid roomId:roomId config:config areaCode:isp events:@[] updateRtmpLayout:NO completion:^(BOOL result, NSError *error, id info) {
                BOOL modeGravity = [HDSDocManager sharedDoc].isPreviewGravityFollow;
                [[CCStreamerBasic sharedStreamer]setPreviewGravityFollow:modeGravity];

                HDSTool *tool = [HDSTool sharedTool];
                if (tool.roomMode != 32) {
                    [tool updateLocalPushResolution];
                    [tool resetSDKPushResolution];
                }

                if (result) {
                    weakSelf.loginInfo = info;
                    NSLog(HDClassLocalizeString(@"登录获取的info：%@") ,info);
                    if ([NSThread isMainThread]) {
                        if ([[weakSelf.navigationController.viewControllers lastObject] isKindOfClass:weakSelf.class]) {

                            [weakSelf streamLoginSuccess:weakSelf.loginInfo];
                        }
                    }else {
                        main_async_safe(^{
                            if ([[weakSelf.navigationController.viewControllers lastObject] isKindOfClass:weakSelf.class]) {

                                [weakSelf streamLoginSuccess:weakSelf.loginInfo];
                            }
                        });
                    }

                }else{
                    if (error.code == 22002) {

                        int version_check = [info[@"version_check"] intValue];
                        if (version_check == 1) {
                            return;
                        }
                    }
                }
            }];
        }
    }];
    
}

// MARK: - 获取直播间房间信息
- (void)getRoomIdAndDesc:(NSString *)classNo {
    // 100621591
    classNo = @"100621591";
    if (classNo.length == 0) {
        [CCTool showMessage:@"参课码错误"];
        return;
    }
    if (classNo.length != 9) {
        [CCTool showMessage:@"参课码错误"];
        return;
    }
    WeakSelf(weakSelf);
    [self getRoomDescWithRoomID:nil classNo:classNo completion:^(BOOL result, NSError *error, id info) {
        weakSelf.descModel = (CCRoomDecModel *)info;
        if (result)
        {
            if ([weakSelf.descModel.result isEqualToString:@"OK"])
            {
                weakSelf.descModel.data.classNo = classNo;
                HDSTool *tool = [HDSTool sharedTool];
                tool.roomSubMode = weakSelf.descModel.data.layout_mode;
                tool.rid = weakSelf.descModel.data.live_roomid;
                tool.uid = weakSelf.descModel.data.userid;
                tool.roomMode = weakSelf.descModel.data.templatetype;
                if (tool.roomMode != 32) {
                    [tool updateLocalPushResolution];
                    [tool resetSDKPushResolution];
                }
                if ([classNo hasSuffix:@"4"]) {
                    if (tool.roomMode != 32) {
                        [CCTool showMessage:HDClassLocalizeString(@"暂不支持助教") ];
                        return;
                    } else {
                        if (tool.roomSubMode > 0) {
                            [CCTool showMessage:HDClassLocalizeString(@"暂不支持助教") ];
                            return;
                        }
                    }
                }

                SaveToUserDefaults(LIVE_ROOMNAME, weakSelf.descModel.data.name);
                SaveToUserDefaults(LIVE_ROOMDESC, weakSelf.descModel.data.desc);
                //todo...
                // 进入云课堂
                [self loginCCClassRoomActionJoin];
            }
            else
            {
                [CCTool showMessage:weakSelf.descModel.errorMsg];
            }
        }
        else
        {
            NSString *errMessage = error.domain;
            if (!errMessage) {
                errMessage = HDClassLocalizeString(@"网络不稳定,请重试!") ;
            }
            NSInteger errCode = error.code;
            
            NSString *message = [NSString stringWithFormat:@"%@<%d>",errMessage,errCode];
            [HDSTool showAlertTitle:@"" msg:message completion:^(BOOL cancelled, NSInteger buttonIndex) {
                
            }];
        }
    }];
}

// MARK: - 获取房间信息回调
- (void)getRoomDescWithRoomID:(NSString *)roomId classNo:(NSString *)classNo completion:(CCComletionBlock)completion {
    [CCRoomDecModel getRoomDescWithRoomID:roomId classCode:classNo completion:^(BOOL result, NSError *error, id info) {
        completion(result, error, info);
    }];
}

-(void)loginCCClassRoomActionJoin
{
    NSString *classCodeString = @"100621591";
    if ([classCodeString hasSuffix:@"0"]) {///老师 助教
        ///需要密码
        self.role = CCRole_Teacher;
        self.needPassword = YES;
    }else if ([classCodeString hasSuffix:@"1"]) {///学生
        self.role = CCRole_Student;
        self.needPassword = self.descModel.data.talker_authtype == 2 ? NO : YES;
    }else if ([classCodeString hasSuffix:@"7"]) {///麦下观众
        self.role = CCRole_au_low;
        self.needPassword = self.descModel.data.talker_authtype == 2 ? NO : YES;
    }else if ([classCodeString hasSuffix:@"3"]) {///隐身者
        if (self.descModel.data.templatetype == 32) {
            [CCTool showMessage:HDClassLocalizeString(@"暂不支持隐身者") ];
            return;
        }
        self.role = CCRole_Inspector;
        self.needPassword = self.descModel.data.inspector_authtype == 2 ? NO : YES;
    } else if ([self.classCodeView.classCodeTF.text hasSuffix:@"4"]) {
        self.role = CCRole_Assistant;
        self.needPassword = YES;
    }
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    SaveToUserDefaults(SET_USER_NAME, [V5_UserModel uname]);
    SaveToUserDefaults(SET_USER_PWD, ak);//@"671309"
    SaveToUserDefaults(LIVE_USERID, self.descModel.data.userid);
    SaveToUserDefaults(LIVE_ROOMID, self.descModel.data.live_roomid);

    NSString *isp = GetFromUserDefaults(SERVER_AREA_NAME);

    NSString *uname = [V5_UserModel uname];


    NSString *upwd = ak;//@"671309";

    __weak typeof(self) weakSelf = self;
    __block NSString *sessionStr = nil;
    [[CCStreamerBasic sharedStreamer] authWithRoomId:self.descModel.data.live_roomid accountId:self.descModel.data.userid role:self.role password:upwd nickName:uname completion:^(BOOL result, NSError *error, id info) {
        if (!result)
        {
            [CCTool showMessageError:error];
            return;
        }
        NSDictionary *dic = (NSDictionary *)info;
        NSString *res = dic[@"result"];
        NSString *errmsg = @"";
        if ([res isEqualToString:@"FAIL"])
        {
            errmsg  = dic[@"errorMsg"];
            [CCTool showMessage:errmsg];
            return ;
        }
        NSDictionary *dataDic = dic[@"data"];
        sessionStr = [dataDic objectForKey:@"sessionid"];
        SaveToUserDefaults(Login_UID, [dataDic objectForKey:@"userid"]);
        {
            weakSelf.sessionID = sessionStr;
            CCEncodeConfig *config = [[CCEncodeConfig alloc] init];
            config.reslution = CCResolution_240;
            [weakSelf initVC];

            NSString *accountid = self.descModel.data.userid;
            NSString *sessionid = self.sessionID;
            [[CCStreamerBasic sharedStreamer] joinWithAccountID:accountid sessionID:sessionid roomId:weakSelf.descModel.data.live_roomid config:config areaCode:isp events:@[] updateRtmpLayout:NO completion:^(BOOL result, NSError *error, id info) {
                BOOL modeGravity = [HDSDocManager sharedDoc].isPreviewGravityFollow;
                [[CCStreamerBasic sharedStreamer]setPreviewGravityFollow:modeGravity];

                HDSTool *tool = [HDSTool sharedTool];
                if (tool.roomMode != 32) {
                    [tool updateLocalPushResolution];
                    [tool resetSDKPushResolution];
                }

                if (result) {
                    weakSelf.loginInfo = info;
                    NSLog(HDClassLocalizeString(@"登录获取的info：%@") ,info);
                    if ([NSThread isMainThread]) {
                        if ([[weakSelf.navigationController.viewControllers lastObject] isKindOfClass:weakSelf.class]) {

                            [weakSelf streamLoginSuccess:weakSelf.loginInfo];
                        }
                    }else {
                        main_async_safe(^{
                            if ([[weakSelf.navigationController.viewControllers lastObject] isKindOfClass:weakSelf.class]) {

                                [weakSelf streamLoginSuccess:weakSelf.loginInfo];
                            }
                        });
                    }

                }else{
                    if (error.code == 22002) {

                        int version_check = [info[@"version_check"] intValue];
                        if (version_check == 1) {
                            return;
                        }
                    }
                }
            }];
        }
    }];
}

// MARK: - 初始化云课堂控制器
- (void)initVC {
    HDSTool *tool = [HDSTool sharedTool];
    if (tool.roomMode == 32) {
        self.liveVC = [HSLiveViewController sharedLiveRoom];
        if (tool.roomSubMode == 1) {
//            self.liveVC = [HSLiveViewController createLiveController:HSRoomType_1V1_16_9];
            [self.liveVC setLiveRoomType:HSRoomType_1V1_16_9];
        }else if (tool.roomSubMode == 2) {
//            self.liveVC = [HSLiveViewController createLiveController:HSRoomType_1V1_4_3];
            [self.liveVC setLiveRoomType:HSRoomType_1V1_4_3];
        } else {
//            self.liveVC = [HSLiveViewController createLiveController:HSRoomType_saas];
            [self.liveVC setLiveRoomType:HSRoomType_saas];
        }
//        self.liveVC.allowTakePhotoInLibrary = YES;
//        
//        HSRoomConfig *roomInfo = [[HSRoomConfig alloc]init];
//        roomInfo.bleLicense = @"PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxsaWNlbnNlIHZlcnNpb249InYxLjAiIGlkPSI2MDU5YTE3Y2I1YmE3ZDhmMjExZmUyODAiPgogICAgPG93bmVyPuWIm+ebm+inhuiBlOaVsOeggeenkeaKgO+8iOWMl+S6rO+8ieaciemZkOWFrOWPuDwvb3duZXI+CiAgICA8dXNlcj5jaGVuZnk8L3VzZXI+CiAgICA8ZW1haWw+Y2hlbmZ5QGJva2VjYy5jb208L2VtYWlsPgogICAgPGJ1bmRsZUlkPmNvbS5jbGFzcy5yb29tPC9idW5kbGVJZD4KICAgIDxhcHBOYW1lPmNjPC9hcHBOYW1lPgogICAgPGRyaXZlclR5cGVzPgogICAgICAgIDxkcml2ZXJUeXBlPklPUzwvZHJpdmVyVHlwZT4KICAgIDwvZHJpdmVyVHlwZXM+CiAgICA8cGVuVHlwZXM+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iQURQXzEwMSIgSUQ9IjUiIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iRU5fQURQXzYwMSIgSUQ9IjYiIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iRU5fQVBEXzYxMSIgSUQ9IjciIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iVEVfMzAxIiBJRD0iOCIgLz4KICAgICAgICA8cGVuVHlwZSBwZW5OYW1lPSJURV8zMDIiIElEPSI5IiAvPgogICAgICAgIDxwZW5UeXBlIHBlbk5hbWU9IlREXzEwMiIgSUQ9IjEwIiAvPgogICAgPC9wZW5UeXBlcz4KICAgIDxsaWNlbnNlZERhdGU+MTk3MDAxMDE8L2xpY2Vuc2VkRGF0ZT4KICAgIDxleHBpcmVkRGF0ZT45OTk5MTIzMTwvZXhwaXJlZERhdGU+CiAgICA8YXV0aElkPjYwNTk5YzQwYjViYTdkOGYyMTFmZTI3ZjwvYXV0aElkPgogICAgPHNlY3JldD5jU0VoY3kxQU1pTTRmaVFvY0g1ZU1USjJlVzEwWkNseUl6RnlJemN4TWw0PTwvc2VjcmV0PgogICAgPHBhZ2VBZGRyZXNzIHN0YXJ0PSI3MC4wLjE3LjAiIGVuZD0iNzAuMC4xNy4xOSIgcGFnZUNvdW50PSIyMCIgLz4KICAgIDxhdXRob3JpemVyIGNvbXBhbnk9IuWMl+S6rOaLk+aAneW+t+enkeaKgOaciemZkOWFrOWPuCIgd2Vic2l0ZT0iaHR0cDovL3d3dy50c3R1ZHkuY29tLmNuIiAvPgo8L2xpY2Vuc2U+Cg==";
//        roomInfo.bleSignature = @"57E8A02D4FB158106F27FD1ECE5063753FAC2E096E49CB8A53B48B58DDA03A6CC9901865D0BC6DB313AE3AE8CEEFDCC426313ED5FDE8904DB5BACA83658A3F6AC6B360BF676D1EE7C47E9D6471540D8ECF4948680D30C54DC9766960516A7DE2F64594A25A0CF6C74A4872C765E7FC57ED076B8376EAE16682C5A94A432612EA";
//        [ self.liveVC setLiveRoomConfig:roomInfo];

        return;
    }
    if (self.role == CCRole_Teacher)
    {
        if (self.pushVC) {
            [self.pushVC removeObserver];
        }
        self.pushVC = [[CCPushViewController alloc] initWithLandspace:self.isLandSpace];
        self.pushVC.isQuick = YES;
    }
    else if (self.role == CCRole_Student)
    {
        if (self.playVC) {
            [self.playVC removeObserver];
        }
        self.playVC = [[CCPlayViewController alloc] initWithLandspace:self.isLandSpace];
        self.playVC.roleType = CCRole_Student;
        self.playVC.isQuick = YES;
    }
    else if (self.role == CCRole_Inspector)
    {
        if (self.playVC) {
            [self.playVC removeObserver];
        }
        self.playVC = [[CCPlayViewController alloc] initWithLandspace:self.isLandSpace];
        self.playVC.roleType = CCRole_Inspector;
        self.playVC.isQuick = YES;
    }
//    else if (self.role == CCRole_Assistant)
//    {
//        if (self.teacherCopyVC) {
//            [self.teacherCopyVC removeObserver];
//        }
//        self.teacherCopyVC = [[CCTeachCopyViewController alloc]initWithLandspace:self.isLandSpace];
//    }
}

-(void)landscapeRight:(BOOL)isLandscapeRight {
    BOOL willland = isLandscapeRight;
    UIInterfaceOrientation org = willland ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.shouldNeedLandscape = willland;

    int por = (int)org;
    NSNumber *orientationTarget = [NSNumber numberWithInt:por];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)hsLiveControllerLeaveCallBack {
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
}

- (void)hsLiveControllerJoinStatusCallBack:(BOOL)joined info:(NSDictionary *)info {
    UIInterfaceOrientation org = UIInterfaceOrientationLandscapeRight;
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.shouldNeedLandscape = YES;

    int por = (int)org;
    NSNumber *orientationTarget = [NSNumber numberWithInt:por];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
}

// MARK: - 推流成功
- (void)streamLoginSuccess:(NSDictionary *)info {
    HDSTool *tool = [HDSTool sharedTool];
    if (tool.roomMode == 32) {
        [self landscapeRight:YES];
        
        HSRoomConfig *roomInfo = [[HSRoomConfig alloc]init];
        roomInfo.bleLicense = @"PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxsaWNlbnNlIHZlcnNpb249InYxLjAiIGlkPSI2MDU5YTE3Y2I1YmE3ZDhmMjExZmUyODAiPgogICAgPG93bmVyPuWIm+ebm+inhuiBlOaVsOeggeenkeaKgO+8iOWMl+S6rO+8ieaciemZkOWFrOWPuDwvb3duZXI+CiAgICA8dXNlcj5jaGVuZnk8L3VzZXI+CiAgICA8ZW1haWw+Y2hlbmZ5QGJva2VjYy5jb208L2VtYWlsPgogICAgPGJ1bmRsZUlkPmNvbS5jbGFzcy5yb29tPC9idW5kbGVJZD4KICAgIDxhcHBOYW1lPmNjPC9hcHBOYW1lPgogICAgPGRyaXZlclR5cGVzPgogICAgICAgIDxkcml2ZXJUeXBlPklPUzwvZHJpdmVyVHlwZT4KICAgIDwvZHJpdmVyVHlwZXM+CiAgICA8cGVuVHlwZXM+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iQURQXzEwMSIgSUQ9IjUiIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iRU5fQURQXzYwMSIgSUQ9IjYiIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iRU5fQVBEXzYxMSIgSUQ9IjciIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iVEVfMzAxIiBJRD0iOCIgLz4KICAgICAgICA8cGVuVHlwZSBwZW5OYW1lPSJURV8zMDIiIElEPSI5IiAvPgogICAgICAgIDxwZW5UeXBlIHBlbk5hbWU9IlREXzEwMiIgSUQ9IjEwIiAvPgogICAgPC9wZW5UeXBlcz4KICAgIDxsaWNlbnNlZERhdGU+MTk3MDAxMDE8L2xpY2Vuc2VkRGF0ZT4KICAgIDxleHBpcmVkRGF0ZT45OTk5MTIzMTwvZXhwaXJlZERhdGU+CiAgICA8YXV0aElkPjYwNTk5YzQwYjViYTdkOGYyMTFmZTI3ZjwvYXV0aElkPgogICAgPHNlY3JldD5jU0VoY3kxQU1pTTRmaVFvY0g1ZU1USjJlVzEwWkNseUl6RnlJemN4TWw0PTwvc2VjcmV0PgogICAgPHBhZ2VBZGRyZXNzIHN0YXJ0PSI3MC4wLjE3LjAiIGVuZD0iNzAuMC4xNy4xOSIgcGFnZUNvdW50PSIyMCIgLz4KICAgIDxhdXRob3JpemVyIGNvbXBhbnk9IuWMl+S6rOaLk+aAneW+t+enkeaKgOaciemZkOWFrOWPuCIgd2Vic2l0ZT0iaHR0cDovL3d3dy50c3R1ZHkuY29tLmNuIiAvPgo8L2xpY2Vuc2U+Cg==";
        roomInfo.bleSignature = @"57E8A02D4FB158106F27FD1ECE5063753FAC2E096E49CB8A53B48B58DDA03A6CC9901865D0BC6DB313AE3AE8CEEFDCC426313ED5FDE8904DB5BACA83658A3F6AC6B360BF676D1EE7C47E9D6471540D8ECF4948680D30C54DC9766960516A7DE2F64594A25A0CF6C74A4872C765E7FC57ED076B8376EAE16682C5A94A432612EA";
        roomInfo.version_info = info;
        roomInfo.allowTakePhotoInLibrary = YES;
        roomInfo.openUrl = @"tms-apps://itunes.apple.com/app/id1537062148";//@"itms-apps://itunes.apple.com/app/id1239642978";
        
        roomInfo.r_accountId = GetFromUserDefaults(LIVE_USERID);
        roomInfo.r_roomId = GetFromUserDefaults(LIVE_ROOMID);
        roomInfo.r_sessionId = self.sessionID;
        CCEncodeConfig *config = [[CCEncodeConfig alloc] init];
        config.reslution = CCResolution_240;
        roomInfo.r_config = config;
        
        self.liveVC.delegate = self;
        
        [self.liveVC joinLiveRoom:roomInfo withPush:self.navigationController animated:YES];
        
//        self.liveVC.version_info = info;
//        self.liveVC.openUrl = @"itms-apps://itunes.apple.com/app/id1239642978";
//        if ([[self.navigationController.viewControllers lastObject] isKindOfClass:self.class]) {
//            [self.navigationController pushViewController:self.liveVC animated:YES];
//        }
        return;
    }
    //存储用户名、密码
    NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
    NSString *userName = [V5_UserModel uname];
    NSString *userpwd = ak;//@"671309";
    SaveToUserDefaults(@"kkuserName", userName);
    SaveToUserDefaults(@"kkuserpwd", userpwd);
    NSString *userID =  self.descModel.data.userid;
    SaveToUserDefaults(LIVE_USERNAME, userName);
    if (self.role == CCRole_Teacher || self.role == CCRole_Assistant)
    {
        [CCDrawMenuView teacherResetDefaultColor];
    }
    else
    {
        [CCDrawMenuView resetDefaultColor];
    }
    if (self.role == CCRole_Teacher)
    {
        self.pushVC.sessionId =  self.sessionID;
        self.pushVC.viewerId = userID;
        self.pushVC.isLandSpace = self.isLandSpace;
        self.pushVC.roomID = self.descModel.data.live_roomid;
        self.pushVC.videoOriMode = self.isLandSpace ? CCVideoLandscape : CCVideoPortrait;
        self.pushVC.videoOriMode = CCVideoChangeByInterface;
//        if ([self isControllerPresented:[CCPushViewController class]]) {
//            return;
//        }
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:self.pushVC];
        Nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:Nav animated:YES completion:^{
            
        }];
//        [self.navigationController pushViewController:self.pushVC animated:YES];
    }
    else if (self.role == CCRole_Student)
    {
        self.playVC.sessionId =  self.sessionID;
        self.playVC.viewerId = userID;
//        self.playVC.videoAndAudioNoti = self.videoAndAudioNoti;
//        self.videoAndAudioNoti = nil;
        self.playVC.isLandSpace = self.isLandSpace;
        
        self.playVC.isNeedPWD = self.needPassword;
        self.playVC.roleType = CCRole_Student;
        self.playVC.talker_audio = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_talker_audio;
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:self.playVC];
        Nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:Nav animated:YES completion:^{
            
        }];
//        [self.navigationController pushViewController:self.playVC animated:YES];
    }
    else if (self.role == CCRole_Inspector)
    {
        self.playVC.loginInfo = info;
        self.playVC.viewerId = userID;
        self.playVC.sessionId =  self.sessionID;
//        self.playVC.videoAndAudioNoti = self.videoAndAudioNoti;
//        self.videoAndAudioNoti = nil;
        self.playVC.isLandSpace = self.isLandSpace;
        self.playVC.roleType = CCRole_Inspector;
        self.playVC.talker_audio = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_talker_audio;
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:self.playVC];
        Nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:Nav animated:YES completion:^{
            
        }];
//        [self.navigationController pushViewController:self.playVC animated:YES];
//        if ([self isControllerPresented:[CCPlayViewController class]]) {
//            return;
//        }
//        [self.navigationController pushViewController:self.playVC animated:YES];
    }
}

- (BOOL)isControllerPresented:(Class)class {
    UIViewController *vc = [HDSTool currentViewController];
    if ([vc isKindOfClass:class]) {
        NSLog(@"UIViewController---ERROR!---:%@",class);
        return YES;
    }
    return NO;
}

// MARK: - 云课堂回放(链接网页播放)
- (void)ccClassRoomPlayBack:(NSDictionary *)ccInfo {
    NSString *userid = [NSString stringWithFormat:@"%@",ccInfo[@"sec_live"][@"cc_userid"]];
    NSString *roomid = [NSString stringWithFormat:@"%@",ccInfo[@"sec_live"][@"cc_room_id"]];
    NSString *cc_replay_url = [NSString stringWithFormat:@"%@",ccInfo[@"sec_live"][@"cc_replay_url"]];
    if (!SWNOTEmptyStr(cc_replay_url)) {
        [self showHudInView:self.view showHint:@"直播无回放"];
        return;
    }
    if (SWNOTEmptyStr(cc_replay_url)) {
        NSString *ak = [NSString stringWithFormat:@"%@:%@",[V5_UserModel oauthToken],[V5_UserModel oauthTokenSecret]];
        NSString *ccplayBackUrlString = [NSString stringWithFormat:@"%@&autoLogin=true&viewername=%@&viewertoken=%@",cc_replay_url,[V5_UserModel uname],ak];
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *encodedString = [ccplayBackUrlString stringByAddingPercentEncodingWithAllowedCharacters:set];
        WkWebViewController *vc = [[WkWebViewController alloc] init];
        vc.urlString = encodedString;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
