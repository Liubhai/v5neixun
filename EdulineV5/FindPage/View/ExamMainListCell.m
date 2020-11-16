//
//  ExamMainListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/13.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ExamMainListCell.h"
#import "V5_Constant.h"

#define examMainCellWidth (MainScreenWidth/2.0 - 12.5)
#define examMainCellHeight (MainScreenHeight - MACRO_UI_UPHEIGHT - 20 * 2)/2.0 - 24

@implementation ExamMainListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 12, examMainCellWidth, examMainCellHeight)];
    _backImageView.image = Image(@"exam_card_bg");
    _backImageView.hidden = YES;
    [self.contentView addSubview:_backImageView];
    
    _typeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 115, 115)];
    _typeIcon.centerX = _backImageView.centerX;
    _typeIcon.centerY = _backImageView.centerY - 33;
    _typeIcon.hidden = YES;
    [self.contentView addSubview:_typeIcon];
    
    _typeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _backImageView.width, 50)];
    _typeTitle.centerX = _backImageView.centerX;
    _typeTitle.centerY = _backImageView.centerY + 141 / 2.0;
    
    _typeTitle.textColor = EdlineV5_Color.textFirstColor;
    _typeTitle.font = SYSTEMFONT(15);
    _typeTitle.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_typeTitle];
}

- (void)setExamMainListInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndex {
    _backImageView.hidden = NO;
    _typeIcon.hidden = NO;
    _typeTitle.hidden = NO;
    if (cellIndex.row % 2 == 0) {
        _backImageView.frame = CGRectMake(11, 12, examMainCellWidth, examMainCellHeight);
    } else {
        _backImageView.frame = CGRectMake(1.5, 12, examMainCellWidth, examMainCellHeight);
    }
    _typeIcon.centerX = _backImageView.centerX;
    _typeIcon.centerY = _backImageView.centerY - 33;
    
    _typeTitle.centerX = _backImageView.centerX;
    _typeTitle.centerY = _backImageView.centerY + 141 / 2.0;
    
    _typeIcon.image = Image([info objectForKey:@"image"]);
//    [_typeIcon sd_setImageWithURL:EdulineUrlString([info objectForKey:@"icon_url"]) placeholderImage:nil];
    _typeTitle.text = [info objectForKey:@"title"];
}

@end
