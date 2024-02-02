//
//  WeekDayCollectionViewCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/12/15.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "WeekDayCollectionViewCell.h"
#import "V5_Constant.h"

@implementation WeekDayCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 24 + 11)];
    _weekLabel.font = SYSTEMFONT(12);
    _weekLabel.textColor = EdlineV5_Color.textThirdColor;
    _weekLabel.textAlignment = NSTextAlignmentCenter;
    _weekLabel.text = @"日";
    [self.contentView addSubview:_weekLabel];
    
    _dayButton = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width - 24) / 2.0, 31.5, 24, 24)];
    _dayButton.layer.masksToBounds = YES;
    _dayButton.layer.cornerRadius = 12;
    _dayButton.titleLabel.font = SYSTEMFONT(15);
    [_dayButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [_dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_dayButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [_dayButton setTitle:@"15" forState:0];
    [_dayButton addTarget:self action:@selector(dayBbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_dayButton];
    
    _hasLiveView = [[UIView alloc] initWithFrame:CGRectMake(0, _dayButton.bottom + 3.5, 5, 5)];
    _hasLiveView.layer.masksToBounds = YES;
    _hasLiveView.layer.cornerRadius = 2.5;
    _hasLiveView.centerX = _dayButton.centerX;
    _hasLiveView.backgroundColor = EdlineV5_Color.themeColor;
    [self.contentView addSubview:_hasLiveView];
    _hasLiveView.hidden = YES;
}

- (void)setWeekCellDeatilInfo:(NSDate *)cellInfoDate hasWeekDayArray:(NSMutableArray *)yymmddwwArray isSelected:(BOOL)selected currentDay:(NSString *)currentday cellindexpath:(NSIndexPath *)cellindexpath hasScheduleArray:(NSMutableArray *)hasScheduleArray {
    _cellIndexpath = cellindexpath;
    _weekLabel.text = [NSString stringWithFormat:@"%@",yymmddwwArray[3]];
    [_dayButton setTitle:[NSString stringWithFormat:@"%@",yymmddwwArray[2]] forState:0];
    NSString *yyString = [NSString stringWithFormat:@"%@",yymmddwwArray[1]];
    if (yyString.length<2) {
        yyString = [NSString stringWithFormat:@"0%@",yymmddwwArray[1]];
    }
    NSString *ddString = [NSString stringWithFormat:@"%@",yymmddwwArray[2]];
    if (ddString.length<2) {
        ddString = [NSString stringWithFormat:@"0%@",yymmddwwArray[2]];
    }
    NSString *cellday = [NSString stringWithFormat:@"%@-%@-%@",yymmddwwArray[0],yyString,ddString];
    if ([cellday isEqualToString:currentday]) {
        [_dayButton setTitle:@"今" forState:0];
    } else {
        [_dayButton setTitle:[NSString stringWithFormat:@"%@",yymmddwwArray[2]] forState:0];
    }
    
    if (selected) {
        _dayButton.selected = YES;
        _dayButton.backgroundColor = EdlineV5_Color.themeColor;
    } else {
        _dayButton.selected = NO;
        _dayButton.backgroundColor = [UIColor whiteColor];
    }
    
//    NSString *isSelected = [NSString stringWithFormat:@"%@",cellInfo[@"isSelected"]];
//    if (isSelected) {
//        _dayButton.selected = YES;
//        _dayButton.backgroundColor = EdlineV5_Color.themeColor;
//    } else {
//        _dayButton.selected = NO;
//        _dayButton.backgroundColor = [UIColor whiteColor];
//    }
//
    if ([hasScheduleArray containsObject:cellday]) {
        _hasLiveView.hidden = NO;
    } else {
        _hasLiveView.hidden = YES;
    }
}

- (void)setWeekCellDeatilInfo:(NSDictionary *)cellInfo {
//    @{@"week":,@"day":,@"hasLive":,@"isSelected":}
    _weekLabel.text = [NSString stringWithFormat:@"%@",cellInfo[@"week"]];
    [_dayButton setTitle:[NSString stringWithFormat:@"%@",cellInfo[@"day"]] forState:0];
    
    NSString *isSelected = [NSString stringWithFormat:@"%@",cellInfo[@"isSelected"]];
    if (isSelected) {
        _dayButton.selected = YES;
        _dayButton.backgroundColor = EdlineV5_Color.themeColor;
    } else {
        _dayButton.selected = NO;
        _dayButton.backgroundColor = [UIColor whiteColor];
    }
    
    NSString *hasLive = [NSString stringWithFormat:@"%@",cellInfo[@"hasLive"]];
    if (hasLive) {
        _hasLiveView.hidden = NO;
    } else {
        _hasLiveView.hidden = YES;
    }
}

- (void)dayBbuttonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cellDayButtonClick:)]) {
        [_delegate cellDayButtonClick:_cellIndexpath];
    }
}

@end
