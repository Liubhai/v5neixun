//
//  MessageRootVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MessageRootVC.h"
#import "V5_Constant.h"
#import "LBHScrollView.h"
#import "MessageListVC.h"
#import "Net_Path.h"

@interface MessageRootVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIButton *allButton;
@property (strong, nonatomic) UIButton *needDealButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *finishButton;
@property (strong, nonatomic) UILabel *unReadLabel1;
@property (strong, nonatomic) UILabel *unReadLabel2;
@property (strong, nonatomic) UILabel *unReadLabel3;
@property (strong, nonatomic) UILabel *unReadLabel4;


@property (strong, nonatomic) NSMutableArray *typeArray;

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) NSDictionary *messageInfo;

@end

@implementation MessageRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"我的消息";
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"一键已读" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    
    CGFloat rightWidth = [_rightButton.titleLabel.text sizeWithFont:_rightButton.titleLabel.font].width + 4;
    _rightButton.frame = CGRectMake(MainScreenWidth- rightWidth - 15, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, rightWidth, 44);
    _rightButton.hidden = NO;
    
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _lineTL.hidden = NO;
    
    _typeArray = [NSMutableArray new];
    [_typeArray addObjectsFromArray:@[@{@"title":@"课程提醒",@"type":@"course"},@{@"title":@"互动消息",@"type":@"comment"},@{@"title":@"系统消息",@"type":@"system"},@{@"title":@"提问",@"type":@"question"}]];
    
    [self makeTopView];
    [self makeScrollView];
    [self getUnreadMessageCount];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnreadMessageCount) name:@"reloadAllMessage" object:nil];
}

- (void)makeTopView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 45)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 - 2, 20, 2)];
    _lineView.backgroundColor = EdlineV5_Color.baseColor;
    [_topView addSubview:_lineView];
    CGFloat WW = MainScreenWidth / _typeArray.count;
    for (int i = 0; i<_typeArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*WW, 0, WW, _topView.height)];
        [btn setTitleColor:EdlineV5_Color.textThirdColor forState:0];
        [btn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
        btn.titleLabel.font = SYSTEMFONT(14);
        btn.tag = i;
        [btn setTitle:[_typeArray[i] objectForKey:@"title"] forState:0];
        [btn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *redLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        redLabel.layer.masksToBounds = YES;
        redLabel.layer.cornerRadius = redLabel.height / 2.0;
        redLabel.backgroundColor = EdlineV5_Color.faildColor;
        redLabel.hidden = YES;
        
        CGFloat titleWidth = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + 4;
        [redLabel setOrigin:CGPointMake(btn.centerX + titleWidth / 2.0, btn.centerY - 14 / 2.0 - 2)];
        
        if (i == 0) {
            _lineView.centerX = btn.centerX;
            btn.selected = YES;
            _allButton = btn;
            _unReadLabel1 = redLabel;
        } else if (i == 1) {
            _needDealButton = btn;
            _unReadLabel2 = redLabel;
        } else if (i == 2) {
            _cancelButton = btn;
            _unReadLabel3 = redLabel;
        } else if (i == 3) {
            _finishButton = btn;
            _unReadLabel4 = redLabel;
        }
        [_topView addSubview:btn];
        [_topView addSubview:redLabel];
    }
    [_topView bringSubviewToFront:_lineView];
}

- (void)makeScrollView {
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,_topView.bottom, MainScreenWidth, MainScreenHeight - _topView.bottom)];
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth*_typeArray.count, 0);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    for (int i = 0; i<_typeArray.count; i++) {
        MessageListVC *vc = [[MessageListVC alloc] init];
        vc.courseType = [NSString stringWithFormat:@"%@",[_typeArray[i] objectForKey:@"type"]];
        vc.view.frame = CGRectMake(MainScreenWidth*i, 0, MainScreenWidth, _mainScrollView.height);
        [_mainScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        if (scrollView.contentOffset.x <= 0) {
            self.lineView.centerX = self.allButton.centerX;
            self.allButton.selected = YES;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = NO;
            self.finishButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.lineView.centerX = self.cancelButton.centerX;
            self.allButton.selected = NO;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = YES;
            self.finishButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            self.lineView.centerX = self.needDealButton.centerX;
            self.allButton.selected = NO;
            self.needDealButton.selected = YES;
            self.cancelButton.selected = NO;
            self.finishButton.selected = NO;
        }else if (scrollView.contentOffset.x >= 3*MainScreenWidth && scrollView.contentOffset.x <= 3*MainScreenWidth){
            self.lineView.centerX = self.finishButton.centerX;
            self.allButton.selected = NO;
            self.needDealButton.selected = NO;
            self.cancelButton.selected = NO;
            self.finishButton.selected = YES;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"canScrollTable" object:nil userInfo:@{@"can":@"1"}];
}

- (void)topButtonClick:(UIButton *)sender {
    [self.mainScrollView setContentOffset:CGPointMake(MainScreenWidth * sender.tag, 0) animated:YES];
}

- (void)rightButtonClick:(id)sender {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"2" forKey:@"operate"];
    if (_allButton.selected) {
        [param setObject:@"2" forKey:@"object"];
    }
    if (_needDealButton.selected) {
        [param setObject:@"3" forKey:@"object"];
    }
    if (_cancelButton.selected) {
        [param setObject:@"1" forKey:@"object"];
    }
    if (_finishButton.selected) {
        [param setObject:@"4" forKey:@"object"];
    }
    [Net_API requestPOSTWithURLStr:[Net_Path messageReadNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _messageInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                if (_allButton.selected) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMessageList" object:nil userInfo:@{@"type":@"course"}];
                }
                if (_needDealButton.selected) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMessageList" object:nil userInfo:@{@"type":@"comment"}];
                }
                if (_cancelButton.selected) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMessageList" object:nil userInfo:@{@"type":@"system"}];
                }
                if (_finishButton.selected) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMessageList" object:nil userInfo:@{@"type":@"question"}];
                }
                [self setMessageCountInfo];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

/*
operate
2
必填
【0：进入列表页；1：单个消息已读；2：一键已读；】
object
1
选填
operate不等于0时必传【1系统消息；2课程提醒）；3互动消息；4提问消息；】
id
1
必填
operate等于1时必传，消息ID
 */
- (void)getUnreadMessageCount {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"0" forKey:@"operate"];
    [Net_API requestPOSTWithURLStr:[Net_Path messageReadNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _messageInfo = [NSDictionary dictionaryWithDictionary:responseObject];
                [self setMessageCountInfo];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        
    }];
}

/**
 "comment_unread": 2,
 "question_unread": 1,
 "system_unread": 0,
 "course_unread": 0
 */

- (void)setMessageCountInfo {
    if (SWNOTEmptyDictionary(_messageInfo)) {
        NSString *comment_unread = [NSString stringWithFormat:@"%@",_messageInfo[@"data"][@"comment_unread"]];
        NSString *question_unread = [NSString stringWithFormat:@"%@",_messageInfo[@"data"][@"question_unread"]];
        NSString *system_unread = [NSString stringWithFormat:@"%@",_messageInfo[@"data"][@"system_unread"]];
        NSString *course_unread = [NSString stringWithFormat:@"%@",_messageInfo[@"data"][@"course_unread"]];
        _unReadLabel1.hidden = ![course_unread integerValue];
        _unReadLabel2.hidden = ![comment_unread integerValue];
        _unReadLabel3.hidden = ![system_unread integerValue];
        _unReadLabel4.hidden = ![question_unread integerValue];
    }
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
