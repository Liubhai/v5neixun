//
//  AddAddressViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/10/27.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "AddAddressViewController.h"
#import "V5_Constant.h"
#import "AddressModel.h"
#import "Net_Path.h"

@interface Location : NSObject
@property(nonatomic, assign) int num;
@property(nonatomic, strong) NSString* name;
@end
@implementation Location

@end


@interface DivisionData : NSObject @end
@implementation DivisionData

+(NSMutableArray *)areaDivisionJson {
    
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"Area" ofType:@"json"];
    // 将文件内容读取到字符串中，注意编码NSUTF8StringEncoding 防止乱码
    NSString* jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 将字符串写到缓冲区
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* jsonError;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    if (SWNOTEmptyArr(dic)) {
        return [NSMutableArray arrayWithArray:(NSArray *)dic];
    } else {
        return [[NSMutableArray alloc] init];
    }
}

+(NSDictionary*) divisionJson {
    
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"KYDivisionPickerView_list" ofType:@"json"];
    // 将文件内容读取到字符串中，注意编码NSUTF8StringEncoding 防止乱码
    NSString* jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 将字符串写到缓冲区
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* jsonError;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    return dic;
}

+(NSArray*) provinces {
    NSDictionary* dic = [DivisionData divisionJson];
    NSMutableArray* provincesArr = [[NSMutableArray alloc] init];
    // 添加数据
    NSEnumerator *enumerator = [dic keyEnumerator];
    NSString* key;
    while ((key = [enumerator nextObject])) {
        if ([key hasSuffix:@"0000"]) {
            Location* loc = [[Location alloc] init];
            loc.num = [key intValue];
            loc.name = [dic objectForKey: key];
            [provincesArr addObject: loc];
        }
    }
    [provincesArr sortUsingComparator:^NSComparisonResult(Location* obj1, Location* obj2) {
        return [obj1 num] > [obj2 num];
    }];
    return provincesArr;
}

+(NSMutableArray*) citiesWithProvinceNum:(int)provinceNum {
    NSDictionary* dic = [DivisionData divisionJson];
    // 确定索引
    NSString* provinceNumStr = [NSString stringWithFormat:@"%d", provinceNum];
    NSString* provinceNumPrefix = [provinceNumStr substringToIndex:2];
    NSMutableArray* citiesArr = [[NSMutableArray alloc] init];
    // 添加数据
    NSEnumerator *enumerator = [dic keyEnumerator];
    NSString* key;
    while ((key = [enumerator nextObject])) {
        if (([key hasPrefix:provinceNumPrefix]) && !([key hasSuffix:@"0000"]) && ([key hasSuffix:@"00"])) {
            Location* loc = [[Location alloc] init];
            loc.num = [key intValue];
            loc.name = [dic objectForKey: key];
            [citiesArr addObject: loc];
        }
    }
    if (citiesArr.count != 0) {
        [citiesArr sortUsingComparator:^NSComparisonResult(Location* obj1, Location* obj2) {
            return [obj1 num] > [obj2 num];
        }];
    }else {
//        // 直辖市会获取不到下属的地级市，这时以直辖市本身作为地级市返回
//        NSString* key = [provinceNumPrefix stringByAppendingString: @"0000"];
//        Location* loc = [[Location alloc] init];
//        loc.num = [key intValue];
//        loc.name = [dic objectForKey: key];
//        [citiesArr addObject: loc];
        // 加入区级城市
        [citiesArr addObjectsFromArray:[DivisionData countiesWithCityNum:provinceNum]];
    }
    return citiesArr;
}

+(NSMutableArray*) countiesWithCityNum:(int)cityNum {
    NSDictionary* dic = [DivisionData divisionJson];
    // 确定索引
    NSString* cityNumStr = [NSString stringWithFormat:@"%d", cityNum];
    NSString* cityNumPrefix = [[NSString alloc] init];
    
    NSMutableArray* countiesArr = [[NSMutableArray alloc] init];
    
    if ([cityNumStr hasSuffix: @"0000"]) { // 直辖市
        cityNumPrefix = [cityNumStr substringToIndex: 2];
    } else if ([cityNumStr hasSuffix:@"00"]) {
        // 地级市
        cityNumPrefix = [cityNumStr substringToIndex: 4];
    } else {
        // 直辖市下面的区 num 这时候就需要去获取街道地址了
        [countiesArr addObjectsFromArray:[self streetsWithCountyNum:cityNum]];
        return countiesArr;
    }
    
    // 添加数据
    NSEnumerator *enumerator = [dic keyEnumerator];
    NSString* key;
    while ((key = [enumerator nextObject])) {
        if (([key hasPrefix:cityNumPrefix]) && !([key hasSuffix:@"00"])) {
            Location* loc = [[Location alloc] init];
            loc.num = [key intValue];
            loc.name = [dic objectForKey: key];
            [countiesArr addObject: loc];
        }
    }
    [countiesArr sortUsingComparator:^NSComparisonResult(Location* obj1, Location* obj2) {
        return [obj1 num] > [obj2 num];
    }];
    return countiesArr;
}

+(NSMutableArray*) streetsWithCountyNum:(int)countyNum {
    
    NSMutableArray* streetsArr = [[NSMutableArray alloc] init];
    
    // JSON
    NSString* jsonFileName = [NSString stringWithFormat:@"KYDivisionPickerView_%d", countyNum];
    NSString* path  = [[NSBundle mainBundle] pathForResource: jsonFileName ofType:@"json"];
    if (!path) {
        return streetsArr;
    }
    // 将文件内容读取到字符串中，注意编码NSUTF8StringEncoding 防止乱码
    NSString* jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 将字符串写到缓冲区
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* jsonError;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
    // 添加数据
    NSEnumerator *enumerator = [dic keyEnumerator];
    NSString* key;
    while ((key = [enumerator nextObject])) {
        Location* loc = [[Location alloc] init];
        loc.num = [key intValue];
        loc.name = [dic objectForKey: key];
        [streetsArr addObject: loc];
    }
    [streetsArr sortUsingComparator:^NSComparisonResult(Location* obj1, Location* obj2) {
        return [obj1 num] > [obj2 num];
    }];
    return streetsArr;
}

@end

@interface AddAddressViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate> {
    BOOL isTextView;
    CGFloat keyHeight;
    int row0;
    int row1;
    int row2;
    int row3;
    
//    NSString *provinceString;
//    NSString *cityString;
//    NSString *areaString;
//    NSString *streetString;
    
    AddressModel *provinceModel;
    AddressModel *cityModel;
    AddressModel *areaModel;
    AddressModel *streetModel;
    
    BOOL isFirstShow;// 是不是第一次弹起地区选择 NO 是 YES 不是
}

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) UILabel *accountTitle;
@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UIView *line4;

@property (strong, nonatomic) UILabel *nameTitle;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UIView *line2;

@property (strong, nonatomic) UILabel *faceVerifyTitle;
@property (strong, nonatomic) UILabel *faceVerifyStatusLabel;
@property (strong, nonatomic) UIView *line6;
@property (strong, nonatomic) UIButton *faceVerifyRightBtn;
@property (strong, nonatomic) UIButton *chooseAddressBtn;

@property (strong, nonatomic) UILabel *introTitle;
@property (strong, nonatomic) UITextView *introTextView;
@property (strong, nonatomic) UILabel *introTextViewPlaceholder;

@property (strong, nonatomic) UIView *line3;
@property (strong, nonatomic) UIView *morenView;
@property (strong, nonatomic) UIButton *defaultButton;

/** 省市区街道选择 */
@property (strong, nonatomic) UIView *blackBackView;
@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) UILabel *tipTitle;

@property (strong, nonatomic) UIButton *provinceBtn;
@property (strong, nonatomic) UIButton *cityBtn;
@property (strong, nonatomic) UIButton *areaBtn;
@property (strong, nonatomic) UIButton *streetBtn;

@property (strong, nonatomic) NSMutableArray *provinceArray;
@property (strong, nonatomic) NSMutableArray *cityArray;
@property (strong, nonatomic) NSMutableArray *areaArray;
@property (strong, nonatomic) NSMutableArray *streetArray;

@property (strong, nonatomic) UIView *grayLine;
@property (strong, nonatomic) UIView *themeLine;
@property (strong, nonatomic) UIScrollView *areaScrollView;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = EdlineV5_Color.backColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    self.titleLabel.text = @"收货地址";
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [self.rightButton setImage:nil forState:0];
    [self.rightButton setTitle:@"保存" forState:0];
    [self.rightButton setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    self.lineTL.hidden = NO;
    self.lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    
    _provinceArray = [[NSMutableArray alloc] init];
    _cityArray = [[NSMutableArray alloc] init];
    _areaArray = [[NSMutableArray alloc] init];
    _streetArray = [[NSMutableArray alloc] init];
    
    row0 = 0;
    row1 = 0;
    row2 = 0;
    row3 = 0;
//    provinceString = @"";
//    cityString = @"";
//    areaString = @"";
//    streetString = @"";
    
    provinceModel = [[AddressModel alloc] init];
    cityModel = [[AddressModel alloc] init];
    areaModel = [[AddressModel alloc] init];
    streetModel = [[AddressModel alloc] init];
    
    [self makeSubViews];
    [self makeDownView];
    
    [self getLocalAreaInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)makeSubViews {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 0)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
    
    _accountTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    _accountTitle.text = @"收货人";
    _accountTitle.textColor = EdlineV5_Color.textFirstColor;
    _accountTitle.font = SYSTEMFONT(15);
    [_mainScrollView addSubview:_accountTitle];
    
    _accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _accountTitle.top, 200, 50)];
    _accountTextField.textColor = EdlineV5_Color.textSecendColor;
    _accountTextField.font = SYSTEMFONT(15);
    _accountTextField.textAlignment = NSTextAlignmentRight;
    _accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSFontAttributeName:SYSTEMFONT(15),NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    _accountTextField.delegate = self;
    _accountTextField.returnKeyType = UIReturnKeyDone;
    [_mainScrollView addSubview:_accountTextField];
    
    _line4 = [[UIView alloc] initWithFrame:CGRectMake(_accountTitle.left, _accountTitle.bottom, MainScreenWidth - 15, 0.5)];
    _line4.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line4];
    
    _nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(_accountTitle.left, _line4.bottom, _accountTitle.width, 50)];
    _nameTitle.text = @"手机号";
    _nameTitle.textColor = EdlineV5_Color.textFirstColor;
    _nameTitle.font = SYSTEMFONT(15);
    [_mainScrollView addSubview:_nameTitle];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 200, _nameTitle.top, 200, 50)];
    _nameTextField.textColor = EdlineV5_Color.textSecendColor;
    _nameTextField.font = SYSTEMFONT(15);
    _nameTextField.textAlignment = NSTextAlignmentRight;
    _nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSFontAttributeName:SYSTEMFONT(15),NSForegroundColorAttributeName:EdlineV5_Color.textSecendColor}];
    _nameTextField.delegate = self;
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_mainScrollView addSubview:_nameTextField];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(_accountTitle.left, _nameTitle.bottom, MainScreenWidth - 15, 0.5)];
    _line2.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line2];
    
    _faceVerifyTitle = [[UILabel alloc] initWithFrame:CGRectMake(_accountTitle.left, _line2.bottom, _accountTitle.width, 50)];
    _faceVerifyTitle.text = @"地址";
    _faceVerifyTitle.textColor = EdlineV5_Color.textFirstColor;
    _faceVerifyTitle.font = SYSTEMFONT(15);
    [_mainScrollView addSubview:_faceVerifyTitle];
    
    _faceVerifyRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, 0, 30, 30)];
    [_faceVerifyRightBtn setImage:Image(@"list_more") forState:0];
//    [_faceVerifyRightBtn addTarget:self action:@selector(faceVerifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_faceVerifyRightBtn];
    
    _faceVerifyStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, _faceVerifyTitle.top, _faceVerifyRightBtn.left - 5 - 55, 50)];
    _faceVerifyStatusLabel.textColor = EdlineV5_Color.textThirdColor;
    _faceVerifyStatusLabel.font = SYSTEMFONT(15);
    _faceVerifyStatusLabel.textAlignment = NSTextAlignmentRight;
    _faceVerifyStatusLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [_mainScrollView addSubview:_faceVerifyStatusLabel];
    _faceVerifyRightBtn.centerY = _faceVerifyStatusLabel.centerY;
    
    _chooseAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(_faceVerifyStatusLabel.left, _faceVerifyTitle.top, _faceVerifyRightBtn.right - _faceVerifyStatusLabel.left, 50)];
    [_chooseAddressBtn addTarget:self action:@selector(faceVerifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _chooseAddressBtn.backgroundColor = [UIColor clearColor];
    [_mainScrollView addSubview:_chooseAddressBtn];
    
    
    _line6 = [[UIView alloc] initWithFrame:CGRectMake(_accountTitle.left, _faceVerifyTitle.bottom, MainScreenWidth - 15, 0.5)];
    _line6.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_mainScrollView addSubview:_line6];
    
    _introTitle = [[UILabel alloc] initWithFrame:CGRectMake(_accountTitle.left, _line6.bottom, 100, 28 + 21)];
    _introTitle.text = @"详细地址";
    _introTitle.font = SYSTEMFONT(15);
    _introTitle.textColor = EdlineV5_Color.textFirstColor;
    [_mainScrollView addSubview:_introTitle];
    
    _introTextView = [[UITextView alloc] initWithFrame:CGRectMake(95, _introTitle.top + 7, MainScreenWidth - 15 - 95, 78)];
    _introTextView.textColor = EdlineV5_Color.textSecendColor;
    _introTextView.font = SYSTEMFONT(15);
    _introTextView.delegate = self;
    _introTextView.returnKeyType = UIReturnKeyDone;
    [_mainScrollView addSubview:_introTextView];
    
    _introTextViewPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(_introTextView.left, _introTextView.top + 2, _introTextView.width, 30)];
    _introTextViewPlaceholder.text = @" 请输入详细地址";
    _introTextViewPlaceholder.textColor = EdlineV5_Color.textThirdColor;
    _introTextViewPlaceholder.font = SYSTEMFONT(15);
    _introTextViewPlaceholder.userInteractionEnabled = YES;
    UITapGestureRecognizer *placeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeLabelTap:)];
    [_introTextViewPlaceholder addGestureRecognizer:placeTap];
    [_mainScrollView addSubview:_introTextViewPlaceholder];
    
    _line3 = [[UIView alloc] initWithFrame:CGRectMake(0, _introTextView.bottom, MainScreenWidth, 10)];
    _line3.backgroundColor = EdlineV5_Color.backColor;
    [_mainScrollView addSubview:_line3];
    
    _morenView = [[UIView alloc] initWithFrame:CGRectMake(0, _line3.bottom, MainScreenWidth, 60)];
    _morenView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_morenView];
    
    _defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,  15 + 86 + 8 + 20 + 15, 60)];
    [_defaultButton setImage:Image(@"checkbox_def") forState:0];
    [_defaultButton setImage:[Image(@"checkbox_blue") converToMainColor] forState:UIControlStateSelected];
    [_defaultButton addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_defaultButton setTitle:@"设为默认地址" forState:0];
    _defaultButton.titleLabel.font = SYSTEMFONT(14);
    [_defaultButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    _defaultButton.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
    _defaultButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    [_morenView addSubview:_defaultButton];
    _defaultButton.selected = NO;
    
    [_mainScrollView setHeight:_morenView.bottom];
    
    if (SWNOTEmptyDictionary(_currentAddressInfo)) {
        _accountTextField.text = [NSString stringWithFormat:@"%@",_currentAddressInfo[@"consignee"]];
        _nameTextField.text = [NSString stringWithFormat:@"%@",_currentAddressInfo[@"phone"]];
        _faceVerifyStatusLabel.text = [NSString stringWithFormat:@"%@",_currentAddressInfo[@"areatext"]];
        _introTextView.text = [NSString stringWithFormat:@"%@",_currentAddressInfo[@"address"]];
        if (SWNOTEmptyStr(_introTextView.text)) {
            _introTextViewPlaceholder.hidden = YES;
        }
        _defaultButton.selected = [[NSString stringWithFormat:@"%@",_currentAddressInfo[@"default"]] integerValue];
        
        NSArray *codeArray = [NSArray arrayWithArray:_currentAddressInfo[@"areacode"]];
        NSArray *addressArray = [[NSString stringWithFormat:@"%@",_currentAddressInfo[@"areatext"]] componentsSeparatedByString:@" "];
        for (int i = 0; i<codeArray.count; i++) {
            if (i==0) {
                provinceModel.name = addressArray[0];
                provinceModel.code = [NSString stringWithFormat:@"%@",codeArray[0]];
            }
            if (i==1) {
                cityModel.name = addressArray[1];
                cityModel.code = [NSString stringWithFormat:@"%@",codeArray[1]];
            }
            if (i==2) {
                areaModel.name = addressArray[2];
                areaModel.code = [NSString stringWithFormat:@"%@",codeArray[2]];
            }
        }
    }
}

- (void)placeLabelTap:(UIGestureRecognizer *)tap {
    _introTextViewPlaceholder.hidden = YES;
    [_introTextView becomeFirstResponder];
}

- (void)textViewValueDidChanged:(NSNotification *)notice {
    UITextView *textView = (UITextView *)notice.object;
    if (textView != _introTextView) {
        return;
    }
    if (textView.text.length<=0) {
        _introTextViewPlaceholder.hidden = NO;
    } else {
        _introTextViewPlaceholder.hidden = YES;
    }
    
    if (textView.text.length>100) {
        textView.text = [textView.text substringToIndex:100];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [textView setSelectedRange:NSMakeRange(100, 0)];
        });
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _introTextViewPlaceholder.hidden = YES;
    isTextView = YES;
//    if (keyHeight > 0) {
//        CGFloat otherViewOriginY = _introTextView.bottom + 10;
//        CGFloat offSet = MainScreenHeight - MACRO_UI_UPHEIGHT - otherViewOriginY;
//        [_mainScrollView setContentOffset:CGPointMake(0, keyHeight - offSet)];
//    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (_introTextView.text.length <= 0) {
        _introTextViewPlaceholder.hidden = NO;
    } else {
        _introTextViewPlaceholder.hidden = YES;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (textView.text.length >= 100 && SWNOTEmptyStr(text)) {
        if ([text isEqualToString:@"\n"]) {
            [self inputTextResign];
        }
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [self inputTextResign];
        if (_introTextView.text.length <= 0) {
            _introTextViewPlaceholder.hidden = NO;
        }
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self inputTextResign];
        return NO;
    }
    return YES;
}

//- (void)keyboardWillHide:(NSNotification *)notification{
//    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
//    isTextView = NO;
//    keyHeight = 0;
//}
//
//- (void)keyboardWillShow:(NSNotification *)notification{
//    NSValue *endValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    keyHeight = [endValue CGRectValue].size.height;
//    if (isTextView) {
//        CGFloat otherViewOriginY = _introTextView.bottom + 10;
//        CGFloat offSet = MainScreenHeight - MACRO_UI_UPHEIGHT - otherViewOriginY;
//        if (keyHeight > offSet) {
//            [_mainScrollView setContentOffset:CGPointMake(0, [endValue CGRectValue].size.height - offSet)];
//        }
//    }
//}

- (void)inputTextResign {
    [_accountTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_introTextView  resignFirstResponder];
}

- (void)seleteButtonClick:(UIButton *)sender {
    _defaultButton.selected = !_defaultButton.selected;
}

// MARK: - 地址选择按钮点击事件
- (void)faceVerifyButtonClick:(UIButton *)sender {
    [self.view endEditing:NO];
    if (!_blackBackView) {
        [self makeAreaChooseView];
    }
    [self showAnimation];
}

// MARK: - 地址选择器
- (void)makeAreaChooseView {
    if (!_blackBackView) {
        _blackBackView = [[UIView alloc] init];
        _blackBackView.frame = CGRectMake(0,0,MainScreenWidth,MainScreenHeight);
        _blackBackView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3000].CGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAnimation)];
        [_blackBackView addGestureRecognizer:tap];
    }
    _blackBackView.hidden = YES;
    [self.view addSubview:_blackBackView];
    
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 503 + 17)];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.masksToBounds = YES;
        _whiteView.layer.cornerRadius = 17;
    }
    [self.view addSubview:_whiteView];
    
    _tipTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 25 + 13 * 2)];
    _tipTitle.font = SYSTEMFONT(16);
    _tipTitle.textColor = EdlineV5_Color.textFirstColor;
    _tipTitle.text = @"地区选择";
    _tipTitle.centerX = _whiteView.width / 2.0;
    [_whiteView addSubview:_tipTitle];
    
    _grayLine = [[UIView alloc] initWithFrame:CGRectMake(15, 79, _whiteView.width  - 15 * 2, 2)];
    _grayLine.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_whiteView addSubview:_grayLine];
    
    // 间隔28
    _provinceBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 81 - 1 - (14 + 12 * 2), 0, 14 + 12 * 2)];
    _provinceBtn.titleLabel.font = SYSTEMFONT(14);
    [_provinceBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [_provinceBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    [_provinceBtn addTarget:self action:@selector(areaTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:_provinceBtn];
    
    _cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(_provinceBtn.right + 28, _provinceBtn.top, 0, _provinceBtn.height)];
    _cityBtn.titleLabel.font = SYSTEMFONT(14);
    [_cityBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [_cityBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    [_cityBtn addTarget:self action:@selector(areaTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:_cityBtn];
    
    _areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cityBtn.right + 28, _provinceBtn.top, 0, _provinceBtn.height)];
    _areaBtn.titleLabel.font = SYSTEMFONT(14);
    [_areaBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [_areaBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    [_areaBtn addTarget:self action:@selector(areaTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:_areaBtn];
    
    _streetBtn = [[UIButton alloc] initWithFrame:CGRectMake(_areaBtn.right + 28, _provinceBtn.top, 0, _provinceBtn.height)];
    _streetBtn.titleLabel.font = SYSTEMFONT(14);
    [_streetBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
    [_streetBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
    [_streetBtn addTarget:self action:@selector(areaTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:_streetBtn];
    
    _provinceBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _cityBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _areaBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _streetBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    if (SWNOTEmptyStr(provinceModel.name)) {
        [_provinceBtn setTitle:provinceModel.name forState:0];
        if (SWNOTEmptyStr(cityModel.name)) {
            [_cityBtn setTitle:cityModel.name forState:0];
        }
        if (SWNOTEmptyStr(areaModel.name)) {
            [_areaBtn setTitle:areaModel.name forState:0];
        }
        if (SWNOTEmptyStr(streetModel.name)) {
            [_streetBtn setTitle:streetModel.name forState:0];
        }
        _cityBtn.hidden = SWNOTEmptyStr(cityModel.name) ? NO : YES;
        _areaBtn.hidden = SWNOTEmptyStr(areaModel.name) ? NO : YES;
        _streetBtn.hidden = SWNOTEmptyStr(streetModel.name) ? NO : YES;
        
    } else {
        [_provinceBtn setTitle:@"请选择" forState:0];
        _cityBtn.hidden = YES;
        _areaBtn.hidden = YES;
        _streetBtn.hidden = YES;
        
        _cityBtn.selected = NO;
        _areaBtn.selected = NO;
        _streetBtn.selected = NO;
    }
    
    _provinceBtn.selected = YES;
    [self areaTopBtnClick:_provinceBtn];
    
    _areaScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _grayLine.bottom, MainScreenWidth, _whiteView.height - _grayLine.bottom - 17)];
    _areaScrollView.backgroundColor = [UIColor whiteColor];
    _areaScrollView.showsHorizontalScrollIndicator = NO;
    _areaScrollView.showsVerticalScrollIndicator = NO;
    [_whiteView addSubview:_areaScrollView];
    
}

// MARK: - 更新地区列表
- (void)dealAreaUI:(NSMutableArray *)addressArray isWhich:(NSString *)whichType {
    if (_areaScrollView) {
        [_areaScrollView removeAllSubviews];
        for (int i = 0; i < addressArray.count; i++) {
            AddressModel *location = (AddressModel *)addressArray[i];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 34 * i, _whiteView.width, 14 + 20)];
            btn.titleLabel.font = SYSTEMFONT(14);
            [btn setTitle:location.name forState:0];
            [btn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
            [btn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
            btn.tag = i;
//            [btn addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setWidth:[self getButtonWidth:btn]];
            
            UIButton *btnClick = [[UIButton alloc] initWithFrame:CGRectMake(15, 34 * i, _whiteView.width, 14 + 20)];
            btnClick.tag = i + 100;
            [btnClick addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([whichType isEqualToString:@"0"]) {
                if ([location.code isEqualToString:provinceModel.code]) {
                    btn.selected = YES;
                } else {
                    btn.selected = NO;
                }
            }
            
            if ([whichType isEqualToString:@"1"]) {
                if ([location.code isEqualToString:cityModel.code]) {
                    btn.selected = YES;
                } else {
                    btn.selected = NO;
                }
            }
            
            if ([whichType isEqualToString:@"2"]) {
                if ([location.code isEqualToString:areaModel.code]) {
                    btn.selected = YES;
                } else {
                    btn.selected = NO;
                }
            }
            
            if ([whichType isEqualToString:@"3"]) {
                if ([location.code isEqualToString:streetModel.code]) {
                    btn.selected = YES;
                } else {
                    btn.selected = NO;
                }
            }
            
            [_areaScrollView addSubview:btn];
            [_areaScrollView addSubview:btnClick];
        }
        _areaScrollView.contentSize = CGSizeMake(0, addressArray.count * 34);
    }
}

// MARK: - 顶部省市区县街道按钮点击事件
- (void)areaTopBtnClick:(UIButton *)sender {
    if (sender == _provinceBtn) {
        // 选择省 清除 市 地区 街道
        _provinceBtn.selected = YES;
        _cityBtn.selected = NO;
        _areaBtn.selected = NO;
        _streetBtn.selected = NO;
        [self dealAreaUI:_provinceArray isWhich:@"0"];
    } else if (sender == _cityBtn) {
        _provinceBtn.selected = NO;
        _cityBtn.selected = YES;
        _areaBtn.selected = NO;
        _streetBtn.selected = NO;
        [self dealAreaUI:_cityArray isWhich:@"1"];
    } else if (sender == _areaBtn) {
        _provinceBtn.selected = NO;
        _cityBtn.selected = NO;
        _areaBtn.selected = YES;
        _streetBtn.selected = NO;
        [self dealAreaUI:_areaArray isWhich:@"2"];
    } else if (sender == _streetBtn) {
        _provinceBtn.selected = NO;
        _cityBtn.selected = NO;
        _areaBtn.selected = NO;
        _streetBtn.selected = YES;
        [self dealAreaUI:_streetArray isWhich:@"3"];
    }
}

// MARK: - 获取本地json的地区数组信息
- (void)getLocalAreaInfo {
    
    [_provinceArray removeAllObjects];
    [_cityArray removeAllObjects];
    [_areaArray removeAllObjects];
    [_streetArray removeAllObjects];
    
    [_provinceArray addObjectsFromArray:[AddressModel mj_objectArrayWithKeyValuesArray:[DivisionData areaDivisionJson]]];
//    [_cityArray addObjectsFromArray:[DivisionData citiesWithProvinceNum: ((Location *)_provinceArray[row0]).num]];// 默认传参北京市
//    [_areaArray addObjectsFromArray:[DivisionData countiesWithCityNum: ((Location *)_cityArray[row0]).num]];// 默认传参北京市
//    if (SWNOTEmptyArr(_areaArray)) {
//        [_streetArray addObjectsFromArray:[DivisionData streetsWithCountyNum: ((Location *)_areaArray[row0]).num]];// 默认传参（北京市）东城区
//    }
    
}

// MARK: - 获取按钮宽度
- (CGFloat)getButtonWidth:(UIButton *)sender {
    
    if (sender == _provinceBtn || sender == _cityBtn || sender == _areaBtn || sender == _streetBtn) {
        if (sender.titleLabel.text.length > 8) {
            return 100;
        }
    }
    
    return sender.titleLabel.intrinsicContentSize.width;
}

// MARK: - location列表点击选择事件
- (void)locationButtonClick:(UIButton *)sender {
    
    // 选择的是省级或者直辖市
    if (_provinceBtn.selected) {
        AddressModel *location = (AddressModel *)_provinceArray[sender.tag - 100];
        provinceModel = location;
    }
    
    // 选择的是市级或者区级
    if (_cityBtn.selected) {
        AddressModel *location = (AddressModel *)_cityArray[sender.tag - 100];
        cityModel = location;
    }
    
    // 选择的是区县或者街道
    if (_areaBtn.selected) {
        AddressModel *location = (AddressModel *)_areaArray[sender.tag - 100];
        areaModel = location;
        
        // 如果这里就是最后一层就直接隐藏并且将地址传递出去
        if (!SWNOTEmptyArr(location.children)) {
            
            _faceVerifyStatusLabel.text = [NSString stringWithFormat:@"%@ %@ %@",provinceModel.name,cityModel.name,areaModel.name];
            
            [self hiddenAnimation];
            
            return;
        }
    }
    
    // 选择的是街道
    if (_streetBtn.selected) {
        AddressModel *location = (AddressModel *)_streetArray[sender.tag - 100];
        streetModel = location;
        _faceVerifyStatusLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",provinceModel.name,cityModel.name,areaModel.name,location.name];
        
        [self hiddenAnimation];
        return;
    }
    
    [self updateTopButtonStates];
    
    
    // 处理下一级的顶部按钮和列表数据更新
    if (_provinceBtn.selected) {
        _provinceBtn.selected = NO;
        
        _cityBtn.selected = YES;
        _cityBtn.hidden = NO;
        
        _areaBtn.selected = NO;
        _areaBtn.hidden = YES;
        
        _streetBtn.selected = NO;
        _streetBtn.hidden = YES;
        
        // 处理市级数组
        AddressModel *location = (AddressModel *)_provinceArray[sender.tag - 100];
        [_cityArray removeAllObjects];
        [_cityArray addObjectsFromArray:location.children];
        [self dealAreaUI:_cityArray isWhich:@"1"];
        return;
    }
    
    if (_cityBtn.selected) {
        _provinceBtn.selected = NO;
        
        _cityBtn.selected = NO;
        _cityBtn.hidden = NO;
        
        _areaBtn.selected = YES;
        _areaBtn.hidden = NO;
        
        _streetBtn.selected = NO;
        _streetBtn.hidden = YES;
        
        // 处理区县级或者街道数组
        AddressModel *location = (AddressModel *)_cityArray[sender.tag - 100];
        [_areaArray removeAllObjects];
        [_areaArray addObjectsFromArray:location.children];
        [self dealAreaUI:_areaArray isWhich:@"2"];
        return;
    }
    
    if (_areaBtn.selected) {
        _provinceBtn.selected = NO;
        
        _cityBtn.selected = NO;
        _cityBtn.hidden = NO;
        
        _areaBtn.selected = NO;
        _areaBtn.hidden = NO;
        
        _streetBtn.selected = YES;
        _streetBtn.hidden = NO;
        
        // 处理街道数组
        AddressModel *location = (AddressModel *)_areaArray[sender.tag - 100];
        [_streetArray removeAllObjects];
        [_streetArray addObjectsFromArray:location.children];
        [self dealAreaUI:_streetArray isWhich:@"3"];
        return;
    }
}

// MARK: - 更新顶部四个按钮状态
- (void)updateTopButtonStates {
    
    [_provinceBtn setTitle:SWNOTEmptyStr(provinceModel.name) ? provinceModel.name : @"请选择" forState:0];
    [_provinceBtn setWidth:[self getButtonWidth:_provinceBtn]];
    
    [_cityBtn setTitle:SWNOTEmptyStr(cityModel.name) ? cityModel.name : @"请选择" forState:0];
    [_cityBtn setLeft:_provinceBtn.right + 28];
    [_cityBtn setWidth:[self getButtonWidth:_cityBtn]];
    
    [_areaBtn setTitle:SWNOTEmptyStr(areaModel.name) ? areaModel.name : @"请选择" forState:0];
    [_areaBtn setLeft:_cityBtn.right + 28];
    [_areaBtn setWidth:[self getButtonWidth:_areaBtn]];
    
    [_streetBtn setTitle:SWNOTEmptyStr(streetModel.name) ? streetModel.name : @"请选择" forState:0];
    [_streetBtn setLeft:_areaBtn.right + 28];
    [_streetBtn setWidth:[self getButtonWidth:_streetBtn]];
    
}

// MARK: - 弹起选择视图
- (void)showAnimation {
    [self updateTopButtonStates];
    if (!isFirstShow) {
        [self dealAreaUI:_provinceArray isWhich:@"0"];
        isFirstShow = YES;
    }
    _blackBackView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        [_whiteView setTop:MainScreenHeight - 503];
    }];
}

// MARK: - 隐藏选择视图
- (void)hiddenAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        [_whiteView setTop:MainScreenHeight];
    } completion:^(BOOL finished) {
        _blackBackView.hidden = YES;
    }];
}

- (void)rightButtonClick:(id)sender {
    [self saveAddressNet];
}

// MARK: - 保存地址
- (void)saveAddressNet {
    [self.view endEditing:NO];
    if (!SWNOTEmptyStr(_accountTextField.text)) {
        [self showHudInView:self.view showHint:@"请输入的姓名"];
        return;
    }
    
    if (!SWNOTEmptyStr(_nameTextField.text)) {
        [self showHudInView:self.view showHint:@"请输入手机号"];
        return;
    }
    
    if (!SWNOTEmptyStr(_faceVerifyStatusLabel.text)) {
        [self showHudInView:self.view showHint:@"请选择地址"];
        return;
    }
    
    if (!SWNOTEmptyStr(_introTextView.text)) {
        [self showHudInView:self.view showHint:@"请输入详细地址"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:_accountTextField.text forKey:@"consignee"];
    [param setObject:_nameTextField.text forKey:@"phone"];
    [param setObject:[NSString stringWithFormat:@"%@,%@,%@",provinceModel.code,cityModel.code,areaModel.code] forKey:@"areacode"];
    [param setObject:_faceVerifyStatusLabel.text forKey:@"areatext"];
    [param setObject:_introTextView.text forKey:@"address"];
    [param setObject:_defaultButton.selected ? @"1" : @"0" forKey:@"default"];
    if (SWNOTEmptyDictionary(_currentAddressInfo)) {
        [param setObject:[NSString stringWithFormat:@"%@",_currentAddressInfo[@"id"]] forKey:@"id"];
        [Net_API requestPUTWithURLStr:[Net_Path addressUpdateNet] paramDic:param Api_key:nil finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAddressViewUI" object:nil userInfo:@{@"type":@"change",@"addressInfo":param}];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    } else {
        [Net_API requestPOSTWithURLStr:[Net_Path addressAddNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

// MARK: - 顶部按钮优化放在底部
- (void)makeDownView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_TABBAR_HEIGHT, MainScreenWidth, MACRO_UI_TABBAR_HEIGHT)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 6.5, 320, 36)];
    [_submitButton setTitle:@"保存" forState:0];
    _submitButton.titleLabel.font = SYSTEMFONT(16);
    _submitButton.backgroundColor = EdlineV5_Color.themeColor;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height / 2.0;
    _submitButton.centerX = _bottomView.width/2.0;
    [_submitButton addTarget:self action:@selector(saveAddress:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_submitButton];
}

// MARK: - 添加新地址
- (void)saveAddress:(UIButton *)sender {
    [self saveAddressNet];
}

// MARK: - 关闭所有输入框
- (void)hiddenKeyboard {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
