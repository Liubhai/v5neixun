//
//  GroupDetailViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/15.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "V5_Constant.h"
#import "KanjiaListCell.h"
#import "Net_Path.h"
#import "V5_UserModel.h"

@interface GroupDetailViewController ()<UITableViewDelegate, UITableViewDataSource> {
    // 活动倒计时
    NSInteger eventTime;
    NSTimer *eventTimer;
}

@property (strong, nonatomic) UIImageView *topBackImage;

@property (strong, nonatomic) UIView *courseInfoBackView;
@property (strong, nonatomic) UIImageView *courseFaceImage;
@property (strong, nonatomic) UIImageView *courseTypeIcon;
@property (strong, nonatomic) UIImageView *courseActivityIcon;
@property (strong, nonatomic) UILabel *courseTitleLabel;
@property (strong, nonatomic) UILabel *courseSellPrice;
@property (strong, nonatomic) UILabel *courseOriginPrice;
@property (strong, nonatomic) UIImageView *courseActivityTypeIcon;

@property (strong, nonatomic) UIView *groupBackView;
@property (strong, nonatomic) UILabel *groupResult;
@property (strong, nonatomic) UILabel *groupResultTip;

// 倒计时UI
@property (strong, nonatomic) UIView *timeBackView;
@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UILabel *hourLabel;
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *minuteLabel;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *secondLabel;

// 团购 (参团成员)
@property (strong, nonatomic) UIScrollView *menberScrollView;
@property (strong, nonatomic) NSMutableArray *tuanMenberDataSource;
// 团购操作按钮
@property (strong, nonatomic) UIButton *doButton;

// 砍价(砍价icon)
@property (strong, nonatomic) UIImageView *kanjiaImage;
@property (strong, nonatomic) UIView *progressDefault;
@property (strong, nonatomic) UIView *progressCount;
@property (strong, nonatomic) UILabel *kanjiaCountLabel;
@property (strong, nonatomic) UIImageView *kanjiaTrianGleImage;
@property (strong, nonatomic) UIButton *kanjiaButton;

@property (strong, nonatomic) UIView *kanjiaListBack;
@property (strong, nonatomic) UIImageView *kanjiaListIcon;
@property (strong, nonatomic) UITableView *kanjiaTableView;

@property (strong, nonatomic) NSDictionary *activityInfo;

/** 砍价人列表 */
@property (strong, nonatomic) NSMutableArray *kanjiaDataSource;

@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    _titleLabel.text = [_activityType isEqualToString:@"4"] ? @"拼团详情" : @"砍价详情";
    
    _kanjiaDataSource = [NSMutableArray new];
    _tuanMenberDataSource = [NSMutableArray new];
    
    [self makeCourseInfoView];
    [self groupDetailUI];
    [self requestActivityDetailInfo];
    // Do any additional setup after loading the view.
}

// MARK: - 构建课程信息UI
- (void)makeCourseInfoView {
    _topBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 100)];
    _topBackImage.image = Image(@"activity_details_bg");
    [self.view addSubview:_topBackImage];
    
    _courseInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(15, _topBackImage.top + 45, MainScreenWidth - 30, 110)];
    _courseInfoBackView.layer.masksToBounds = YES;
    _courseInfoBackView.layer.cornerRadius = 4;
    _courseInfoBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_courseInfoBackView];
    
    _courseFaceImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 14, 148, 82)];
    _courseFaceImage.clipsToBounds = YES;
    _courseFaceImage.contentMode = UIViewContentModeScaleAspectFill;
    _courseFaceImage.layer.masksToBounds = YES;
    _courseFaceImage.layer.cornerRadius = 2;
    [_courseInfoBackView addSubview:_courseFaceImage];
    
    _courseTypeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFaceImage.left, _courseFaceImage.top, 33, 20)];
    _courseTypeIcon.image = Image(@"class_icon");
    _courseTypeIcon.layer.masksToBounds = YES;
    _courseTypeIcon.layer.cornerRadius = 2;
    [_courseInfoBackView addSubview:_courseTypeIcon];
    
    _courseActivityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFaceImage.right - 32, _courseFaceImage.bottom - 17, 32, 17)];
    _courseActivityIcon.hidden = YES;
    [_courseInfoBackView addSubview:_courseActivityIcon];
    
    _courseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFaceImage.right + 8, 15, _courseInfoBackView.width - (_courseFaceImage.right + 8) - 8, 40)];
    _courseTitleLabel.textColor = EdlineV5_Color.textFirstColor;
    _courseTitleLabel.font = SYSTEMFONT(14);
    _courseTitleLabel.numberOfLines = 0;
    _courseTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_courseInfoBackView addSubview:_courseTitleLabel];
    
    _courseSellPrice = [[UILabel alloc] initWithFrame:CGRectMake(_courseFaceImage.right + 8, _courseFaceImage.bottom - 15, _courseTitleLabel.width / 2.0, 15)];
    _courseSellPrice.font = SYSTEMFONT(13);
    _courseSellPrice.textColor = EdlineV5_Color.faildColor;
    [_courseInfoBackView addSubview:_courseSellPrice];
    
    _courseOriginPrice = [[UILabel alloc] initWithFrame:CGRectMake(_courseSellPrice.right, _courseFaceImage.bottom - 15, _courseTitleLabel.width / 2.0, 15)];
    _courseOriginPrice.font = SYSTEMFONT(12);
    _courseOriginPrice.textColor = EdlineV5_Color.textSecendColor;
    [_courseInfoBackView addSubview:_courseOriginPrice];
}

// MARK: - 开团的具体详情UI
- (void)groupDetailUI {
    _groupBackView = [[UIView alloc] initWithFrame:CGRectMake(15, _courseInfoBackView.bottom + 12, MainScreenWidth - 30, MainScreenHeight - (_courseInfoBackView.bottom + 12) - 0)];
    _groupBackView.layer.masksToBounds = YES;
    _groupBackView.layer.cornerRadius = 4;
    _groupBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_groupBackView];
    
    _groupResult = [[UILabel alloc] initWithFrame:CGRectMake(8, 28, _groupBackView.width - 16, 22)];
    _groupResult.textColor = EdlineV5_Color.textFirstColor;
    _groupResult.font = SYSTEMFONT(16);
    _groupResult.textAlignment = NSTextAlignmentCenter;
    [_groupBackView addSubview:_groupResult];
    
    _groupResultTip = [[UILabel alloc] initWithFrame:CGRectMake(_groupResult.left, _groupResult.bottom + 16, _groupResult.width, 14)];
    _groupResultTip.textColor = EdlineV5_Color.textSecendColor;
    _groupResultTip.font = SYSTEMFONT(10);
    _groupResultTip.textAlignment = NSTextAlignmentCenter;
    [_groupBackView addSubview:_groupResultTip];
    
    // 倒计时
    _timeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _groupResult.bottom + 14, 100, 18)];
    [_groupBackView addSubview:_timeBackView];
    
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 18)];
    _dayLabel.textColor = EdlineV5_Color.courseActivityGroupColor;
    _dayLabel.font = SYSTEMFONT(10);
    _dayLabel.textAlignment = NSTextAlignmentRight;
    _dayLabel.text = @"100天";
    [_timeBackView addSubview:_dayLabel];
    
    _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(_dayLabel.right + 6, _dayLabel.top, 17, 18)];
    _hourLabel.layer.masksToBounds = YES;
    _hourLabel.layer.cornerRadius = 3.0;
    _hourLabel.backgroundColor = EdlineV5_Color.courseActivityGroupColor;
    _hourLabel.font = SYSTEMFONT(10);
    _hourLabel.textColor = [UIColor whiteColor];
    _hourLabel.text = @"12";
    _hourLabel.textAlignment = NSTextAlignmentCenter;
    [_timeBackView addSubview:_hourLabel];
    
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(_hourLabel.right, _dayLabel.top, 6, 18)];
    _label1.font = SYSTEMFONT(10);
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.text = @":";
    _label1.textColor = EdlineV5_Color.courseActivityGroupColor;
    [_timeBackView addSubview:_label1];
    
    _minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(_label1.right, _dayLabel.top, 17, 18)];
    _minuteLabel.layer.masksToBounds = YES;
    _minuteLabel.layer.cornerRadius = 3.0;
    _minuteLabel.backgroundColor = EdlineV5_Color.courseActivityGroupColor;
    _minuteLabel.font = SYSTEMFONT(10);
    _minuteLabel.textColor = [UIColor whiteColor];
    _minuteLabel.text = @"33";
    _minuteLabel.textAlignment = NSTextAlignmentCenter;
    [_timeBackView addSubview:_minuteLabel];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(_minuteLabel.right, _dayLabel.top, 6, 18)];
    _label2.font = SYSTEMFONT(10);
    _label2.textAlignment = NSTextAlignmentCenter;
    _label2.text = @":";
    _label2.textColor = EdlineV5_Color.courseActivityGroupColor;
    [_timeBackView addSubview:_label2];
    
    _secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(_label2.right, _dayLabel.top, 17, 18)];
    _secondLabel.layer.masksToBounds = YES;
    _secondLabel.layer.cornerRadius = 3.0;
    _secondLabel.backgroundColor = EdlineV5_Color.courseActivityGroupColor;
    _secondLabel.font = SYSTEMFONT(10);
    _secondLabel.textColor = [UIColor whiteColor];
    _secondLabel.text = @"23";
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    [_timeBackView addSubview:_secondLabel];
    
    [_timeBackView setWidth:_secondLabel.right];
    _timeBackView.centerX = _groupBackView.width / 2.0;
    
    if ([_activityType isEqualToString:@"3"]) {
        [self makeKanjiaUI];
        return;
    }
    
    // todo 这里要区分类型了 团购 砍价
    
    _menberScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _groupResult.bottom + 16 + 14 + 36, _groupBackView.width, _groupBackView.height - 40 - 40 - 40)];
    [_groupBackView addSubview:_menberScrollView];
    
    _doButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _groupBackView.height - 40 - 40, 200, 40)];
    _doButton.layer.masksToBounds = YES;
    _doButton.layer.cornerRadius = 20;
    [_doButton setBackgroundColor:EdlineV5_Color.courseActivityGroupColor];
    [_doButton setTitle:@"邀请好友参团" forState:0];
    [_doButton setTitleColor:[UIColor whiteColor] forState:0];
    _doButton.titleLabel.font = SYSTEMFONT(16);
    _doButton.centerX = _groupBackView.width / 2.0;
    [_doButton addTarget:self action:@selector(groupDoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_groupBackView addSubview:_doButton];
    
}

// MARK: - 砍价UI
- (void)makeKanjiaUI {
    _progressDefault = [[UIView alloc] initWithFrame:CGRectMake(15, _timeBackView.bottom + 35, _groupBackView.width - 30, 14)];
    _progressDefault.backgroundColor = EdlineV5_Color.courseActivityBackColor;
    _progressDefault.layer.masksToBounds = YES;
    _progressDefault.layer.cornerRadius = _progressDefault.height / 2.0;
    _progressDefault.layer.borderWidth = 0.5;
    _progressDefault.layer.borderColor = EdlineV5_Color.courseActivityGroupColor.CGColor;
    [_groupBackView addSubview:_progressDefault];
    
    _progressCount = [[UIView alloc] initWithFrame:CGRectMake(15, _timeBackView.bottom + 35, (_groupBackView.width - 30) * 0.6, 14)];
    _progressCount.backgroundColor = EdlineV5_Color.courseActivityGroupColor;
    _progressCount.layer.masksToBounds = YES;
    _progressCount.layer.cornerRadius = _progressCount.height / 2.0;
    [_groupBackView addSubview:_progressCount];
    
    _kanjiaImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 24)];
    _kanjiaImage.image = Image(@"kanjia_details_coin");
    _kanjiaImage.center = CGPointMake(15, _progressCount.centerY);
    [_groupBackView addSubview:_kanjiaImage];
    
    NSString *kanjianCount = [NSString stringWithFormat:@"已砍%@32.89",IOSMoneyTitle];
    _kanjiaCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _progressCount.bottom + 10, 0, 18)];
    _kanjiaCountLabel.backgroundColor = EdlineV5_Color.courseActivityBackColor;
    _kanjiaCountLabel.textAlignment = NSTextAlignmentCenter;
    _kanjiaCountLabel.text = kanjianCount;
    _kanjiaCountLabel.font = SYSTEMFONT(10);
    _kanjiaCountLabel.textColor = EdlineV5_Color.courseActivityGroupColor;
    _kanjiaCountLabel.layer.masksToBounds = YES;
    _kanjiaCountLabel.layer.cornerRadius = 4;
    CGFloat kanjianCountWidth = [_kanjiaCountLabel.text sizeWithFont:_kanjiaCountLabel.font].width + 10;
    _kanjiaCountLabel.frame = CGRectMake(0, _progressCount.bottom + 10, kanjianCountWidth, 18);
    _kanjiaCountLabel.centerX = _progressCount.right;
    [_groupBackView addSubview:_kanjiaCountLabel];
    
    _kanjiaTrianGleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 3)];
    _kanjiaTrianGleImage.center = CGPointMake(_kanjiaCountLabel.centerX, _kanjiaCountLabel.top - _kanjiaTrianGleImage.height / 2.0);
    _kanjiaTrianGleImage.image = Image(@"kanjia_sanjiao_icon");
    [_groupBackView addSubview:_kanjiaTrianGleImage];
    
    _kanjiaButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _kanjiaCountLabel.bottom + 25, 200, 40)];
    _kanjiaButton.layer.masksToBounds = YES;
    _kanjiaButton.layer.cornerRadius = 20;
    [_kanjiaButton setBackgroundColor:EdlineV5_Color.courseActivityGroupColor];
    [_kanjiaButton setTitle:@"邀请好友砍价" forState:0];
    [_kanjiaButton setTitleColor:[UIColor whiteColor] forState:0];
    _kanjiaButton.titleLabel.font = SYSTEMFONT(16);
    _kanjiaButton.centerX = _groupBackView.width / 2.0;
    [_groupBackView addSubview:_kanjiaButton];
    
    _kanjiaListBack = [[UIView alloc] initWithFrame:CGRectMake(15, _kanjiaButton.bottom + 28, _groupBackView.width - 30, _groupBackView.height - 34 - (_kanjiaButton.bottom + 28))];
    _kanjiaListBack.backgroundColor = EdlineV5_Color.courseActivityBackColor;
    _kanjiaListBack.layer.masksToBounds = YES;
    _kanjiaListBack.layer.cornerRadius = 8;
    [_groupBackView addSubview:_kanjiaListBack];
    
    _kanjiaListIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 19, 106, 16)];
    _kanjiaListIcon.image = Image(@"kanjia_list");
    _kanjiaListIcon.centerX = _kanjiaListBack.width / 2.0;
    [_kanjiaListBack addSubview:_kanjiaListIcon];
    
    _kanjiaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _kanjiaListIcon.bottom + 13, _kanjiaListBack.width, _kanjiaListBack.height - (_kanjiaListIcon.bottom + 13) - 8)];
    _kanjiaTableView.showsVerticalScrollIndicator = NO;
    _kanjiaTableView.backgroundColor = EdlineV5_Color.courseActivityBackColor;
    _kanjiaTableView.delegate = self;
    _kanjiaTableView.dataSource = self;
    _kanjiaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_kanjiaListBack addSubview:_kanjiaTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _kanjiaDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"kanjiaCell";
    KanjiaListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[KanjiaListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setKanjieDetailInfo:_kanjiaDataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

// MARK: - 请求砍价详情
- (void)requestActivityDetailInfo {
    if (!SWNOTEmptyStr(_activityId)) {
        return;
    }
    if (SWNOTEmptyStr(_activityType)) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        NSString *getUrl = [Net_Path kanjiaDetailInfoNet];
        if ([_activityType isEqualToString:@"1"]) {
            // 限时打折
        } else if ([_activityType isEqualToString:@"2"]) {
            // 秒杀
        } else if ([_activityType isEqualToString:@"3"]) {
            // 砍价
            getUrl = [Net_Path kanjiaDetailInfoNet];
            [param setObject:_activityId forKey:@"promotion_id"];
        } else if ([_activityType isEqualToString:@"4"]) {
            // 拼团
            getUrl = [Net_Path pintuanDetailInfoNet];
            [param setObject:_activityId forKey:@"tuan_id"];
        }
        [Net_API requestGETSuperAPIWithURLStr:getUrl WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _activityInfo = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                }
            }
            [self setActivityData];
            
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)setActivityData {
    if ([_activityType isEqualToString:@"3"]) {
        // 砍价
        if (SWNOTEmptyDictionary(_activityInfo)) {
            [_courseFaceImage sd_setImageWithURL:EdulineUrlString(_activityInfo[@"product_cover"]) placeholderImage:DefaultImage];
            NSString *courseType = [NSString stringWithFormat:@"%@",_activityInfo[@"product_type"]];
            if ([courseType isEqualToString:@"1"]) {
                _courseTypeIcon.image = Image(@"dianbo");
            } else if ([courseType isEqualToString:@"2"]) {
                _courseTypeIcon.image = Image(@"live");
            } else if ([courseType isEqualToString:@"3"]) {
                _courseTypeIcon.image = Image(@"mianshou");
            } else if ([courseType isEqualToString:@"4"]) {
                _courseTypeIcon.image = Image(@"class_icon");
            }
            _courseActivityIcon.hidden = NO;
            _courseActivityIcon.image = Image(@"kanjia_icon");
            
            _courseTitleLabel.text = [NSString stringWithFormat:@"%@",_activityInfo[@"product_title"]];
            
            _courseSellPrice.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,_activityInfo[@"product_price"]];
            
            NSString *bargained_nums = [NSString stringWithFormat:@"%@",_activityInfo[@"bargained_nums"]];
            NSString *remain_nums = [NSString stringWithFormat:@"%@",_activityInfo[@"remain_nums"]];
            NSString *bargain_finished = [NSString stringWithFormat:@"%@",_activityInfo[@"bargain_finished"]];
            // 当前用户是否砍价
            NSString *current_bargain_count = [NSString stringWithFormat:@"%@",_activityInfo[@"current_bargain_count"]];
            NSString *current_bargain_price = [NSString stringWithFormat:@"%@",_activityInfo[@"current_bargain_price"]];
            
            CGFloat kanjiatotal = [[NSString stringWithFormat:@"%@",_activityInfo[@"bargained_total_price"]] floatValue];
            CGFloat total = [[NSString stringWithFormat:@"%@",_activityInfo[@"bargain_price"]] floatValue];
            
            _progressCount.frame = CGRectMake(15, _timeBackView.bottom + 35, (_groupBackView.width - 30) * kanjiatotal / total, 14);
            
            NSString *kanjianCount = [NSString stringWithFormat:@"已砍%@%@",IOSMoneyTitle,_activityInfo[@"bargained_total_price"]];
            _kanjiaCountLabel.text = kanjianCount;
            CGFloat kanjianCountWidth = [_kanjiaCountLabel.text sizeWithFont:_kanjiaCountLabel.font].width + 10;
            _kanjiaCountLabel.frame = CGRectMake(0, _progressCount.bottom + 10, kanjianCountWidth, 18);
            _kanjiaCountLabel.centerX = _groupBackView.width / 2.0;
            
            NSString *end_countdown = [NSString stringWithFormat:@"%@",[_activityInfo objectForKey:@"end_countdown"]];
            NSString *start_countdown = [NSString stringWithFormat:@"%@",[_activityInfo objectForKey:@"start_countdown"]];
            
            NSString *sponsor_user_id = [NSString stringWithFormat:@"%@",_activityInfo[@"sponsor_user_id"]];
            BOOL isMine = [sponsor_user_id isEqualToString:[V5_UserModel uid]];
            
            if ([[_activityInfo objectForKey:@"running_status"] integerValue] == 1) {
                eventTime = [end_countdown integerValue];
                if (eventTime<=0) {
                    // 活动已经结束 显示成功或者失败
                    if ([bargain_finished isEqualToString:@"1"]) {
                        // 活动成功
                        _groupResult.text = @"恭喜您，砍价成功";
                        [_kanjiaButton setTitle:@"去支付" forState:0];
                        if (!isMine) {
                            _groupResult.text = @"砍价已结束";
                            [_kanjiaButton setTitle:@"我也想要" forState:0];
                        }
                    } else {
                        // 失败了
                        _groupResult.text = @"砍价已结束，砍价失败";
                        [_kanjiaButton setTitle:@"活动已结束" forState:0];
                        if (!isMine) {
                            _groupResult.text = @"砍价已结束";
                            [_kanjiaButton setTitle:@"我也想要" forState:0];
                        }
                    }
                } else {
                    // 砍价已经完成
                    if ([bargain_finished isEqualToString:@"1"]) {
                        // 活动成功
                        _groupResult.text = @"恭喜您，砍价成功";
                        [_kanjiaButton setTitle:@"去支付" forState:0];
                        if (!isMine) {
                            _groupResult.text = @"砍价已结束";
                            [_kanjiaButton setTitle:@"我也想要" forState:0];
                        }
                    } else {
                        // 砍价中...
                        if (isMine) {
                            _groupResult.text = [NSString stringWithFormat:@"已邀请%@名好友，再邀请%@名即可砍价成功",bargained_nums,remain_nums];
                            [_kanjiaButton setTitle:@"邀请好友砍价" forState:0];
                            
                            NSRange fRange = NSMakeRange(2, bargained_nums.length);
                            NSRange sRange = NSMakeRange(9 + bargained_nums.length, remain_nums.length);
                            
                            NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_groupResult.text];
                            [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.courseActivityGroupColor} range:fRange];
                            [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.courseActivityGroupColor} range:sRange];
                            _groupResult.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
                        } else {
                            if ([current_bargain_count isEqualToString:@"1"]) {
                                // 当前用户已经帮忙砍价了
                                _groupResult.text = [NSString stringWithFormat:@"谢谢您，成功砍价%@元",current_bargain_price];
                                [_kanjiaButton setTitle:@"我也想要" forState:0];
                                NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:_groupResult.text];
                                [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.courseActivityGroupColor} range:[_groupResult.text rangeOfString:current_bargain_price]];
                                _groupResult.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
                            } else {
                                _groupResult.text = @"帮我砍一刀吧～";
                                [_kanjiaButton setTitle:@"帮TA砍一刀" forState:0];
                            }
                        }
                    }
                }
            } else {
                eventTime = [start_countdown integerValue];
                _groupResult.text = @"距活动开始还有";
                [_kanjiaButton setTitle:@"邀请好友砍价" forState:0];
            }
            if (eventTime>0) {
                [self startTimer];
            }
            
            [_kanjiaDataSource removeAllObjects];
            if (SWNOTEmptyArr(_activityInfo[@"bargain_data"])) {
                [_kanjiaDataSource addObjectsFromArray:_activityInfo[@"bargain_data"]];
            }
            [_kanjiaTableView reloadData];
        }
    } else {
        if (SWNOTEmptyDictionary(_activityInfo)) {
            [_courseFaceImage sd_setImageWithURL:EdulineUrlString(_activityInfo[@"product_cover"]) placeholderImage:DefaultImage];
            NSString *courseType = [NSString stringWithFormat:@"%@",_activityInfo[@"product_type"]];
            if ([courseType isEqualToString:@"1"]) {
                _courseTypeIcon.image = Image(@"dianbo");
            } else if ([courseType isEqualToString:@"2"]) {
                _courseTypeIcon.image = Image(@"live");
            } else if ([courseType isEqualToString:@"3"]) {
                _courseTypeIcon.image = Image(@"mianshou");
            } else if ([courseType isEqualToString:@"4"]) {
                _courseTypeIcon.image = Image(@"class_icon");
            }
            _courseActivityIcon.hidden = NO;
            _courseActivityIcon.image = Image(@"pintuan_icon");
            
            _courseTitleLabel.text = [NSString stringWithFormat:@"%@",_activityInfo[@"product_title"]];
            
            _courseSellPrice.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,_activityInfo[@"product_price"]];
            
            /*团状态【0：开团待审(未支付成功)；1：开团成功；2：拼团成功；3：团购失败；】**/
            NSString *groupStatus = [NSString stringWithFormat:@"%@",[_activityInfo objectForKey:@"status"]];
            if ([groupStatus isEqualToString:@"1"]) {
                NSString *totalCount = [NSString stringWithFormat:@"%@",[_activityInfo objectForKey:@"total_num"]];
                NSString *joinCount = [NSString stringWithFormat:@"%@",[_activityInfo objectForKey:@"join_num"]];
                NSString *needCount = [NSString stringWithFormat:@"%@",@([totalCount integerValue] - [joinCount integerValue])];
                NSString *final = [NSString stringWithFormat:@"距离拼团成功还差%@人",needCount];
                NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:final];
                [mut addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.courseActivityGroupColor} range:[final rangeOfString:needCount]];
                _groupResult.attributedText = [[NSAttributedString alloc] initWithAttributedString:mut];
                [_doButton setTitle:@"邀请好友参团" forState:0];
            } else if ([groupStatus isEqualToString:@"2"]) {
                _groupResult.text = @"拼团成功";
                _groupResultTip.text = @"恭喜您拼团成功，快去观看课程吧～";
                [_doButton setTitle:@"查看课程" forState:0];
            } else if ([groupStatus isEqualToString:@"3"]) {
                _groupResult.text = @"拼团失败";
                _groupResultTip.text = @"拼团时间已过，款项将自动退回";
                [_doButton setTitle:@"重新开团" forState:0];
            }
            
            NSString *end_countdown = [NSString stringWithFormat:@"%@",[_activityInfo objectForKey:@"expiry_countdown"]];
            eventTime = [end_countdown integerValue];
            if (eventTime>0) {
                [self startTimer];
            }
            
            [_tuanMenberDataSource removeAllObjects];
            if (SWNOTEmptyArr(_activityInfo[@"tuan_data"])) {
                [_tuanMenberDataSource addObjectsFromArray:_activityInfo[@"tuan_data"]];
            }
            [self makeGroupMenberUI];
        }
    }
}

// MARK: - 处理团购成员信息
- (void)makeGroupMenberUI {
    [_menberScrollView removeAllSubviews];
    
    CGFloat xx = 25;
    CGFloat yy = 0.0;
    CGFloat ww = 44;
    CGFloat inSpace = (_groupBackView.width - xx * 2 - ww * 4) / 4.0;
    CGFloat menberTopSpace = 17;
    
    for (int i = 0; i<_tuanMenberDataSource.count; i++) {
        UIImageView *menberImage = [[UIImageView alloc] initWithFrame:CGRectMake(xx + (ww + inSpace) * (i%5), yy + (ww + menberTopSpace) * (i/5), ww, ww)];
        menberImage.layer.masksToBounds = YES;
        menberImage.layer.cornerRadius = ww / 2.0;
        menberImage.clipsToBounds = YES;
        menberImage.contentMode = UIViewContentModeScaleAspectFill;
        [menberImage sd_setImageWithURL:EdulineUrlString([_tuanMenberDataSource[i] objectForKey:@"current_user_avatar_url"]) placeholderImage:DefaultUserImage];
        [_menberScrollView addSubview:menberImage];
        NSString *menberId = [NSString stringWithFormat:@"%@",[_tuanMenberDataSource[i] objectForKey:@"user_id"]];
        if ([menberId isEqualToString:[NSString stringWithFormat:@"%@",_activityInfo[@"user_id"]]]) {
            menberImage.layer.borderColor = EdlineV5_Color.courseActivityGroupColor.CGColor;
            menberImage.layer.borderWidth = 1.0;
            UIImageView *pintuan_captain_icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 19, 10)];
            pintuan_captain_icon.image = Image(@"pintuan_captain_icon");
            pintuan_captain_icon.center = CGPointMake(menberImage.centerX, menberImage.bottom);
            [_menberScrollView addSubview:pintuan_captain_icon];
        }
    }
    _menberScrollView.contentSize = CGSizeMake(0, (_tuanMenberDataSource.count % 5 == 0) ? (_tuanMenberDataSource.count * (ww + menberTopSpace) / 5) : (_tuanMenberDataSource.count * (ww + menberTopSpace) / 5) + (ww + menberTopSpace));
}

// MARK: - 团购底部按钮点击事件
- (void)groupDoButtonClick:(UIButton *)sender {
    NSString *groupStatus = [NSString stringWithFormat:@"%@",[_activityInfo objectForKey:@"status"]];
    if ([groupStatus isEqualToString:@"1"]) {
        // 邀请好友
    } else if ([groupStatus isEqualToString:@"2"]) {
        // 返回上一级课程详情页面或者跳转到对应课程详情页
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([groupStatus isEqualToString:@"3"]) {
        // 重新开团流程未知
    }
}

// MARK: - 开始倒计时
- (void)startTimer {
    __weak typeof(self) weakself = self;
    [NSObject cancelPreviousPerformRequestsWithTarget:weakself];
    [NSObject cancelPreviousPerformRequestsWithTarget:weakself selector:@selector(startTimer) object:nil];
    eventTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(eventTimerDown) userInfo:nil repeats:YES];
}

// MARK: - 活动倒计时
- (void)eventTimerDown {
    eventTime--;
    if (eventTime<=0) {
        [self requestActivityDetailInfo];
        [eventTimer invalidate];
        eventTimer = nil;
    } else {
        _dayLabel.text = [NSString stringWithFormat:@"%@天",[EdulineV5_Tool timeChangeTimerDayHoursMinuteSeconds:eventTime][0]];
        _hourLabel.text = [EdulineV5_Tool timeChangeTimerDayHoursMinuteSeconds:eventTime][1];
        _minuteLabel.text = [EdulineV5_Tool timeChangeTimerDayHoursMinuteSeconds:eventTime][2];
        _secondLabel.text = [EdulineV5_Tool timeChangeTimerDayHoursMinuteSeconds:eventTime][3];
    }
}

- (void)dealloc {
    if (eventTimer) {
        [eventTimer invalidate];
        eventTimer = nil;
    }
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [eventTimer invalidate];
        eventTimer = nil;
    }
}

@end
