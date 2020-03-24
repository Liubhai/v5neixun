//
//  CourseCatalogCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCatalogCell.h"

@implementation CourseCatalogCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier isClassNew:(BOOL)isClassNew cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow courselayer:(NSString *)courselayer isMainPage:(BOOL)isMainPage allLayar:(nonnull NSString *)allLayar {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _isClassNew = isClassNew;
        _cellSection = cellSection;
        _cellRow = cellRow;
        _courselayer = courselayer;
        _isMainPage = isMainPage;
        _allLayar = allLayar;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _blueView = [[UIView alloc] initWithFrame:CGRectMake(15, 17, 3, 16)];
    _blueView.backgroundColor = EdlineV5_Color.themeColor;
    _blueView.layer.masksToBounds = YES;
    _blueView.layer.cornerRadius = 2;
    [self addSubview:_blueView];
    
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
    [_courseRightBtn addTarget:self action:@selector(courseRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    if ([_allLayar isEqualToString:@"1"]) {
        _blueView.hidden = YES;
        _courseRightBtn.hidden = YES;
        if (_isMainPage) {
            _learnIcon.hidden = YES;
            _learnTimeLabel.hidden = YES;
        }
    } else if ([_allLayar isEqualToString:@"2"]) {
        _blueView.hidden = YES;
        if ([_courselayer isEqualToString:@"2"]) {
            _courseRightBtn.hidden = NO;
            _typeIcon.hidden = YES;
            _lockIcon.hidden = YES;
            _priceLabel.hidden = YES;
            _learnIcon.hidden = YES;
            _learnTimeLabel.hidden = YES;
            _isLearningIcon.hidden = YES;
            [_titleLabel setLeft:15];
        } else if ([_courselayer isEqualToString:@"3"]) {
            _courseRightBtn.hidden = YES;
        }
    } else if ([_allLayar isEqualToString:@"3"]) {
        if ([_courselayer isEqualToString:@"1"] || [_courselayer isEqualToString:@"2"]) {
            _blueView.hidden = [_courselayer isEqualToString:@"1"] ? NO : YES;
            _courseRightBtn.hidden = NO;
            _typeIcon.hidden = YES;
            _lockIcon.hidden = YES;
            _priceLabel.hidden = YES;
            _learnIcon.hidden = YES;
            _learnTimeLabel.hidden = YES;
            _isLearningIcon.hidden = YES;
            [_titleLabel setLeft:([_courselayer isEqualToString:@"1"] ? (15 + 3 + 8) : 15)];
        } else if ([_courselayer isEqualToString:@"3"]) {
            _courseRightBtn.hidden = YES;
            _blueView.hidden = YES;
        }
    }
    
    
    if ([_courselayer isEqualToString:@"1"] || [_courselayer isEqualToString:@"2"]) {
        _cellTableViewSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, MainScreenWidth, 0.5)];
        _cellTableViewSpace.backgroundColor = EdlineV5_Color.fengeLineColor;
        [self addSubview:_cellTableViewSpace];
        _dataSource = [NSMutableArray new];
        _cellTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth, 0)];
        _cellTableView.dataSource = self;
        _cellTableView.delegate = self;
        _cellTableView.showsVerticalScrollIndicator = NO;
        _cellTableView.showsHorizontalScrollIndicator = NO;
        _cellTableView.bounces = NO;
        _cellTableView.rowHeight = 50;
        _cellTableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_cellTableView];
    }
    
    if (_isMainPage) {
        _isLearningIcon.hidden = YES;
        _learnIcon.hidden = YES;
        _learnTimeLabel.hidden = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listFinalModel.child.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.cellTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_courselayer isEqualToString:@"1"]) {
        static NSString *cellReuse = @"classnew1";
        CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
        if (!cell) {
            cell = [[CourseCatalogCell alloc] initWithReuseIdentifier:cellReuse isClassNew:NO cellSection:0 cellRow:0 courselayer:@"2" isMainPage:_isMainPage allLayar:_allLayar];
        }
        cell.delegate = self;
        CourseListModelFinal *model = _listFinalModel.child[indexPath.row];
        model.allLayar = _allLayar;
        model.courselayer = @"2";
        model.cellIndex = indexPath;
        [cell setListInfo:model];
        return cell;
    }
    static NSString *cellReuse = @"classnew2";
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
    if (!cell) {
        cell = [[CourseCatalogCell alloc] initWithReuseIdentifier:cellReuse isClassNew:NO cellSection:0 cellRow:0 courselayer:@"3" isMainPage:_isMainPage allLayar:_allLayar];
    }
    cell.delegate = self;
    CourseListModelFinal *model = _listFinalModel.child[indexPath.row];
    model.allLayar = _allLayar;
    model.courselayer = @"3";
    model.cellIndex = indexPath;
    [cell setListInfo:model];
    [cell setListInfo:model];
    return cell;
}

- (void)setListInfo:(CourseListModelFinal *)model {
    _listFinalModel = model;
    _listModel = model.model;
    
    _titleLabel.text = model.model.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.model.price];
    
    if ([_allLayar isEqualToString:@"1"]) {
        [self setHeight:50];
    } else if ([_allLayar isEqualToString:@"2"]) {
        if ([_courselayer isEqualToString:@"2"]) {
            if (model.isExpanded) {
                [self setHeight:50 + model.child.count * 50];
                [_cellTableView setHeight:model.child.count * 50];
                _cellTableView.hidden = NO;
            } else {
                [self setHeight:50];
                [_cellTableView setHeight:0];
                _cellTableView.hidden = YES;
            }
        } else if ([_courselayer isEqualToString:@"3"]) {
            [self setHeight:50];
        }
    } else if ([_allLayar isEqualToString:@"3"]) {
        if ([_courselayer isEqualToString:@"1"]) {
            if (model.isExpanded) {
                CGFloat cellHeight = 50;
                for (CourseListModelFinal *object in model.child) {
                    if (SWNOTEmptyArr(object.child)) {
                        if (object.isExpanded) {
                            cellHeight = cellHeight + (object.child.count + 1) * 50;
                        } else {
                            cellHeight = cellHeight + 50;
                        }
//                        for (CourseListModelFinal *object2 in object.child) {
//                            if (object2.isExpanded) {
//                                cellHeight = cellHeight + (object2.child.count + 1) * 50;
//                            } else {
//                                cellHeight = cellHeight + 50;
//                            }
//                        }
                    } else {
                        cellHeight = cellHeight + 50;
                    }
                }
                [self setHeight:cellHeight];
                [_cellTableView setHeight:cellHeight - 50];
                _cellTableView.hidden = NO;
            } else {
                [self setHeight:50];
                [_cellTableView setHeight:0];
                _cellTableView.hidden = YES;
            }
        } else if ([_courselayer isEqualToString:@"2"]) {
            if (model.isExpanded) {
                [self setHeight:50 + model.child.count * 50];
                [_cellTableView setHeight:model.child.count * 50];
                _cellTableView.hidden = NO;
            } else {
                [self setHeight:50];
                [_cellTableView setHeight:0];
                _cellTableView.hidden = YES;
            }
        } else if ([_courselayer isEqualToString:@"3"]) {
            [self setHeight:50];
            [_cellTableView setHeight:0];
            _cellTableView.hidden = YES;
        }
    }
    [_cellTableView reloadData];
}

- (void)courseRightButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(listChangeUpAndDown:listModel:panrentListModel:)]) {
        if ([_courselayer isEqualToString:@"2"] && [_allLayar isEqualToString:@"3"]) {
            CourseCatalogCell *cell = (CourseCatalogCell *)_cellTableView.superview;
            [_delegate listChangeUpAndDown:sender listModel:_listFinalModel panrentListModel:cell.listFinalModel];
        } else {
            [_delegate listChangeUpAndDown:sender listModel:_listFinalModel panrentListModel:nil];
        }
    }
}

- (void)listChangeUpAndDown:(UIButton *)sender listModel:(CourseListModelFinal *)model panrentListModel:(CourseListModelFinal *)panrentModel {
    if (_delegate && [_delegate respondsToSelector:@selector(listChangeUpAndDown:listModel:panrentListModel:)]) {
        CourseCatalogCell *cell = (CourseCatalogCell *)sender.superview;
        if ([_courselayer isEqualToString:@"1"] && [_allLayar isEqualToString:@"3"]) {
            [_delegate listChangeUpAndDown:sender listModel:cell.listFinalModel panrentListModel:_listFinalModel];
        } else {
            [_delegate listChangeUpAndDown:sender listModel:cell.listFinalModel panrentListModel:nil];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
