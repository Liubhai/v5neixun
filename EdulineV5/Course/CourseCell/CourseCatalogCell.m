//
//  CourseCatalogCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCatalogCell.h"

@implementation CourseCatalogCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier isClassNew:(BOOL)isClassNew cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow courselayer:(NSString *)courselayer isMainPage:(BOOL)isMainPage {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _isClassNew = isClassNew;
        _cellSection = cellSection;
        _cellRow = cellRow;
        _courselayer = courselayer;
        _isMainPage = isMainPage;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _typeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 32, 16)];
    _typeIcon.centerY = 50 / 2.0;
    _typeIcon.image = Image(@"contents_icon_video");
    [self addSubview:_typeIcon];
    
    _lockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_typeIcon.right + 5, 0, 14, 16)];
    _lockIcon.centerY = 50 / 2.0;
    _lockIcon.image = Image(@"contents_icon_lock");
    [self addSubview:_lockIcon];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lockIcon.right + 5, 0, 150, 50)];
    _titleLabel.text = @"第三课时课时名称";
    _titleLabel.textColor = EdlineV5_Color.textSecendColor;
    _titleLabel.font = SYSTEMFONT(14);
    [self addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + 10, 0, 100, 50)];
    _priceLabel.text = @"¥199";
    _priceLabel.textColor = EdlineV5_Color.textSecendColor;
    _priceLabel.font = SYSTEMFONT(14);
    [self addSubview:_priceLabel];
    
    _courseRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, 0, 30, 50)];
    [_courseRightBtn setImage:Image(@"contents_down") forState:0];
    [_courseRightBtn setImage:Image(@"contents_up") forState:UIControlStateSelected];
    [self addSubview:_courseRightBtn];
    
    _isLearningIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 16, 0, 16, 17)];
    _isLearningIcon.centerY = 50 / 2.0;
    _isLearningIcon.image = Image(@"comment_play");
    [self addSubview:_isLearningIcon];
    
    _learnTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 80, 0, 80, 50)];
    _learnTimeLabel.text = @"学习至00:32:23";
    _learnTimeLabel.font = SYSTEMFONT(11);
    _learnTimeLabel.textAlignment = NSTextAlignmentRight;
    _learnTimeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self addSubview:_learnTimeLabel];
    
    _learnIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_learnTimeLabel.left - 8 - 14, 0, 14, 14)];
    _learnIcon.centerY = 50 / 2.0;
    _learnIcon.image = Image(@"comment_his_icon");
    [self addSubview:_learnIcon];
    
    // 当目录为3层的时候 这个实际上是二层视图 table是三层视图
    // 当目录为2层的时候 这个实际上是二层视图 没有table
    // 当目录为1层的时候 这个实际上是一层视图 没有table是三层视图
    if ([_courselayer isEqualToString:@"3"]) {
        _typeIcon.hidden = YES;
        _lockIcon.hidden = YES;
        _priceLabel.hidden = YES;
        _learnIcon.hidden = YES;
        _learnTimeLabel.hidden = YES;
        _isLearningIcon.hidden = YES;
        [_titleLabel setLeft:15 + 3 + 8];
        
        _cellTableViewSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, MainScreenWidth, 0.5)];
        _cellTableViewSpace.backgroundColor = EdlineV5_Color.fengeLineColor;
        [self addSubview:_cellTableViewSpace];
        _dataSource = [NSMutableArray new];
        _cellTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth, 3 * 50)];
        _cellTableView.dataSource = self;
        _cellTableView.delegate = self;
        _cellTableView.showsVerticalScrollIndicator = NO;
        _cellTableView.showsHorizontalScrollIndicator = NO;
        _cellTableView.bounces = NO;
        _cellTableView.rowHeight = 50;
        [self addSubview:_cellTableView];
    } else if ([_courselayer isEqualToString:@"1"]) {
        _courseRightBtn.hidden = YES;
    } else if ([_courselayer isEqualToString:@"2"]) {
        _courseRightBtn.hidden = YES;
    }
    
    if (_isMainPage) {
        _isLearningIcon.hidden = YES;
        _learnIcon.hidden = YES;
        _learnTimeLabel.hidden = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuse = @"classnew2";
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
    if (!cell) {
        cell = [[CourseCatalogCell alloc] initWithReuseIdentifier:cellReuse isClassNew:NO cellSection:0 cellRow:0 courselayer:@"1" isMainPage:_isMainPage];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
