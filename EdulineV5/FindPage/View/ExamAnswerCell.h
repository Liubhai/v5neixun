//
//  ExamAnswerCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/8.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamIDListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamAnswerCell : UITableViewCell

@property (strong, nonatomic) UIButton *selectButton;
@property (strong, nonatomic) UIButton *mutSelectButton;
@property (strong, nonatomic) UILabel *keyTitle;
@property (strong, nonatomic) UITextView *valueTextView;

@property (strong, nonatomic) UITextView *userInputTextView;//用户输入内容(解答题)

@property (strong, nonatomic) UILabel *gapfillingIndexTitle;
@property (strong, nonatomic) UITextField *userInputTextField;//用户输入内容(填空题)

@property (strong, nonatomic) UIView *clozeBackView;// 完形填空容器

- (void)setAnswerInfo:(ExamDetailOptionsModel *)model examDetail:(ExamDetailModel *)detailModel cellIndex:(NSIndexPath *)cellIndexPath;

/** 针对完形填空 */
- (void)setExamDetail:(ExamDetailModel *)detailModel cellIndex:(NSIndexPath *)cellIndexPath;

@end

NS_ASSUME_NONNULL_END
