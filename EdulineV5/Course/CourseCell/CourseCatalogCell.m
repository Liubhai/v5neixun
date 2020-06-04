//
//  CourseCatalogCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCatalogCell.h"

@implementation CourseCatalogCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier isClassNew:(BOOL)isClassNew cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow courselayer:(NSString *)courselayer isMainPage:(BOOL)isMainPage allLayar:(nonnull NSString *)allLayar isLive:(BOOL)isLive {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _isClassNew = isClassNew;
        _cellSection = cellSection;
        _cellRow = cellRow;
        _courselayer = courselayer;
        _isMainPage = isMainPage;
        _allLayar = allLayar;
        _isLive = isLive;
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
    _typeIcon.hidden = _isLive;
    [self addSubview:_typeIcon];
    
    _lockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 14, 0, 14, 16)];
    _lockIcon.centerY = 50 / 2.0;
    _lockIcon.image = Image(@"contents_icon_lock");
    _lockIcon.hidden = YES;
    [self addSubview:_lockIcon];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_isLive ? 15 : (_typeIcon.right + 5), 0, 150, 50)];
    _titleLabel.text = @"第三课时课时名称";
    _titleLabel.textColor = EdlineV5_Color.textSecendColor;
    _titleLabel.font = SYSTEMFONT(14);
    [self addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + 10, (50 - 16) / 2.0, 100, 16)];
    _priceLabel.text = @"¥199";
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    _priceLabel.layer.masksToBounds = YES;
    _priceLabel.layer.cornerRadius = 1;
    _priceLabel.layer.borderColor = EdlineV5_Color.faildColor.CGColor;
    _priceLabel.layer.borderWidth = 1;
    _priceLabel.font = SYSTEMFONT(14);
    [self addSubview:_priceLabel];
    
    _courseRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, 0, 30, 50)];
    [_courseRightBtn setImage:Image(@"contents_down") forState:0];
    [_courseRightBtn setImage:Image(@"contents_up") forState:UIControlStateSelected];
    [_courseRightBtn addTarget:self action:@selector(courseRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_courseRightBtn];
    
    _isLearningIcon = [[playAnimationView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 16, 0, 16, 17)];
    _isLearningIcon.centerY = 50 / 2.0;
    _isLearningIcon.image = Image(@"comment_playing");
    _isLearningIcon.animationImages = @[Image(@"playing1"),Image(@"playing2")];
    _isLearningIcon.highlightedAnimationImages = @[Image(@"playing1"),Image(@"playing2")];
    _isLearningIcon.animationDuration = 0.4;
    [self addSubview:_isLearningIcon];
    
    _learnTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 85, 0, 85, 50)];
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
            if (!_isMainPage) {
                if (_listFinalModel.isPlaying) {
                    _learnIcon.hidden = YES;
                    _learnTimeLabel.hidden = YES;
                    _isLearningIcon.hidden = NO;
                } else {
                    _learnIcon.hidden = NO;
                    _learnTimeLabel.hidden = NO;
                    _isLearningIcon.hidden = YES;
                }
            }
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
            if (!_isMainPage) {
                if (_listFinalModel.isPlaying) {
                    _learnIcon.hidden = YES;
                    _learnTimeLabel.hidden = YES;
                    _isLearningIcon.hidden = NO;
                } else {
                    _learnIcon.hidden = NO;
                    _learnTimeLabel.hidden = NO;
                    _isLearningIcon.hidden = YES;
                }
            }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_courselayer isEqualToString:@"1"]) {
        
    } else if ([_courselayer isEqualToString:@"2"]) {
        // 当前cell 类型是第二层样式 那么这个 table 就是最后一层 方可点击
        if ([_allLayar isEqualToString:@"2"]) {
            CourseCatalogCell *cell = (CourseCatalogCell *)[self.cellTableView cellForRowAtIndexPath:indexPath];
            if (_delegate && [_delegate respondsToSelector:@selector(playCellVideo:currentCellIndex:panrentCellIndex:superCellIndex:currentCell:)]) {
                [_delegate playCellVideo:_listFinalModel.child[indexPath.row] currentCellIndex:indexPath panrentCellIndex:_listFinalModel.cellIndex superCellIndex:nil currentCell:cell];
            }
        } else if ([_allLayar isEqualToString:@"3"]) {
            CourseCatalogCell *cell = (CourseCatalogCell *)self.superview.superview;
            CourseCatalogCell *currentcell = (CourseCatalogCell *)[self.cellTableView cellForRowAtIndexPath:indexPath];
            if (_delegate && [_delegate respondsToSelector:@selector(playCellVideo:currentCellIndex:panrentCellIndex:superCellIndex:currentCell:)]) {
                [_delegate playCellVideo:_listFinalModel.child[indexPath.row] currentCellIndex:indexPath panrentCellIndex:_listFinalModel.cellIndex superCellIndex:cell.listFinalModel.cellIndex currentCell:currentcell];
            }
        }
    } else if ([_courselayer isEqualToString:@"3"]) {
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_courselayer isEqualToString:@"1"]) {
        static NSString *cellReuse = @"classnew1";
        CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
        if (!cell) {
            cell = [[CourseCatalogCell alloc] initWithReuseIdentifier:cellReuse isClassNew:NO cellSection:0 cellRow:0 courselayer:@"2" isMainPage:_isMainPage allLayar:_allLayar isLive:_isLive];
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
        cell = [[CourseCatalogCell alloc] initWithReuseIdentifier:cellReuse isClassNew:NO cellSection:0 cellRow:0 courselayer:@"3" isMainPage:_isMainPage allLayar:_allLayar isLive:_isLive];
    }
    cell.delegate = self;
    CourseListModelFinal *model = _listFinalModel.child[indexPath.row];
    model.allLayar = _allLayar;
    model.courselayer = @"3";
    model.cellIndex = indexPath;
    [cell setListInfo:model];
    return cell;
}

- (void)setListInfo:(CourseListModelFinal *)model {
    _listFinalModel = model;
    _listModel = model.model;
    
    _titleLabel.text = model.model.title;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.model.price];
    CGFloat priceWidth = [_priceLabel.text sizeWithFont:_priceLabel.font].width + 4;
    [_priceLabel setWidth:priceWidth];
    [_priceLabel setRight:_titleLabel.right + 10];
    if ([model.model.price floatValue]>0) {
        _priceLabel.hidden = NO;
    } else {
        _priceLabel.hidden = YES;
    }
    
    if ([_allLayar isEqualToString:@"1"]) {
        [self setHeight:50];
        if (!_isMainPage) {
            [_priceLabel setRight:_learnIcon.left - 5];
            if (_listFinalModel.isPlaying) {
                _learnIcon.hidden = YES;
                _learnTimeLabel.hidden = YES;
                _isLearningIcon.hidden = NO;
                [self setAnimation:_isLearningIcon];
            } else {
                _learnIcon.hidden = NO;
                _learnTimeLabel.hidden = NO;
                _isLearningIcon.hidden = YES;
                [_isLearningIcon stopAnimating];
            }
        }
    } else if ([_allLayar isEqualToString:@"2"]) {
        if ([_courselayer isEqualToString:@"2"]) {
            _priceLabel.hidden = YES;
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
            if (!_isMainPage) {
                [_priceLabel setRight:_learnIcon.left - 5];
                if (_listFinalModel.isPlaying) {
                    _learnIcon.hidden = YES;
                    _learnTimeLabel.hidden = YES;
                    _isLearningIcon.hidden = NO;
                    [self setAnimation:_isLearningIcon];
                } else {
                    _learnIcon.hidden = NO;
                    _learnTimeLabel.hidden = NO;
                    _isLearningIcon.hidden = YES;
                    [_isLearningIcon stopAnimating];
                }
            }
        }
    } else if ([_allLayar isEqualToString:@"3"]) {
        if ([_courselayer isEqualToString:@"1"]) {
            _priceLabel.hidden = YES;
            if (model.isExpanded) {
                CGFloat cellHeight = 50;
                for (CourseListModelFinal *object in model.child) {
                    if (SWNOTEmptyArr(object.child)) {
                        if (object.isExpanded) {
                            cellHeight = cellHeight + (object.child.count + 1) * 50;
                        } else {
                            cellHeight = cellHeight + 50;
                        }
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
            _priceLabel.hidden = YES;
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
            if (!_isMainPage) {
                [_priceLabel setRight:_learnIcon.left - 5];
                if (_listFinalModel.isPlaying) {
                    _learnIcon.hidden = YES;
                    _learnTimeLabel.hidden = YES;
                    _isLearningIcon.hidden = NO;
                    [self setAnimation:_isLearningIcon];
                } else {
                    _learnIcon.hidden = NO;
                    _learnTimeLabel.hidden = NO;
                    _isLearningIcon.hidden = YES;
                    [_isLearningIcon stopAnimating];
                }
            }
        }
    }
    if ([model.model.section_data.data_type isEqualToString:@"1"]) {
        _typeIcon.image = Image(@"contents_icon_video");
    } else if ([model.model.section_data.data_type isEqualToString:@"2"]) {
        _typeIcon.image = Image(@"contents_icon_vioce");
    } else if ([model.model.section_data.data_type isEqualToString:@"3"]) {
        _typeIcon.image = Image(@"contents_icon_word");
    } else if ([model.model.section_data.data_type isEqualToString:@"4"]) {
        _typeIcon.image = Image(@"contents_icon_text");
    } else {
        _typeIcon.image = Image(@"contents_icon_video");
    }
//    if (!_isMainPage) {
//        _learnIcon.hidden = YES;
//        _learnTimeLabel.hidden = YES;
//        _isLearningIcon.hidden = NO;
//        [_isLearningIcon startAnimating];
//    }
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

- (void)playCellVideo:(CourseListModelFinal *)model currentCellIndex:(NSIndexPath *)cellIndex panrentCellIndex:(NSIndexPath *)panrentCellIndex superCellIndex:(NSIndexPath *)superIndex currentCell:(nonnull CourseCatalogCell *)cell {
    if (_delegate && [_delegate respondsToSelector:@selector(playCellVideo:currentCellIndex:panrentCellIndex:superCellIndex:currentCell:)]) {
        [_delegate playCellVideo:model currentCellIndex:cellIndex panrentCellIndex:panrentCellIndex superCellIndex:superIndex currentCell:cell];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}

- (void)setAnimation:(UIImageView *)sender {
    if (sender.isAnimating) {
        /// 先暂停再结束是因为有可能属性表现的是正在动画,但是实际上是没做动画.直接调用startAnimation是不会做动画的
        [sender stopAnimating];
        [sender startAnimating];
    } else {
        [sender startAnimating];
    }
}

@end
