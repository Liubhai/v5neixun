//
//  LivePageControlView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LivePageControlView.h"
#import "V5_Constant.h"

#define livePageControlButtonWidth 46

@implementation LivePageControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _firstPageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, livePageControlButtonWidth, livePageControlButtonWidth)];
    [_firstPageButton setImage:Image(@"page-first") forState:0];
    [_firstPageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_firstPageButton];
    
    _previousPageButton = [[UIButton alloc] initWithFrame:CGRectMake(_firstPageButton.right, 0, livePageControlButtonWidth, livePageControlButtonWidth)];
    [_previousPageButton setImage:Image(@"page-prev") forState:0];
    [_previousPageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_previousPageButton];
    
    _pageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_previousPageButton.right, 0, 66, livePageControlButtonWidth)];
    _pageCountLabel.font = SYSTEMFONT(14);
    _pageCountLabel.textColor = EdlineV5_Color.textFirstColor;
    _pageCountLabel.backgroundColor = HEXCOLOR(0xF2F4F5);
    _pageCountLabel.text = @"1/1";
    _pageCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_pageCountLabel];
    
    _nextPageButton = [[UIButton alloc] initWithFrame:CGRectMake(_pageCountLabel.right, 0, livePageControlButtonWidth, livePageControlButtonWidth)];
    [_nextPageButton setImage:Image(@"icon-next") forState:0];
    [_nextPageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextPageButton];
    
    _lastPageButton = [[UIButton alloc] initWithFrame:CGRectMake(_nextPageButton.right, 0, livePageControlButtonWidth, livePageControlButtonWidth)];
    [_lastPageButton setImage:Image(@"page-end") forState:0];
    [_lastPageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_lastPageButton];
    
}

- (void)buttonClick:(UIButton *)sender {
    if (sender ==_previousPageButton) {
        if (_delegate && [_delegate respondsToSelector:@selector(previousPagePress)]) {
            [_delegate previousPagePress];
        }
    } else if (sender == _firstPageButton) {
        if (_delegate && [_delegate respondsToSelector:@selector(firstPagePress)]) {
            [_delegate firstPagePress];
        }
    } else if (sender == _nextPageButton) {
        if (_delegate && [_delegate respondsToSelector:@selector(nextPagePress)]) {
            [_delegate nextPagePress];
        }
    } else if (sender == _lastPageButton) {
        if (_delegate && [_delegate respondsToSelector:@selector(lastPagePress)]) {
            [_delegate lastPagePress];
        }
    }
    
}

@end
