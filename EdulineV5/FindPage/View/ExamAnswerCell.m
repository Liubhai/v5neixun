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
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 12 + 7, 20, 20)];
    [_selectButton setImage:Image(@"exam_radio_icon_nor") forState:0];
    [_selectButton setImage:Image(@"exam_radio_icon_sel") forState:UIControlStateSelected];
    _selectButton.userInteractionEnabled = NO;
    [self.contentView addSubview:_selectButton];
    
    _keyTitle = [[UILabel alloc] initWithFrame:CGRectMake(_selectButton.right, 12 + 7, 42, 20)];
    _keyTitle.font = SYSTEMFONT(15);
    _keyTitle.textColor = EdlineV5_Color.textFirstColor;
    _keyTitle.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_keyTitle];
    
    _valueTextView = [[UITextView alloc] initWithFrame:CGRectMake(_keyTitle.right, 12, MainScreenWidth - _keyTitle.right - 15, 20)];
    _valueTextView.showsVerticalScrollIndicator = NO;
    _valueTextView.showsHorizontalScrollIndicator = NO;
    _valueTextView.editable = NO;
    _valueTextView.scrollEnabled = NO;
    [self.contentView addSubview:_valueTextView];
    
}

- (void)setAnswerInfo:(ExamDetailOptionsModel *)model examDetail:(nonnull ExamDetailModel *)detailModel {
    
    _selectButton.selected = model.is_selected;
    
    _keyTitle.text = [NSString stringWithFormat:@"%@.",model.key];
    
    _valueTextView.frame = CGRectMake(_keyTitle.right, 12, MainScreenWidth - _keyTitle.right - 15, 20);
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
    [self setHeight:MAX(_selectButton.bottom, _valueTextView.bottom) + 12];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
