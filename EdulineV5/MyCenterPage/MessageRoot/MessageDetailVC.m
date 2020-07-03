//
//  MessageDetailVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MessageDetailVC.h"
#include "V5_Constant.h"

@interface MessageDetailVC ()<TYAttributedLabelDelegate>

@property (strong, nonatomic) TYAttributedLabel *contentLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"系统公告";
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    [self makeSubView];
}

- (void)makeSubView {
    _contentLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(15, MACRO_UI_UPHEIGHT + 10, MainScreenWidth - 30, 100)];
    _contentLabel.text = @"但看待死但那打死爱死打卡上的劳动拉上来的啦啦队啦啦收到啦到啦但看待死但那打死爱死打卡上的劳动拉上来的啦啦队啦啦收到啦到啦,但看待死但那打死爱死打卡上的劳动拉上来的啦啦队啦啦收到啦到啦,但看待死但那打死爱死打卡上的劳动拉上来的啦啦队啦啦收到啦到啦,但看待死但那打死爱死打卡上的劳动拉上来的啦啦队啦啦收到啦到啦";
    _contentLabel.textColor = EdlineV5_Color.textSecendColor;
    _contentLabel.font = SYSTEMFONT(14);
    _contentLabel.numberOfLines = 0;
    _contentLabel.delegate = self;
    [_contentLabel sizeToFit];
    [_contentLabel setHeight:_contentLabel.height];
    [self.view addSubview:_contentLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _contentLabel.bottom + 15, MainScreenWidth - 30, 20)];
    _timeLabel.text = @"18:23";
    _timeLabel.font = SYSTEMFONT(12);
    _timeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.view addSubview:_timeLabel];
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
