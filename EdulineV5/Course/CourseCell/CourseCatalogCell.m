//
//  CourseCatalogCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseCatalogCell.h"

@implementation CourseCatalogCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier isClassNew:(BOOL)isClassNew cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _isClassNew = isClassNew;
        _cellSection = cellSection;
        _cellRow = cellRow;
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
    
    if (_isClassNew) {
        
        _typeIcon.hidden = YES;
        _lockIcon.hidden = YES;
        _priceLabel.hidden = YES;
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
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuse = @"classnew";
    CourseCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
    if (!cell) {
        cell = [[CourseCatalogCell alloc] initWithReuseIdentifier:cellReuse isClassNew:NO cellSection:0 cellRow:0];
    }
//    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [_cellTableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (_delegate && [_delegate respondsToSelector:@selector(classCourseCellTableViewCellSelected:cellSection:cellRow:classCellRow:)]) {
//        [_delegate classCourseCellTableViewCellSelected:[_dataSource objectAtIndex:indexPath.row] cellSection:_cellSection cellRow:_cellRow classCellRow:indexPath.row];
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
