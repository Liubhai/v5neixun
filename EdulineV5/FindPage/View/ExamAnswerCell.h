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
@property (strong, nonatomic) UILabel *keyTitle;
@property (strong, nonatomic) UITextView *valueTextView;

- (void)setAnswerInfo:(ExamDetailOptionsModel *)model examDetail:(ExamDetailModel *)detailModel;

@end

NS_ASSUME_NONNULL_END
