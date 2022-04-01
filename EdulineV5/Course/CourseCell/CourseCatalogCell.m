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
    [self.contentView addSubview:_blueView];
    
    _typeIcon = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 32, 16)];
    _typeIcon.centerY = 50 / 2.0;
    _typeIcon.font = SYSTEMFONT(11);
    _typeIcon.layer.masksToBounds = YES;
    _typeIcon.layer.cornerRadius = 3;
    _typeIcon.textColor = HEXCOLOR(0x6E6E6E);
    _typeIcon.textAlignment = NSTextAlignmentCenter;
    _typeIcon.backgroundColor = HEXCOLOR(0xF1F1F1);
    _typeIcon.hidden = _isLive;
    [self.contentView addSubview:_typeIcon];
    
    _lockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 14, 0, 14, 16)];
    _lockIcon.centerY = 50 / 2.0;
    _lockIcon.image = Image(@"contents_icon_lock");
    _lockIcon.hidden = YES;
    [self.contentView addSubview:_lockIcon];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_isLive ? 15 : (_typeIcon.right + 5), 0, 150, 50)];
    _titleLabel.textColor = EdlineV5_Color.textSecendColor;
    _titleLabel.font = SYSTEMFONT(14);
    [self.contentView addSubview:_titleLabel];
    
    _freeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.right + 10, (50 - 16) / 2.0, 36, 16)];
    _freeImageView.image = Image(@"contents_icon_free");
    _freeImageView.hidden = YES;
    [self.contentView addSubview:_freeImageView];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_freeImageView.right + 10, (50 - 13) / 2.0, 100, 13)];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = EdlineV5_Color.faildColor;
    _priceLabel.layer.masksToBounds = YES;
    _priceLabel.layer.cornerRadius = 1;
    _priceLabel.layer.borderColor = EdlineV5_Color.faildColor.CGColor;
    _priceLabel.layer.borderWidth = 1;
    _priceLabel.font = SYSTEMFONT(11);
    [self.contentView addSubview:_priceLabel];
    
    _courseRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, 0, 30, 50)];
    [_courseRightBtn setImage:Image(@"contents_down") forState:0];
    [_courseRightBtn setImage:Image(@"contents_up") forState:UIControlStateSelected];
    [_courseRightBtn addTarget:self action:@selector(courseRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_courseRightBtn];
    
    _coverButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
    _coverButton.backgroundColor = [UIColor clearColor];
    [_coverButton addTarget:self action:@selector(courseRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_coverButton];
    
    _isLearningIcon = [[playAnimationView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 16, 0, 16, 17)];
    _isLearningIcon.centerY = 50 / 2.0;
    _isLearningIcon.image = Image(@"comment_playing");
    _isLearningIcon.animationImages = @[Image(@"playing1"),Image(@"playing2")];
    _isLearningIcon.highlightedAnimationImages = @[Image(@"playing1"),Image(@"playing2")];
    _isLearningIcon.animationDuration = 0.4;
    [self.contentView addSubview:_isLearningIcon];
    
    _learnTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 85, 0, 85, 50)];
    _learnTimeLabel.font = SYSTEMFONT(11);
    _learnTimeLabel.textAlignment = NSTextAlignmentRight;
    _learnTimeLabel.textColor = EdlineV5_Color.textThirdColor;
    [self.contentView addSubview:_learnTimeLabel];
    
    _learnIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_learnTimeLabel.left - 8 - 14, 0, 14, 14)];
    _learnIcon.centerY = 50 / 2.0;
    _learnIcon.image = Image(@"comment_his_icon");
    [self.contentView addSubview:_learnIcon];
    
    _cellTableViewSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 49, MainScreenWidth, 1)];
    _cellTableViewSpace.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.contentView addSubview:_cellTableViewSpace];
    
    // 当目录为3层的时候 这个实际上是二层视图 table是三层视图
    // 当目录为2层的时候 这个实际上是二层视图 没有table
    // 当目录为1层的时候 这个实际上是一层视图 没有table是三层视图
    
    if ([_allLayar isEqualToString:@"1"]) {
        _blueView.hidden = YES;
        _courseRightBtn.hidden = YES;
        _coverButton.hidden = YES;
        if (_isMainPage) {
            _learnIcon.hidden = YES;
            _learnTimeLabel.hidden = YES;
        }
        _titleLabel.font = SYSTEMFONT(14);
        _cellTableViewSpace.frame = CGRectMake(_typeIcon.left, 49, MainScreenWidth - _typeIcon.left, 1);
    } else if ([_allLayar isEqualToString:@"2"]) {
        _blueView.hidden = YES;
        if ([_courselayer isEqualToString:@"2"]) {
            _courseRightBtn.hidden = NO;
            _coverButton.hidden = NO;
            _typeIcon.hidden = YES;
            _lockIcon.hidden = YES;
            _priceLabel.hidden = YES;
            _learnIcon.hidden = YES;
            _learnTimeLabel.hidden = YES;
            _isLearningIcon.hidden = YES;
            [_titleLabel setLeft:15];
            _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
            _cellTableViewSpace.frame = CGRectMake(_titleLabel.left, 49, MainScreenWidth - _titleLabel.left, 1);
        } else if ([_courselayer isEqualToString:@"3"]) {
            _titleLabel.font = SYSTEMFONT(14);
            _courseRightBtn.hidden = YES;
            _coverButton.hidden = YES;
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
            _cellTableViewSpace.frame = CGRectMake(_typeIcon.left, 49, MainScreenWidth - _typeIcon.left, 1);
        }
    } else if ([_allLayar isEqualToString:@"3"]) {
        if ([_courselayer isEqualToString:@"1"] || [_courselayer isEqualToString:@"2"]) {
            _blueView.hidden = [_courselayer isEqualToString:@"1"] ? NO : YES;
            _courseRightBtn.hidden = NO;
            _coverButton.hidden = NO;
            _typeIcon.hidden = YES;
            _lockIcon.hidden = YES;
            _priceLabel.hidden = YES;
            _learnIcon.hidden = YES;
            _learnTimeLabel.hidden = YES;
            _isLearningIcon.hidden = YES;
            [_titleLabel setLeft:15 + 3 + 8];//([_courselayer isEqualToString:@"1"] ? (15 + 3 + 8) : 15)
            if ([_courselayer isEqualToString:@"1"]) {
                _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
                _cellTableViewSpace.frame = CGRectMake(_blueView.left, 49, MainScreenWidth - _blueView.left, 1);
            } else {
                _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
                _cellTableViewSpace.frame = CGRectMake(_titleLabel.left, 49, MainScreenWidth - _titleLabel.left, 1);
            }
        } else if ([_courselayer isEqualToString:@"3"]) {
            _cellTableViewSpace.frame = CGRectMake(_typeIcon.left, 49, MainScreenWidth - _typeIcon.left, 1);
            _titleLabel.font = SYSTEMFONT(14);
            _courseRightBtn.hidden = YES;
            _coverButton.hidden = YES;
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
        _dataSource = [NSMutableArray new];
        _cellTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth, 0)];
        _cellTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cellTableView.dataSource = self;
        _cellTableView.delegate = self;
        _cellTableView.showsVerticalScrollIndicator = NO;
        _cellTableView.showsHorizontalScrollIndicator = NO;
        _cellTableView.bounces = NO;
        _cellTableView.rowHeight = 50;
        _cellTableView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_cellTableView];
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
            CourseCatalogCell *cell = (CourseCatalogCell *)(self.superview.superview.superview);
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
        cell.courseIsBuy = _courseIsBuy;
        [cell setListInfo:model];
        return cell;
    } else if ([_courselayer isEqualToString:@"2"]) {
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
        cell.courseIsBuy = _courseIsBuy;
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
    cell.courseIsBuy = _courseIsBuy;
    [cell setListInfo:model];
    return cell;
}

- (void)setListInfo:(CourseListModelFinal *)model {
    
    // 初始化类型文本
    _typeIcon.textColor = HEXCOLOR(0x6E6E6E);
    _typeIcon.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    if ([model.model.section_data.data_type isEqualToString:@"4"]) {
        [_typeIcon setWidth:39];
    }  else {
        [_typeIcon setWidth:32];
    }
    
    _titleLabel.frame = CGRectMake(_isLive ? 15 : (_typeIcon.right + 5), 0, 150, 50);
    
    _freeImageView.frame = CGRectMake(_titleLabel.right + 10, (50 - 16) / 2.0, 36, 16);
    
    _priceLabel.frame = CGRectMake(_freeImageView.right + 10, (50 - 13) / 2.0, 100, 13);
    
    _titleLabel.textColor = EdlineV5_Color.textSecendColor;
    
    _courseRightBtn.selected = NO;
    _listFinalModel = model;
    _listModel = model.model;
    
    _titleLabel.text = model.model.title;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,model.model.price];
    
    if (model.model.audition > 0) {
        _freeImageView.hidden = NO;
    } else {
        _freeImageView.hidden = YES;
    }
    
    if ([model.model.price floatValue]>0) {
        _priceLabel.hidden = NO;
        if (model.model.is_buy) {
            if (model.model.is_course_buy) {
                _priceLabel.hidden = YES;
            }
            _priceLabel.text = @"已购买";
            _freeImageView.hidden = YES;
        }
    } else {
        _priceLabel.hidden = YES;
        if (model.model.is_buy) {
            _freeImageView.hidden = YES;
        }
    }
    
    _freeImageView.hidden = YES;
    _priceLabel.hidden = YES;
    
    CGFloat priceWidth = [_priceLabel.text sizeWithFont:_priceLabel.font].width + 4;
    CGFloat titleWidth = ([_titleLabel.text sizeWithFont:_titleLabel.font].width + 4) > 150 ? 150 : ([_titleLabel.text sizeWithFont:_titleLabel.font].width + 4);
    [_titleLabel setWidth:titleWidth];
    [_priceLabel setWidth:priceWidth];
    [_freeImageView setLeft:_titleLabel.right + 3];
    
    // 处理学习记录ui
    _learnTimeLabel.frame = CGRectMake(MainScreenWidth - 15 - 85, 0, 85, 50);
    _learnTimeLabel.textColor = EdlineV5_Color.textThirdColor;
    _learnIcon.frame = CGRectMake(_learnTimeLabel.left - 8 - 14, 0, 14, 14);
    _learnIcon.centerY = 50 / 2.0;
    
    [_priceLabel setLeft:(_freeImageView.hidden ? _titleLabel.right : _freeImageView.right) + 3];
    if ([_allLayar isEqualToString:@"1"]) {
        _cellTableViewSpace.frame = CGRectMake(_typeIcon.left, 49, MainScreenWidth - _typeIcon.left, 1);
        [self setHeight:50];
        if (!_isMainPage) {
//            [_priceLabel setRight:_learnIcon.left - 5];
            if (_listFinalModel.isPlaying) {
                _learnIcon.hidden = YES;
                _learnTimeLabel.hidden = YES;
                _isLearningIcon.hidden = NO;
                _titleLabel.textColor = EdlineV5_Color.themeColor;
                [self setAnimation:_isLearningIcon];
                _typeIcon.textColor = [UIColor whiteColor];
                _typeIcon.backgroundColor = EdlineV5_Color.themeColor;
            } else {
                _learnIcon.hidden = NO;
                _learnTimeLabel.hidden = NO;
                _isLearningIcon.hidden = YES;
                [_isLearningIcon stopAnimating];
                if (model.model.section_rate.status == 957) {
                    _learnIcon.hidden = YES;
                    _learnTimeLabel.hidden = YES;
                } else if (model.model.section_rate.status == 999) {
                    _learnIcon.hidden = NO;
                    _learnTimeLabel.hidden = NO;
                    _learnIcon.image = Image(@"comment_his_icon");
                    _learnTimeLabel.text = [NSString stringWithFormat:@"学习至%@",[EdulineV5_Tool timeChangeWithSecondsFormat:model.model.section_rate.current_time]];
                    CGFloat learnTimeLabelWidth = [_learnTimeLabel.text sizeWithFont:_learnTimeLabel.font].width + 4;
                    _learnTimeLabel.frame = CGRectMake(MainScreenWidth - 15 - learnTimeLabelWidth, 0, learnTimeLabelWidth, 50);
                    _learnIcon.frame = CGRectMake(_learnTimeLabel.left - 8 - 14, 0, 14, 14);
                    _learnIcon.centerY = 50 / 2.0;
                } else {
                    _learnIcon.hidden = NO;
                    _learnTimeLabel.hidden = NO;
                    _learnIcon.image = Image(@"comment_fin_icon");
                    _learnTimeLabel.text = @"已完成";
                    CGFloat learnTimeLabelWidth = [_learnTimeLabel.text sizeWithFont:_learnTimeLabel.font].width + 4;
                    _learnTimeLabel.frame = CGRectMake(MainScreenWidth - 15 - learnTimeLabelWidth, 0, learnTimeLabelWidth, 50);
                    _learnIcon.frame = CGRectMake(_learnTimeLabel.left - 8 - 14, 0, 14, 14);
                    _learnIcon.centerY = 50 / 2.0;
                }
            }
        }
    } else if ([_allLayar isEqualToString:@"2"]) {
        if ([_courselayer isEqualToString:@"2"]) {
            [_titleLabel setLeft:15];
            _priceLabel.hidden = YES;
            _courseRightBtn.selected = model.isExpanded;
            if (model.isExpanded) {
                [self setHeight:50 + model.child.count * 50];
                [_cellTableView setHeight:model.child.count * 50];
                _cellTableView.hidden = NO;
            } else {
                [self setHeight:50];
                [_cellTableView setHeight:0];
                _cellTableView.hidden = YES;
            }
            _cellTableViewSpace.frame = CGRectMake(_titleLabel.left, 49, MainScreenWidth - _titleLabel.left, 1);
            if (!_isMainPage) {
                if (_listFinalModel.isPlaying) {
                    _titleLabel.textColor = EdlineV5_Color.themeColor;
                }
            }
        } else if ([_courselayer isEqualToString:@"3"]) {
            [self setHeight:50];
            _cellTableViewSpace.frame = CGRectMake(_typeIcon.left, 49, MainScreenWidth - _typeIcon.left, 1);
            if (!_isMainPage) {
//                [_priceLabel setRight:_learnIcon.left - 5];
                if (_listFinalModel.isPlaying) {
                    _learnIcon.hidden = YES;
                    _learnTimeLabel.hidden = YES;
                    _isLearningIcon.hidden = NO;
                    _titleLabel.textColor = EdlineV5_Color.themeColor;
                    [self setAnimation:_isLearningIcon];
                    _typeIcon.textColor = [UIColor whiteColor];
                    _typeIcon.backgroundColor = EdlineV5_Color.themeColor;
                } else {
                    _learnIcon.hidden = NO;
                    _learnTimeLabel.hidden = NO;
                    _isLearningIcon.hidden = YES;
                    [_isLearningIcon stopAnimating];
                    if (model.model.section_rate.status == 957) {
                        _learnIcon.hidden = YES;
                        _learnTimeLabel.hidden = YES;
                    } else if (model.model.section_rate.status == 999) {
                        _learnIcon.hidden = NO;
                        _learnTimeLabel.hidden = NO;
                        _learnIcon.image = Image(@"comment_his_icon");
                        _learnTimeLabel.text = [NSString stringWithFormat:@"学习至%@",[EdulineV5_Tool timeChangeWithSecondsFormat:model.model.section_rate.current_time]];
                        CGFloat learnTimeLabelWidth = [_learnTimeLabel.text sizeWithFont:_learnTimeLabel.font].width + 4;
                        _learnTimeLabel.frame = CGRectMake(MainScreenWidth - 15 - learnTimeLabelWidth, 0, learnTimeLabelWidth, 50);
                        _learnIcon.frame = CGRectMake(_learnTimeLabel.left - 8 - 14, 0, 14, 14);
                        _learnIcon.centerY = 50 / 2.0;
                    } else {
                        _learnIcon.hidden = NO;
                        _learnTimeLabel.hidden = NO;
                        _learnIcon.image = Image(@"comment_fin_icon");
                        _learnTimeLabel.text = @"已完成";
                        CGFloat learnTimeLabelWidth = [_learnTimeLabel.text sizeWithFont:_learnTimeLabel.font].width + 4;
                        _learnTimeLabel.frame = CGRectMake(MainScreenWidth - 15 - learnTimeLabelWidth, 0, learnTimeLabelWidth, 50);
                        _learnIcon.frame = CGRectMake(_learnTimeLabel.left - 8 - 14, 0, 14, 14);
                        _learnIcon.centerY = 50 / 2.0;
                    }
                }
            }
        }
    } else if ([_allLayar isEqualToString:@"3"]) {
        if ([_courselayer isEqualToString:@"1"]) {
            [_titleLabel setLeft:15 + 3 + 8];
            _priceLabel.hidden = YES;
            _courseRightBtn.selected = model.isExpanded;
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
            _cellTableViewSpace.frame = CGRectMake(_blueView.left, 49, MainScreenWidth - _blueView.left, 1);
            if (!_isMainPage) {
                if (_listFinalModel.isPlaying) {
                    _titleLabel.textColor = EdlineV5_Color.themeColor;
                }
            }
        } else if ([_courselayer isEqualToString:@"2"]) {
            [_titleLabel setLeft:15 + 3 + 8];
            _priceLabel.hidden = YES;
            _courseRightBtn.selected = model.isExpanded;
            if (model.isExpanded) {
                [self setHeight:50 + model.child.count * 50];
                [_cellTableView setHeight:model.child.count * 50];
                _cellTableView.hidden = NO;
            } else {
                [self setHeight:50];
                [_cellTableView setHeight:0];
                _cellTableView.hidden = YES;
            }
            _cellTableViewSpace.frame = CGRectMake(_titleLabel.left, 49, MainScreenWidth - _titleLabel.left, 1);
            if (!_isMainPage) {
                if (_listFinalModel.isPlaying) {
                    _titleLabel.textColor = EdlineV5_Color.themeColor;
                }
            }
        } else if ([_courselayer isEqualToString:@"3"]) {
            [self setHeight:50];
            [_cellTableView setHeight:0];
            _cellTableView.hidden = YES;
            if (!_isMainPage) {
//                [_priceLabel setRight:_learnIcon.left - 5];
                if (_listFinalModel.isPlaying) {
                    _learnIcon.hidden = YES;
                    _learnTimeLabel.hidden = YES;
                    _isLearningIcon.hidden = NO;
                    _titleLabel.textColor = EdlineV5_Color.themeColor;
                    [self setAnimation:_isLearningIcon];
                    _typeIcon.textColor = [UIColor whiteColor];
                    _typeIcon.backgroundColor = EdlineV5_Color.themeColor;
                } else {
                    _learnIcon.hidden = NO;
                    _learnTimeLabel.hidden = NO;
                    _isLearningIcon.hidden = YES;
                    [_isLearningIcon stopAnimating];
                    if (model.model.section_rate.status == 957) {
                        _learnIcon.hidden = YES;
                        _learnTimeLabel.hidden = YES;
                    } else if (model.model.section_rate.status == 999) {
                        _learnIcon.hidden = NO;
                        _learnTimeLabel.hidden = NO;
                        _learnIcon.image = Image(@"comment_his_icon");
                        _learnTimeLabel.text = [NSString stringWithFormat:@"学习至%@",[EdulineV5_Tool timeChangeWithSecondsFormat:model.model.section_rate.current_time]];
                        CGFloat learnTimeLabelWidth = [_learnTimeLabel.text sizeWithFont:_learnTimeLabel.font].width + 4;
                        _learnTimeLabel.frame = CGRectMake(MainScreenWidth - 15 - learnTimeLabelWidth, 0, learnTimeLabelWidth, 50);
                        _learnIcon.frame = CGRectMake(_learnTimeLabel.left - 8 - 14, 0, 14, 14);
                        _learnIcon.centerY = 50 / 2.0;
                    } else {
                        _learnIcon.hidden = NO;
                        _learnTimeLabel.hidden = NO;
                        _learnIcon.image = Image(@"comment_fin_icon");
                        _learnTimeLabel.text = @"已完成";
                        CGFloat learnTimeLabelWidth = [_learnTimeLabel.text sizeWithFont:_learnTimeLabel.font].width + 4;
                        _learnTimeLabel.frame = CGRectMake(MainScreenWidth - 15 - learnTimeLabelWidth, 0, learnTimeLabelWidth, 50);
                        _learnIcon.frame = CGRectMake(_learnTimeLabel.left - 8 - 14, 0, 14, 14);
                        _learnIcon.centerY = 50 / 2.0;
                    }
                    _cellTableViewSpace.frame = CGRectMake(_typeIcon.left, 49, MainScreenWidth - _typeIcon.left, 1);
                }
            }
        }
    }
    if ([model.model.section_data.data_type isEqualToString:@"1"]) {
        _typeIcon.text = @"视频";
    } else if ([model.model.section_data.data_type isEqualToString:@"2"]) {
        _typeIcon.text = @"音频";
    } else if ([model.model.section_data.data_type isEqualToString:@"3"]) {
        _typeIcon.text = @"图文";
    } else if ([model.model.section_data.data_type isEqualToString:@"4"]) {
        _typeIcon.text = @"电子书";
    } else {
        _typeIcon.text = @"视频";
    }
    
    if ([model.model.course_type isEqualToString:@"2"]) {
        _learnIcon.hidden = YES;
        _isLearningIcon.hidden = YES;
        _learnTimeLabel.text = model.model.live_rate.status_text;
        [_isLearningIcon stopAnimating];
//        【957：未开始；999：学习中；992：已完成；】
        if (model.model.live_rate.status == 992) {
            if (SWNOTEmptyArr(model.model.live_rate.callback_url) || SWNOTEmptyStr(model.model.section_live.cc_replay_id) || SWNOTEmptyStr(model.model.section_live.cc_replay_url)) {
                _learnTimeLabel.text = @"观看回放";
                _learnTimeLabel.textColor = EdlineV5_Color.textThirdColor;
            }
        } else if (model.model.live_rate.status == 999) {
            _isLearningIcon.hidden = NO;
            _learnTimeLabel.textColor = HEXCOLOR(0x5191FF);
        } else if (model.model.live_rate.status == 957) {
            _learnTimeLabel.text = [EdulineV5_Tool evaluateStarTime:model.model.start_time endTime:model.model.end_time];
        }
        CGFloat learnTimeLabelWidth = [_learnTimeLabel.text sizeWithFont:_learnTimeLabel.font].width + 4;
        _learnTimeLabel.frame = CGRectMake(MainScreenWidth - 15 - learnTimeLabelWidth, 0, learnTimeLabelWidth, 50);
        _learnTimeLabel.hidden = NO;
        if (model.model.live_rate.status == 999) {
            [_isLearningIcon setRight:_learnTimeLabel.left - 5];
            [self setAnimation:_isLearningIcon];
            _typeIcon.textColor = [UIColor whiteColor];
            _typeIcon.backgroundColor = EdlineV5_Color.themeColor;
        }
    }
    
    CGFloat titleLabelFinalWith = 150;
    if (_isMainPage) {
        if ([model.model.course_type isEqualToString:@"2"]) {
            // 直播
            if (!_isLearningIcon.hidden) {
                if (!_priceLabel.hidden && !_freeImageView.hidden) {
                    titleLabelFinalWith = _isLearningIcon.left - 15 - _titleLabel.left - 3 - _freeImageView.width - 3 - _priceLabel.width;
                } else {
                    if (!_priceLabel.hidden) {
                        titleLabelFinalWith = _isLearningIcon.left - 15 - _titleLabel.left - 3 - _priceLabel.width;
                    } else {
                        if (!_freeImageView.hidden) {
                            titleLabelFinalWith = _isLearningIcon.left - 15 - _titleLabel.left - 3 - _freeImageView.width;
                        } else {
                            titleLabelFinalWith = _isLearningIcon.left - 15  - _titleLabel.left;
                        }
                    }
                }
            } else {
                if (!_priceLabel.hidden && !_freeImageView.hidden) {
                    titleLabelFinalWith = _learnTimeLabel.left - 15 - _titleLabel.left - 3 - _freeImageView.width - 3 - _priceLabel.width;
                } else {
                    if (!_priceLabel.hidden) {
                        titleLabelFinalWith = _learnTimeLabel.left - 15 - _titleLabel.left - 3 - _priceLabel.width;
                    } else {
                        if (!_freeImageView.hidden) {
                            titleLabelFinalWith = _learnTimeLabel.left - 15 - _titleLabel.left - 3 - _freeImageView.width;
                        } else {
                            titleLabelFinalWith = _learnTimeLabel.left - 15  - _titleLabel.left;
                        }
                    }
                }
            }
            
        } else {
            if (!_priceLabel.hidden && !_freeImageView.hidden) {
                titleLabelFinalWith = MainScreenWidth - 15 - _titleLabel.left - 3 - _freeImageView.width - 3 - _priceLabel.width;
            } else {
                if (!_priceLabel.hidden) {
                    titleLabelFinalWith = MainScreenWidth - 15 - _titleLabel.left - 3 - _priceLabel.width;
                } else {
                    if (!_freeImageView.hidden) {
                        titleLabelFinalWith = MainScreenWidth - 15 - _titleLabel.left - 3 - _freeImageView.width;
                    } else {
                        titleLabelFinalWith = MainScreenWidth - 15  - _titleLabel.left;
                    }
                }
            }
        }
    } else {
        
        if ([model.model.course_type isEqualToString:@"2"]) {
            // 直播
            if (!_isLearningIcon.hidden) {
                if (!_priceLabel.hidden && !_freeImageView.hidden) {
                    titleLabelFinalWith = _isLearningIcon.left - 15 - _titleLabel.left - 3 - _freeImageView.width - 3 - _priceLabel.width;
                } else {
                    if (!_priceLabel.hidden) {
                        titleLabelFinalWith = _isLearningIcon.left - 15 - _titleLabel.left - 3 - _priceLabel.width;
                    } else {
                        if (!_freeImageView.hidden) {
                            titleLabelFinalWith = _isLearningIcon.left - 15 - _titleLabel.left - 3 - _freeImageView.width;
                        } else {
                            titleLabelFinalWith = _isLearningIcon.left - 15  - _titleLabel.left;
                        }
                    }
                }
            } else {
                if (!_priceLabel.hidden && !_freeImageView.hidden) {
                    titleLabelFinalWith = _learnTimeLabel.left - 15 - _titleLabel.left - 3 - _freeImageView.width - 3 - _priceLabel.width;
                } else {
                    if (!_priceLabel.hidden) {
                        titleLabelFinalWith = _learnTimeLabel.left - 15 - _titleLabel.left - 3 - _priceLabel.width;
                    } else {
                        if (!_freeImageView.hidden) {
                            titleLabelFinalWith = _learnTimeLabel.left - 15 - _titleLabel.left - 3 - _freeImageView.width;
                        } else {
                            titleLabelFinalWith = _learnTimeLabel.left - 15  - _titleLabel.left;
                        }
                    }
                }
            }
            
        } else {
            if (!_isLearningIcon.hidden) {
                if (!_priceLabel.hidden && !_freeImageView.hidden) {
                    titleLabelFinalWith = _isLearningIcon.left - 15 - _titleLabel.left - 3 - _freeImageView.width - 3 - _priceLabel.width;
                } else {
                    if (!_priceLabel.hidden) {
                        titleLabelFinalWith = _isLearningIcon.left - 15 - _titleLabel.left - 3 - _priceLabel.width;
                    } else {
                        if (!_freeImageView.hidden) {
                            titleLabelFinalWith = _isLearningIcon.left - 15 - _titleLabel.left - 3 - _freeImageView.width;
                        } else {
                            titleLabelFinalWith = _isLearningIcon.left - 15  - _titleLabel.left;
                        }
                    }
                }
            } else {
                if (!_learnTimeLabel.hidden) {
                    if (!_priceLabel.hidden && !_freeImageView.hidden) {
                        titleLabelFinalWith = _learnIcon.left - 15 - _titleLabel.left - 3 - _freeImageView.width - 3 - _priceLabel.width;
                    } else {
                        if (!_priceLabel.hidden) {
                            titleLabelFinalWith = _learnIcon.left - 15 - _titleLabel.left - 3 - _priceLabel.width;
                        } else {
                            if (!_freeImageView.hidden) {
                                titleLabelFinalWith = _learnIcon.left - 15 - _titleLabel.left - 3 - _freeImageView.width;
                            } else {
                                titleLabelFinalWith = _learnIcon.left - 15  - _titleLabel.left;
                            }
                        }
                    }
                } else {
                    titleLabelFinalWith = MainScreenWidth - 15  - _titleLabel.left;
                }
            }
        }
    }
    
    [_titleLabel setWidth:titleLabelFinalWith>([_titleLabel.text sizeWithFont:_titleLabel.font].width + 4) ? ([_titleLabel.text sizeWithFont:_titleLabel.font].width + 4) : titleLabelFinalWith];
    [_freeImageView setLeft:_titleLabel.right + 3];
    [_priceLabel setLeft:(_freeImageView.hidden ? _titleLabel.right : _freeImageView.right) + 3];
    
    [_cellTableView reloadData];
}

- (void)courseRightButtonClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(listChangeUpAndDown:listModel:panrentListModel:)]) {
        if ([_courselayer isEqualToString:@"2"] && [_allLayar isEqualToString:@"3"]) {
            CourseCatalogCell *cell = (CourseCatalogCell *)(_cellTableView.superview.superview);
            [_delegate listChangeUpAndDown:sender listModel:_listFinalModel panrentListModel:cell.listFinalModel];
        } else {
            [_delegate listChangeUpAndDown:sender listModel:_listFinalModel panrentListModel:nil];
        }
    }
}

- (void)listChangeUpAndDown:(UIButton *)sender listModel:(CourseListModelFinal *)model panrentListModel:(CourseListModelFinal *)panrentModel {
    if (_delegate && [_delegate respondsToSelector:@selector(listChangeUpAndDown:listModel:panrentListModel:)]) {
        CourseCatalogCell *cell = (CourseCatalogCell *)(sender.superview.superview);
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
