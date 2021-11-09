//
//  CCRoomMaxNumCountEditViewController.m
//  CCClassRoom
//
//  Created by cc on 17/4/27.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCRoomMaxNumCountEditViewController.h"
#import "TextFieldUserInfo.h"
#import "LoadingView.h"

@interface CCRoomMaxNumCountEditViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)TextFieldUserInfo    *textFieldUserName;
@property(nonatomic,strong)LoadingView          *loadingView;
@end

@implementation CCRoomMaxNumCountEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = HDClassLocalizeString(@"轮播频率") ;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:HDClassLocalizeString(@"保存") style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = right;
    __weak typeof(self) ws = self;
    [self.view addSubview:self.textFieldUserName];
    self.textFieldUserName.keyboardType = UIKeyboardTypeNumberPad;
    [self.textFieldUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ws.view);
        make.top.mas_equalTo(ws.view).with.offset(74);
        make.height.mas_equalTo(CCGetRealFromPt(92));
    }];
    
    UIView *line1 = [UIView new];
    [self.view addSubview:line1];
    [line1 setBackgroundColor:CCRGBColor(238,238,238)];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.view);
        make.top.mas_equalTo(ws.textFieldUserName.mas_top);
        make.height.mas_equalTo(1);
    }];
    UIView *line2 = [UIView new];
    [self.view addSubview:line2];
    [line2 setBackgroundColor:CCRGBColor(238,238,238)];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.view);
        make.bottom.mas_equalTo(ws.textFieldUserName.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    self.textFieldUserName.text = [NSString stringWithFormat:@"%@", @([[CCStreamerBasic sharedStreamer] getRoomInfo].rotateTime)];
    [self.textFieldUserName becomeFirstResponder];
}

-(TextFieldUserInfo *)textFieldUserName
{
    if(_textFieldUserName == nil) {
        _textFieldUserName = [TextFieldUserInfo new];
        [_textFieldUserName textFieldWithLeftText:@"" placeholder:@"" lineLong:NO text:GetFromUserDefaults(LIVE_USERNAME)];
        _textFieldUserName.delegate = self;
//        [_textFieldUserName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textFieldUserName.tag = 3;
    }
    return _textFieldUserName;
}

//点击返回按钮
- (void)save
{
    if (self.textFieldUserName.text.length == 0 || [self.textFieldUserName.text integerValue] < 10)
    {
        [HDSTool showAlertTitle:@"" msg:HDClassLocalizeString(@"格式不正确") isOneBtn:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
