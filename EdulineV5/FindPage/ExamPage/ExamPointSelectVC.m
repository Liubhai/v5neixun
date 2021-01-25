//
//  ExamPointSelectVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/28.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "ExamPointSelectVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ExamPointModel.h"

@interface ExamPointSelectVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIButton *resetButton;//清空筛选
@property (strong, nonatomic) UIButton *sureButton;//开始学习
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) NSMutableArray *firstArray;
@property (strong, nonatomic) NSMutableArray *secondArray;
@property (strong, nonatomic) NSMutableArray *thirdArray;

@property (strong, nonatomic) NSMutableArray *selectedArray;

@end

@implementation ExamPointSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _firstArray = [NSMutableArray new];
    _secondArray = [NSMutableArray new];
    _thirdArray = [NSMutableArray new];
    _selectedArray = [NSMutableArray new];
    
    _lineTL.hidden = NO;
    _lineTL.backgroundColor = EdlineV5_Color.fengeLineColor;
    _titleLabel.text = @"知识点练习";
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - (MACRO_UI_UPHEIGHT + 44 + MACRO_UI_SAFEAREA))];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
    
    [self getClassTypeData];
    
    [self makeBottomView];
}

- (void)makeBottomView {
    _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - (MACRO_UI_SAFEAREA + 44), MainScreenWidth, MACRO_UI_SAFEAREA + 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 44)];
    [_resetButton setTitle:@"清空筛选" forState:0];
    [_resetButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    _resetButton.titleLabel.font = SYSTEMFONT(16);
    [_resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_resetButton];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(_resetButton.right, 0, MainScreenWidth / 2.0, 44)];
    [_sureButton setTitle:@"开始答题" forState:0];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:0];
    _sureButton.backgroundColor = EdlineV5_Color.themeColor;
    _sureButton.titleLabel.font = SYSTEMFONT(16);
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_sureButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 1)];
    line.backgroundColor = EdlineV5_Color.backColor;
    [_bottomView addSubview:line];
}

- (void)getClassTypeData {
    
    NSMutableArray *passArray = [NSMutableArray new];
    for (int i = 0; i<10; i++) {
        NSMutableDictionary *pass = [NSMutableDictionary new];
        [pass setObject:@"1" forKey:@"id"];
        [pass setObject:@"这是知识点二级" forKey:@"title"];
        [pass setObject:@"1" forKey:@"isExpend"];
        NSMutableArray *secendArrayPass = [NSMutableArray new];
        for (int j = 0; j<5; j++) {
            NSDictionary *ps = @{@"id":@"1",@"child":@[],@"title":@"二级分类"};
            [secendArrayPass addObject:ps];
        }
        [pass setObject:[NSArray arrayWithArray:secendArrayPass] forKey:@"child"];
        [passArray addObject:pass];
    }
    [_firstArray addObjectsFromArray:[NSArray arrayWithArray:[ExamPointModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithArray:passArray]]]];
    if (SWNOTEmptyArr(_firstArray)) {
        [self makeScrollViewSubView:_firstArray];
    }
}

// MARK: - 布局右边分类视图
- (void)makeScrollViewSubView:(NSMutableArray *)selectedInfo {
    if (_mainScrollView) {
        [_mainScrollView removeAllSubviews];
    }
    
    CGFloat hotYY = 20;
    CGFloat secondSpace = 6;
    [_secondArray removeAllObjects];
    [_secondArray addObjectsFromArray:selectedInfo];
    if (SWNOTEmptyArr(_secondArray)) {
        for (int j = 0; j < _secondArray.count; j++) {
            UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, hotYY, MainScreenWidth, 0)];
            hotView.backgroundColor = [UIColor whiteColor];
            hotView.tag = 10 + j;
            [_mainScrollView addSubview:hotView];
            
            NSString *secondTitle = [NSString stringWithFormat:@"%@",((ExamPointModel *)_secondArray[j]).title];//@"热门搜索";
            CGFloat secondBtnWidth = [secondTitle sizeWithFont:SYSTEMFONT(15)].width + 4 + 14;
            UIButton *secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, secondBtnWidth, 32)];
            secondBtn.tag = 100 + j;
            [secondBtn setImage:Image(@"contents_down") forState:0];
            [secondBtn setImage:Image(@"contents_up") forState:UIControlStateSelected];
            [secondBtn setTitle:secondTitle forState:0];
            [secondBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
//            [secondBtn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
            secondBtn.titleLabel.font = SYSTEMFONT(15);
            [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -secondBtn.currentImage.size.width, 0, secondBtn.currentImage.size.width)];
            [secondBtn setImageEdgeInsets:UIEdgeInsetsMake(0, secondBtnWidth-14, 0, -(secondBtnWidth - 14))];
            [secondBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            secondBtn.selected = ((ExamPointModel *)_secondArray[j]).isExpend;
            [hotView addSubview:secondBtn];
            [_thirdArray removeAllObjects];
            if (!((ExamPointModel *)_secondArray[j]).isExpend) {
                [hotView setHeight:secondBtn.bottom];
                hotYY = hotView.bottom + 20;
                if (j == _secondArray.count - 1) {
                    _mainScrollView.contentSize = CGSizeMake(0, hotYY);
                }
                continue;
            }
            if (SWNOTEmptyArr(((ExamPointModel *)_secondArray[j]).child)) {
                [_thirdArray addObjectsFromArray:[NSArray arrayWithArray:((ExamPointModel *)_secondArray[j]).child]];
            }
            if (_thirdArray.count) {
                CGFloat topSpacee = 20.0;
                CGFloat rightSpace = 15.0;
                CGFloat btnInSpace = 10.0;
                CGFloat XX = 15.0;
                CGFloat YY = 20.0 + secondBtn.bottom;
                CGFloat btnHeight = 32.0;
                for (int i = 0; i<_thirdArray.count; i++) {
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, 0, btnHeight)];
                    btn.tag = 400 + i;
                    [btn addTarget:self action:@selector(thirdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitle:[NSString stringWithFormat:@"%@",((ExamPointModel *)_thirdArray[i]).title] forState:0];
                    btn.titleLabel.font = SYSTEMFONT(14);
                    [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
                    [btn setTitleColor:EdlineV5_Color.themeColor forState:UIControlStateSelected];
                    btn.backgroundColor = EdlineV5_Color.backColor;
                    btn.selected = ((ExamPointModel *)_thirdArray[i]).selected;
                    if (btn.selected) {
                        btn.backgroundColor = EdlineV5_Color.buttonWeakeColor;
                    } else {
                        btn.backgroundColor = EdlineV5_Color.backColor;
                    }
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = btnHeight / 2.0;
                    CGFloat btnWidth = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + btnInSpace * 2;
                    if ((btnWidth + XX) > (MainScreenWidth - 15)) {
                        XX = 15.0;
                        YY = YY + topSpacee + btnHeight;
                    }
                    btn.frame = CGRectMake(XX, YY, btnWidth, btnHeight);
                    XX = btn.right + rightSpace;
                    if (i == _thirdArray.count - 1) {
                        [hotView setHeight:btn.bottom];
                    }
                    [hotView addSubview:btn];
                }
            } else {
                [hotView setHeight:secondBtn.bottom];
            }
            hotYY = hotView.bottom + 20;
            if (j == _secondArray.count - 1) {
                _mainScrollView.contentSize = CGSizeMake(0, hotYY);
            }
        }
    } else {
        _mainScrollView.contentSize = CGSizeMake(0, hotYY);
    }
}

- (void)secondBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    ExamPointModel *model = (ExamPointModel *)_firstArray[sender.tag - 100];
    model.isExpend = sender.selected;
    [_firstArray replaceObjectAtIndex:sender.tag - 100 withObject:model];
    [self makeScrollViewSubView:_firstArray];
}

- (void)thirdBtnClick:(UIButton *)sender {
    UIView *view = (UIView *)sender.superview;
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = EdlineV5_Color.buttonWeakeColor;
    } else {
        sender.backgroundColor = EdlineV5_Color.backColor;
    }

    // 获取第二层model
    NSMutableArray *passSecond = [NSMutableArray arrayWithArray:_firstArray];
    ExamPointModel *secondModel = (ExamPointModel *)passSecond[view.tag - 10];
    // 获取第三层model 并修改model选中状态
    NSMutableArray *passThird = [NSMutableArray arrayWithArray:secondModel.child];
    ExamPointModel *thirdModel = (ExamPointModel *)passThird[sender.tag - 400];
    thirdModel.selected = sender.selected;
    
    // 置换第三层model
    [passThird replaceObjectAtIndex:sender.tag - 400 withObject:thirdModel];
    
    // 修改并置换第二层m
    secondModel.child = [NSArray arrayWithArray:passThird];
    [passSecond replaceObjectAtIndex:view.tag - 10 withObject:secondModel];
    
    _firstArray = [NSMutableArray arrayWithArray:passSecond];
    [self makeScrollViewSubView:_firstArray];
}

- (void)sureButtonClick {
    NSMutableArray *teacherCateGory = [NSMutableArray new];
    for (int i = 0; i<_firstArray.count; i++) {
        ExamPointModel *model = (ExamPointModel *)_firstArray[i];
        for (int j = 0; j<model.child.count; j++) {
            ExamPointModel *secondModel = (ExamPointModel *)model.child[j];
            if (secondModel.selected) {
                NSMutableArray *pass = [NSMutableArray new];
                [pass addObject:model];
                [pass addObject:secondModel];
                [teacherCateGory addObject:pass];
            }
        }
    }
    NSLog(@"已选择知识点分类个数为 = %@ 个",@(teacherCateGory.count));
//    if (_delegate && [_delegate respondsToSelector:@selector(chooseCategoryArray:)]) {
//        [_delegate chooseCategoryArray:teacherCateGory];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)resetButtonClick {
    for (int i = 0; i<_firstArray.count; i++) {
        ExamPointModel *model = (ExamPointModel *)_firstArray[i];
        NSMutableArray *pass = [NSMutableArray arrayWithArray:model.child];
        for (int j = 0; j<pass.count; j++) {
            ExamPointModel *secondModel = (ExamPointModel *)pass[j];
            secondModel.selected = NO;
            [pass replaceObjectAtIndex:j withObject:secondModel];
        }
        model.child = [NSArray arrayWithArray:pass];
        [_firstArray replaceObjectAtIndex:i withObject:model];
    }
    [self makeScrollViewSubView:_firstArray];
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
