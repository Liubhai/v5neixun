//
//  FindListCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/1.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "FindListCell.h"
#import "V5_Constant.h"

#define findSingleLeftSpace 6
#define findTopSpace 3
#define findBottomSpace 3
#define findSingleRightSpace 3
#define findFaceImageHeight (MainScreenWidth/2.0 - findSingleRightSpace - findSingleLeftSpace)

@implementation FindListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, findFaceImageHeight, findFaceImageHeight)];
    _backImageView.image = Image(@"find_card");
    _backImageView.hidden = YES;
    [self addSubview:_backImageView];
    
    _typeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 22, 22)];
    _typeIcon.hidden = YES;
    [self addSubview:_typeIcon];
    
    _typeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, findFaceImageHeight, 50)];
    _typeTitle.textColor = EdlineV5_Color.textFirstColor;
    _typeTitle.font = SYSTEMFONT(15);
    [self addSubview:_typeTitle];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, MainScreenWidth, 0.5)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:_lineView];
    
    _rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 8, 18, 8, 14)];
    _rightIcon.image = Image(@"list_more");
    _rightIcon.hidden = YES;
    [self addSubview:_rightIcon];
}

// 如果是 yes 九宫格 no 列表
- (void)setFindListInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndex cellType:(BOOL)cellType {
    if (cellType) {
        _rightIcon.hidden = YES;
        _lineView.hidden = YES;
        _backImageView.hidden = NO;
        _typeIcon.hidden = NO;
        _typeTitle.hidden = NO;
        if (cellIndex.row % 2 == 0) {
            _backImageView.frame = CGRectMake(6, 3, findFaceImageHeight, findFaceImageHeight);
        } else {
            _backImageView.frame = CGRectMake(0, 3, findFaceImageHeight, findFaceImageHeight);
        }
        _typeIcon.frame = CGRectMake(0, _backImageView.centerY - 30, 50, 50);
        _typeIcon.centerX = _backImageView.centerX;
        _typeTitle.frame = CGRectMake(0, 0, findFaceImageHeight, 21);
        _typeTitle.center = CGPointMake(_backImageView.centerX, _typeIcon.bottom + 20);
        _typeTitle.textAlignment = NSTextAlignmentCenter;
    } else {
        _rightIcon.hidden = NO;
        _lineView.hidden = NO;
        _backImageView.hidden = YES;
        _typeIcon.hidden = NO;
        _typeTitle.hidden = NO;
        _typeIcon.frame = CGRectMake(15, 14, 22, 22);
        _typeTitle.frame = CGRectMake(_typeIcon.right + 10, 0, 200, 50);
        _typeTitle.textAlignment = NSTextAlignmentLeft;
    }
    _typeIcon.image = Image([info objectForKey:@"image"]);
    _typeTitle.text = [info objectForKey:@"title"];
}

@end
