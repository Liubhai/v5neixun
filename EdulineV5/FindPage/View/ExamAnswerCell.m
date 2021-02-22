//
//  ExamAnswerCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/8.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamAnswerCell.h"
#import "V5_Constant.h"

@implementation ExamAnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = EdlineV5_Color.backColor;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 12 + 7, 20, 20)];
    [_selectButton setImage:Image(@"exam_radio_icon_nor") forState:0];
    [_selectButton setImage:[Image(@"exam_radio_icon_sel") converToMainColor] forState:UIControlStateSelected];
    _selectButton.userInteractionEnabled = NO;
    [self.contentView addSubview:_selectButton];
    
    _mutSelectButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 12 + 7, 20, 20)];
    [_mutSelectButton setImage:Image(@"exam_checkbox_nor") forState:0];
    [_mutSelectButton setImage:[Image(@"exam_checkbox_pre") converToMainColor] forState:UIControlStateSelected];
    _mutSelectButton.userInteractionEnabled = NO;
    [self.contentView addSubview:_mutSelectButton];
    _mutSelectButton.hidden = YES;
    
    _keyTitle = [[UILabel alloc] initWithFrame:CGRectMake(_selectButton.right, 12 + 7, 42, 20)];
    _keyTitle.font = SYSTEMFONT(15);
    _keyTitle.textColor = EdlineV5_Color.textFirstColor;
    _keyTitle.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_keyTitle];
    
    _valueTextView = [[UITextView alloc] initWithFrame:CGRectMake(_keyTitle.right, 12, MainScreenWidth - _keyTitle.right - 15, 20)];
    _valueTextView.userInteractionEnabled = NO;
    _valueTextView.showsVerticalScrollIndicator = NO;
    _valueTextView.showsHorizontalScrollIndicator = NO;
    _valueTextView.editable = NO;
    _valueTextView.scrollEnabled = NO;
    _valueTextView.backgroundColor = EdlineV5_Color.backColor;
    [self.contentView addSubview:_valueTextView];
    
    _userInputTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 12, MainScreenWidth - 30, 120)];
    _userInputTextView.delegate = self;
    _userInputTextView.showsVerticalScrollIndicator = NO;
    _userInputTextView.showsHorizontalScrollIndicator = NO;
    _userInputTextView.layer.masksToBounds = YES;
    _userInputTextView.layer.cornerRadius = 3;
    _userInputTextView.layer.borderWidth = 1;
    _userInputTextView.layer.borderColor = EdlineV5_Color.layarLineColor.CGColor;
    _userInputTextView.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:_userInputTextView];
    
    _gapfillingIndexTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 45 - 15, 20)];
    _gapfillingIndexTitle.textColor = EdlineV5_Color.textFirstColor;
    _gapfillingIndexTitle.font = SYSTEMFONT(15);
    [self.contentView addSubview:_gapfillingIndexTitle];
    
    _userInputTextField = [[UITextField alloc] initWithFrame:CGRectMake(_gapfillingIndexTitle.right, 12, MainScreenWidth - 15 - _gapfillingIndexTitle.right, 36)];
    _userInputTextField.delegate = self;
    _userInputTextField.textColor = EdlineV5_Color.textFirstColor;
    _userInputTextField.font = SYSTEMFONT(13);
    _userInputTextField.layer.masksToBounds = YES;
    _userInputTextField.layer.cornerRadius = 3;
    _userInputTextField.layer.borderWidth = 1;
    _userInputTextField.layer.borderColor = EdlineV5_Color.layarLineColor.CGColor;
    _userInputTextField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:_userInputTextField];
    _gapfillingIndexTitle.centerY = _userInputTextField.centerY;
    
    _clozeBackView = [[UIView alloc] initWithFrame:CGRectMake(_gapfillingIndexTitle.right + 8, _gapfillingIndexTitle.top, MainScreenWidth - 15 - _gapfillingIndexTitle.right - 8, 0)];
    _clozeBackView.backgroundColor = EdlineV5_Color.backColor;
    [self.contentView addSubview:_clozeBackView];
}

- (void)setAnswerInfo:(ExamDetailOptionsModel *)model examDetail:(nonnull ExamDetailModel *)detailModel cellIndex:(nonnull NSIndexPath *)cellIndexPath {
    
    _cellDetailModel = detailModel;
    _cellOptionModel = model;
    _cellIndexPath = cellIndexPath;
    /* 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答题 **/
    _selectButton.selected = model.is_selected;
    _mutSelectButton.selected = model.is_selected;
    
    _mutSelectButton.hidden = YES;
    _selectButton.hidden = YES;
    
    _userInputTextView.hidden = YES;
    _userInputTextField.hidden = YES;
    _gapfillingIndexTitle.hidden = YES;
    _gapfillingIndexTitle.text = [NSString stringWithFormat:@"(%@)",@(cellIndexPath.row + 1)];
    
    _clozeBackView.hidden = YES;
    
    _keyTitle.hidden = NO;
    _valueTextView.frame = CGRectMake(_keyTitle.right, 12, MainScreenWidth - _keyTitle.right - 15, 20);
    _valueTextView.hidden = NO;
    if ([detailModel.question_type isEqualToString:@"1"]) {
        _selectButton.hidden = NO;
        _mutSelectButton.hidden = YES;
    } else if ([detailModel.question_type isEqualToString:@"3"] || [detailModel.question_type isEqualToString:@"4"]) {
        _selectButton.hidden = YES;
        _mutSelectButton.hidden = NO;
    } else if ([detailModel.question_type isEqualToString:@"2"]) {
        _selectButton.hidden = NO;
        _mutSelectButton.hidden = YES;
        _keyTitle.hidden = YES;
        _valueTextView.frame = CGRectMake(_selectButton.right + 10, 12, MainScreenWidth - _selectButton.right - 10 - 15, 20);
    } else if ([detailModel.question_type isEqualToString:@"5"]) {
        _selectButton.hidden = YES;
        _mutSelectButton.hidden = YES;
        _keyTitle.hidden = YES;
        _valueTextView.hidden = YES;
        _userInputTextView.hidden = YES;
        
        _userInputTextField.hidden = NO;
        _gapfillingIndexTitle.hidden = NO;
    } else if ([detailModel.question_type isEqualToString:@"8"]) {
        _selectButton.hidden = YES;
        _mutSelectButton.hidden = YES;
        _keyTitle.hidden = YES;
        _valueTextView.hidden = YES;
        _userInputTextView.hidden = NO;
        
        _userInputTextField.hidden = YES;
        _gapfillingIndexTitle.hidden = YES;
    }
    
    _keyTitle.text = [NSString stringWithFormat:@"%@.",model.key];
    
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithData:[valueS dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];

//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    [paragraphStyle setLineSpacing:4];
//    [paragraphStyle setHeadIndent:0.1];
//    [paragraphStyle setTailIndent:-0.1];
//    paragraphStyle.paragraphSpacingBefore = 0.1;
    NSMutableAttributedString *mutable = [[NSMutableAttributedString alloc] initWithAttributedString:model.mutvalue];
    
    if (model.mutvalue) {
        NSString *pass = [NSString stringWithFormat:@"%@",[mutable attributedSubstringFromRange:NSMakeRange(mutable.length - 1, 1)]];
        if ([[pass substringToIndex:1] isEqualToString:@"\n"]) {
            [mutable replaceCharactersInRange:NSMakeRange(mutable.length - 1, 1) withString:@""];
        }
    }
    [mutable addAttributes:@{NSFontAttributeName:SYSTEMFONT(15)} range:NSMakeRange(0, model.mutvalue.length)];//NSParagraphStyleAttributeName:paragraphStyle.copy,
    
    _valueTextView.attributedText = [[NSAttributedString alloc] initWithAttributedString:mutable];
    [_valueTextView sizeToFit];
    _valueTextView.showsVerticalScrollIndicator = NO;
    _valueTextView.showsHorizontalScrollIndicator = NO;
    _valueTextView.editable = NO;
    _valueTextView.scrollEnabled = NO;
    [_valueTextView setHeight:_valueTextView.height];//

//    _valueTextView.contentInset = UIEdgeInsetsMake(-8.f, 0.f, 0.f, 0.f);
    if ([detailModel.question_type isEqualToString:@"1"] || [detailModel.question_type isEqualToString:@"2"] || [detailModel.question_type isEqualToString:@"3"] || [detailModel.question_type isEqualToString:@"4"]) {
        [self setHeight:MAX(_selectButton.bottom, _valueTextView.bottom) + 12];
    } else if ([detailModel.question_type isEqualToString:@"5"]) {
        [self setHeight:_userInputTextField.bottom + 12];
    } else if ([detailModel.question_type isEqualToString:@"8"]) {
        [self setHeight:_userInputTextView.bottom + 12];
    }
}

- (void)setExamDetail:(ExamDetailModel *)detailModel cellIndex:(NSIndexPath *)cellIndexPath {
    _cellDetailModel = detailModel;
    _cellIndexPath = cellIndexPath;
    // 每一个 detailModel 里面的 topics 元素数组 作为一个 cell 的填充内容
    _mutSelectButton.hidden = YES;
    _selectButton.hidden = YES;
    _valueTextView.hidden = YES;
    
    _userInputTextView.hidden = YES;
    _userInputTextField.hidden = YES;
    
    _keyTitle.hidden = YES;
    _gapfillingIndexTitle.hidden = NO;
    _gapfillingIndexTitle.text = [NSString stringWithFormat:@"%@.",@(cellIndexPath.row + 1)];
    _gapfillingIndexTitle.frame = CGRectMake(15, 12, 45 - 15, 20);
    _clozeBackView.hidden = NO;
    _clozeBackView.frame = CGRectMake(_gapfillingIndexTitle.right + 8, _gapfillingIndexTitle.top, MainScreenWidth - 15 - _gapfillingIndexTitle.right - 8, 0);
    [_clozeBackView removeAllSubviews];
    CGFloat XX = 0.0;
    CGFloat YY = 0.0;
    for (int i = 0; i<detailModel.options.count; i++) {
        ExamDetailOptionsModel *optionModel = detailModel.options[i];
        NSString *secondTitle = [NSString stringWithFormat:@"%@.%@",optionModel.key,optionModel.value];//@"热门搜索";
        CGFloat secondBtnWidth = [secondTitle sizeWithFont:SYSTEMFONT(15)].width + 4 + 6 + 20;
        UIButton *secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, secondBtnWidth, 20)];
        secondBtn.tag = 100 + i;
        [secondBtn setImage:Image(@"exam_radio_icon_nor") forState:0];
        [secondBtn setImage:[Image(@"exam_radio_icon_sel") converToMainColor] forState:UIControlStateSelected];
        [secondBtn setTitle:secondTitle forState:0];
        [secondBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        secondBtn.titleLabel.font = SYSTEMFONT(15);

        [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6/2.0, 0, -6/2.0)];
        [secondBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -6/2.0, 0, 6/2.0)];
        [secondBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        secondBtn.selected = optionModel.is_selected;
        
        if ((secondBtnWidth + XX) > _clozeBackView.width) {
            XX = 0;
            YY = YY + 10 + 20;
        }
        secondBtn.frame = CGRectMake(XX, YY, secondBtnWidth, 20);
        XX = secondBtn.right + 10;
        if (i == detailModel.options.count - 1) {
            [_clozeBackView setHeight:secondBtn.bottom];
            [self setHeight:secondBtn.bottom + 12];
        }
        [_clozeBackView addSubview:secondBtn];
    }
}

- (void)secondBtnClick:(UIButton *)sender {
    for (int i = 0; i<_cellDetailModel.options.count; i++) {
        ExamDetailOptionsModel *optionModel = _cellDetailModel.options[i];
        if (i == (sender.tag - 100)) {
            optionModel.is_selected = YES;
        } else {
            optionModel.is_selected = NO;
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(gapfillingChooseStatusChanged:)]) {
        [_delegate gapfillingChooseStatusChanged:self];
    }
}

- (float)heightForString:(NSMutableAttributedString *)value fontSize:(UIFont*)font andWidth:(float)width {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:4.0];
    [paragraphStyle setHeadIndent:0.0001];
    [paragraphStyle setTailIndent:-0.0001];
    paragraphStyle.paragraphSpacingBefore = 0.1;
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    [value addAttributes:attributes range:NSMakeRange(0, value.length)];
    CGRect rectToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    if (value.length==0||[value isEqual:[NSNull null]]||value==nil) {
        return 0.0;
    }else{
        return rectToFit.size.height;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_userInputTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_userInputTextView resignFirstResponder];
        return NO;
    }
    return YES;
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
