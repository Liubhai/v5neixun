//
//  GroupDetailViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/15.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "V5_Constant.h"

@interface GroupDetailViewController ()

@property (strong, nonatomic) UIImageView *topBackImage;

@property (strong, nonatomic) UIView *courseInfoBackView;
@property (strong, nonatomic) UIImageView *courseFaceImage;
@property (strong, nonatomic) UIImageView *courseTypeIcon;
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

@property (strong, nonatomic) UIScrollView *menberScrollView;

@property (strong, nonatomic) UIButton *doButton;

@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    _titleLabel.text = @"拼团详情";
    
    [self makeCourseInfoView];
    [self groupDetailUI];
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
    _groupBackView = [[UIView alloc] initWithFrame:CGRectMake(15, _courseInfoBackView.bottom + 12, MainScreenWidth - 30, MainScreenHeight - (_courseInfoBackView.bottom + 12) - 36)];
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
    [_groupBackView addSubview:_doButton];
}

@end
