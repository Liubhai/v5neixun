//
//  ExamCalculateHeight.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/17.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamCalculateHeight.h"

@implementation ExamCalculateHeight

- (instancetype)initWithExamDetailModel:(ExamDetailModel *)model opitionModel:(nonnull ExamDetailOptionsModel *)opModel {
    self = [super init];
    
    _examAnswerCellExamDetailModel = model;
    _examAnswerCellOpitionModel = opModel;
    _cellHeight = [self calculateValueTextViewHeight:model answerValue:opModel.mutvalue];
    /* 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答题 **/
    return self;
}

- (CGFloat)calculateValueTextViewHeight:(ExamDetailModel *)detailModel answerValue:(NSMutableAttributedString *)value {
    if ([detailModel.question_type isEqualToString:@"1"] || [detailModel.question_type isEqualToString:@"2"] || [detailModel.question_type isEqualToString:@"3"] || [detailModel.question_type isEqualToString:@"4"]) {
        
        UITextView *valueTextView = [[UITextView alloc] initWithFrame:CGRectMake(15 + 20 + 42, 12, MainScreenWidth - (15 + 20 + 42) - 15, 20)];
        if ([detailModel.question_type isEqualToString:@"2"]) {
            valueTextView.frame = CGRectMake(15 + 20 + 10, 12, MainScreenWidth - 15 - 20 - 10 - 15, 20);
        }
        NSMutableAttributedString *mutable = [[NSMutableAttributedString alloc] initWithAttributedString:value];
        
        if (value) {
            NSString *pass = [NSString stringWithFormat:@"%@",[mutable attributedSubstringFromRange:NSMakeRange(mutable.length - 1, 1)]];
            if ([[pass substringToIndex:1] isEqualToString:@"\n"]) {
                [mutable replaceCharactersInRange:NSMakeRange(mutable.length - 1, 1) withString:@""];
            }
        }
        [mutable addAttributes:@{NSFontAttributeName:SYSTEMFONT(15)} range:NSMakeRange(0, value.length)];
        
        valueTextView.attributedText = [[NSAttributedString alloc] initWithAttributedString:mutable];
        [valueTextView sizeToFit];
        valueTextView.showsVerticalScrollIndicator = NO;
        valueTextView.showsHorizontalScrollIndicator = NO;
        valueTextView.editable = NO;
        valueTextView.scrollEnabled = NO;
        [valueTextView setHeight:valueTextView.height];
        return MAX(12 + 7 + 20, valueTextView.bottom) + 12;
    } else if ([detailModel.question_type isEqualToString:@"5"]) {
        return 12 + 36 + 12;
    } else if ([detailModel.question_type isEqualToString:@"8"]) {
        return 12 + 120 + 12;
    } else if ([detailModel.question_type isEqualToString:@"7"]) {
        // 每一个topic数组对应的detailmodel
        UIView *clozeBackView = [[UIView alloc] initWithFrame:CGRectMake(15 + 30 + 8, 12, MainScreenWidth - 15 - (15 + 30) - 8, 0)];
        [clozeBackView removeAllSubviews];
        CGFloat XX = 0.0;
        CGFloat YY = 0.0;
        CGFloat cellheight = 0;
        for (int i = 0; i<detailModel.options.count; i++) {
            ExamDetailOptionsModel *optionModel = detailModel.options[i];
            NSString *secondTitle = [NSString stringWithFormat:@"%@.%@",optionModel.key,optionModel.value];
            CGFloat secondBtnWidth = [secondTitle sizeWithFont:SYSTEMFONT(15)].width + 4 + 6 + 20;
            UIButton *secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, secondBtnWidth, 20)];
            [secondBtn setImage:Image(@"exam_radio_icon_nor") forState:0];
            [secondBtn setImage:[Image(@"exam_radio_icon_sel") converToMainColor] forState:UIControlStateSelected];
            [secondBtn setTitle:secondTitle forState:0];
            [secondBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
            secondBtn.titleLabel.font = SYSTEMFONT(15);

            [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6/2.0, 0, -6/2.0)];
            [secondBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -6/2.0, 0, 6/2.0)];
            
            if ((secondBtnWidth + XX) > clozeBackView.width) {
                XX = 0;
                YY = YY + 10 + 20;
            }
            secondBtn.frame = CGRectMake(XX, YY, secondBtnWidth, 20);
            XX = secondBtn.right + 10;
            if (i == detailModel.options.count - 1) {
                cellheight = secondBtn.bottom + 12;
            }
            [clozeBackView addSubview:secondBtn];
        }
        return cellheight;
    }
    return 0;
}

/** 完形填空 */
- (instancetype)initWithGapfillingExamDetailModel:(ExamDetailModel *)gapfillingModel examDetailModel:(ExamDetailModel *)model opitionModel:(ExamDetailOptionsModel *)opModel {
    self = [super init];
    
    _examAnswerCellExamDetailModel = model;
    _examAnswerCellOpitionModel = opModel;
    _gapfillingExamDetailModel = gapfillingModel;
    _cellHeight = [self calculateValueGapfillingModelTextViewHeight:gapfillingModel examDetailModel:model answerValue:opModel.mutvalue];
    /* 1:单选 2:判断 3:多选 4:不定项 5:填空 6:材料 7:完形填空 8:简答题 **/
    return self;
}

- (CGFloat)calculateValueGapfillingModelTextViewHeight:(ExamDetailModel *)gapfillingModeldetailModel examDetailModel:(ExamDetailModel *)detailModel answerValue:(NSMutableAttributedString *)value {
    // 每一个topic数组对应的detailmodel
    UIView *clozeBackView = [[UIView alloc] initWithFrame:CGRectMake(15 + 30 + 8, 12, MainScreenWidth - 15 - (15 + 30) - 8, 0)];
    [clozeBackView removeAllSubviews];
    CGFloat XX = 0.0;
    CGFloat YY = 0.0;
    CGFloat cellheight = 0;
    for (int i = 0; i<detailModel.options.count; i++) {
        ExamDetailOptionsModel *optionModel = detailModel.options[i];
        NSString *secondTitle = [NSString stringWithFormat:@"%@.%@",optionModel.key,optionModel.value];
        CGFloat secondBtnWidth = [secondTitle sizeWithFont:SYSTEMFONT(15)].width + 4 + 6 + 20;
        UIButton *secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(XX, YY, secondBtnWidth, 20)];
        [secondBtn setImage:Image(@"exam_radio_icon_nor") forState:0];
        [secondBtn setImage:[Image(@"exam_radio_icon_sel") converToMainColor] forState:UIControlStateSelected];
        [secondBtn setTitle:secondTitle forState:0];
        [secondBtn setTitleColor:EdlineV5_Color.textFirstColor forState:0];
        secondBtn.titleLabel.font = SYSTEMFONT(15);

        [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6/2.0, 0, -6/2.0)];
        [secondBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -6/2.0, 0, 6/2.0)];
        
        if ((secondBtnWidth + XX) > clozeBackView.width) {
            XX = 0;
            YY = YY + 10 + 20;
        }
        secondBtn.frame = CGRectMake(XX, YY, secondBtnWidth, 20);
        XX = secondBtn.right + 10;
        if (i == detailModel.options.count - 1) {
            cellheight = secondBtn.bottom + 12 + 5;
        }
        [clozeBackView addSubview:secondBtn];
    }
    return cellheight;
}


@end
