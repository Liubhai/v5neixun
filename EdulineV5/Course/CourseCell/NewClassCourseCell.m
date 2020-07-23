//
//  NewClassCourseCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "NewClassCourseCell.h"

@implementation NewClassCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _typeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 32, 18)];
    _typeIcon.centerY = 50 / 2.0;
    [self addSubview:_typeIcon];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeIcon.right + 5, 0, 150, 50)];
    _titleLabel.textColor = EdlineV5_Color.textSecendColor;
    _titleLabel.font = SYSTEMFONT(14);
    [self addSubview:_titleLabel];
    
    _courseRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 30, 0, 30, 50)];
    [_courseRightBtn setImage:Image(@"contents_down") forState:0];
    [_courseRightBtn setImage:Image(@"contents_up") forState:UIControlStateSelected];
    [_courseRightBtn addTarget:self action:@selector(courseRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_courseRightBtn];
    
    _cellTableViewSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, MainScreenWidth, 0.5)];
    _cellTableViewSpace.backgroundColor = EdlineV5_Color.fengeLineColor;
    _cellTableViewSpace.hidden = YES;
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
    _cellTableView.hidden = YES;
    [self addSubview:_cellTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newClassModel.finalModel.child.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.cellTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseCatalogCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.courselayer isEqualToString:@"1"]) {
    } else if ([cell.courselayer isEqualToString:@"2"]) {
    } else if ([cell.courselayer isEqualToString:@"3"]) {
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_newClassModel.finalModel.courselayer isEqualToString:@"1"]) {
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
    } else if ([_newClassModel.finalModel.courselayer isEqualToString:@"2"]) {
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

- (void)setNewClassCourseModelInfo:(NewClassCourseModel *)model {
    _typeIcon.image = [model.course_type isEqualToString:@"1"] ? Image(@"zj_dianbo") : Image(@"zj_live");
    _titleLabel.text = SWNOTEmptyStr(model.title) ? model.title : @"";
    if (<#condition#>) {
        <#statements#>
    }
}

- (void)setListInfo:(CourseListModelFinal *)model {
    _listFinalModel = model;
    _listModel = model.model;
    
    _titleLabel.text = model.model.title;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.model.price];
    
    if (model.model.audition > 0) {
        _freeImageView.hidden = NO;
    } else {
        _freeImageView.hidden = YES;
    }
    
    if ([model.model.price floatValue]>0) {
        _priceLabel.hidden = NO;
        if (model.model.is_buy) {
            _priceLabel.text = @"已购买";
            _freeImageView.hidden = YES;
        }
    } else {
        _priceLabel.hidden = YES;
        if (model.model.is_buy) {
            _freeImageView.hidden = YES;
        }
    }
    CGFloat priceWidth = [_priceLabel.text sizeWithFont:_priceLabel.font].width + 4;
    CGFloat titleWidth = ([_titleLabel.text sizeWithFont:_titleLabel.font].width + 4) > 150 ? 150 : ([_titleLabel.text sizeWithFont:_titleLabel.font].width + 4);
    [_titleLabel setWidth:titleWidth];
    [_priceLabel setWidth:priceWidth];
    [_freeImageView setLeft:_titleLabel.right + 3];
    
    [_priceLabel setLeft:(_freeImageView.hidden ? _titleLabel.right : _freeImageView.right) + 3];
    if ([_allLayar isEqualToString:@"1"]) {
        [self setHeight:50];
        if (!_isMainPage) {
//            [_priceLabel setRight:_learnIcon.left - 5];
            if (_listFinalModel.isPlaying) {
                _learnIcon.hidden = YES;
                _learnTimeLabel.hidden = YES;
                _isLearningIcon.hidden = NO;
                [self setAnimation:_isLearningIcon];
            } else {
                if ([model.model.section_data.data_type isEqualToString:@"3"] || [model.model.section_data.data_type isEqualToString:@"4"]) {
                    _learnIcon.hidden = YES;
                    _learnTimeLabel.hidden = YES;
                    _isLearningIcon.hidden = YES;
                    [_isLearningIcon stopAnimating];
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
                    } else {
                        _learnIcon.hidden = NO;
                        _learnTimeLabel.hidden = NO;
                        _learnIcon.image = Image(@"comment_fin_icon");
                        _learnTimeLabel.text = @"已完成";
                    }
                }
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
//                [_priceLabel setRight:_learnIcon.left - 5];
                if (_listFinalModel.isPlaying) {
                    _learnIcon.hidden = YES;
                    _learnTimeLabel.hidden = YES;
                    _isLearningIcon.hidden = NO;
                    [self setAnimation:_isLearningIcon];
                } else {
                    if ([model.model.section_data.data_type isEqualToString:@"3"] || [model.model.section_data.data_type isEqualToString:@"4"]) {
                        _learnIcon.hidden = YES;
                        _learnTimeLabel.hidden = YES;
                        _isLearningIcon.hidden = YES;
                        [_isLearningIcon stopAnimating];
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
                        } else {
                            _learnIcon.hidden = NO;
                            _learnTimeLabel.hidden = NO;
                            _learnIcon.image = Image(@"comment_fin_icon");
                            _learnTimeLabel.text = @"已完成";
                        }
                    }
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
//                [_priceLabel setRight:_learnIcon.left - 5];
                if (_listFinalModel.isPlaying) {
                    _learnIcon.hidden = YES;
                    _learnTimeLabel.hidden = YES;
                    _isLearningIcon.hidden = NO;
                    [self setAnimation:_isLearningIcon];
                } else {
                    if ([model.model.section_data.data_type isEqualToString:@"3"] || [model.model.section_data.data_type isEqualToString:@"4"]) {
                        _learnIcon.hidden = YES;
                        _learnTimeLabel.hidden = YES;
                        _isLearningIcon.hidden = YES;
                        [_isLearningIcon stopAnimating];
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
                        } else {
                            _learnIcon.hidden = NO;
                            _learnTimeLabel.hidden = NO;
                            _learnIcon.image = Image(@"comment_fin_icon");
                            _learnTimeLabel.text = @"已完成";
                        }
                    }
                }
            }
        }
    }
    if ([model.model.section_data.data_type isEqualToString:@"1"]) {
        _typeIcon.image = Image(@"contents_icon_video");
    } else if ([model.model.section_data.data_type isEqualToString:@"2"]) {
        _typeIcon.image = Image(@"contents_icon_vioce");
    } else if ([model.model.section_data.data_type isEqualToString:@"3"]) {
        _typeIcon.image = Image(@"img_text_icon");
    } else if ([model.model.section_data.data_type isEqualToString:@"4"]) {
        _typeIcon.image = Image(@"ebook_icon_word");
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
