//
//  LiveBoardToolView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LiveBoardToolView.h"
#import "V5_Constant.h"

#define liveBoardToolButtonWidth 38

@implementation LiveBoardToolView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _toolSelectButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, liveBoardToolButtonWidth, liveBoardToolButtonWidth)];
    [_toolSelectButton setImage:Image(@"tool-select") forState:0];
    [_toolSelectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _toolSelectButton.backgroundColor = HEXCOLOR(0x565656);
    _toolSelectButton.tag = 0;
    [self addSubview:_toolSelectButton];
    
    _toolPenButton = [[UIButton alloc] initWithFrame:CGRectMake(4, _toolSelectButton.bottom + 4, liveBoardToolButtonWidth, liveBoardToolButtonWidth)];
    [_toolPenButton setImage:Image(@"tool-pen") forState:0];
    [_toolPenButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _toolPenButton.backgroundColor = HEXCOLOR(0x565656);
    _toolPenButton.tag = 1;
    [self addSubview:_toolPenButton];
    
    _toolTextButton = [[UIButton alloc] initWithFrame:CGRectMake(4, _toolPenButton.bottom + 4, liveBoardToolButtonWidth, liveBoardToolButtonWidth)];
    [_toolTextButton setImage:Image(@"tool-text") forState:0];
    [_toolTextButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _toolTextButton.backgroundColor = HEXCOLOR(0x565656);
    _toolTextButton.tag = 2;
    [self addSubview:_toolTextButton];
    
    _toolEraserButton = [[UIButton alloc] initWithFrame:CGRectMake(4, _toolTextButton.bottom + 4, liveBoardToolButtonWidth, liveBoardToolButtonWidth)];
    [_toolEraserButton setImage:Image(@"tool-eraser") forState:0];
    [_toolEraserButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _toolEraserButton.backgroundColor = HEXCOLOR(0x565656);
    _toolEraserButton.tag = 3;
    [self addSubview:_toolEraserButton];
    
    _toolColorButton = [[UIButton alloc] initWithFrame:CGRectMake(4, _toolEraserButton.bottom + 4, liveBoardToolButtonWidth, liveBoardToolButtonWidth)];
    [_toolColorButton setImage:Image(@"tool-color") forState:0];
    [_toolColorButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _toolColorButton.backgroundColor = HEXCOLOR(0x565656);
    _toolColorButton.tag = 4;
    [self addSubview:_toolColorButton];
    
}

- (void)buttonClick:(UIButton *)sender {
    
    if(self.selectButton != nil){
        self.selectButton.backgroundColor = [UIColor colorWithHex:0x565656];
    }
    if(sender.tag == 4 && self.selectButton.tag == 4){
        self.selectButton = nil;
    } else {
        sender.backgroundColor = [UIColor colorWithHex:0x141414];
        self.selectButton = sender;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(pressWhiteboardToolIndex:)]) {
        [_delegate pressWhiteboardToolIndex:sender.tag];
    }
}

@end
