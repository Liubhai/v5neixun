//
//  AnswerSheetViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/26.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^chooseOtherExam)(NSString *examId);

@interface AnswerSheetViewController : BaseViewController

@property (nonatomic, strong) chooseOtherExam chooseOtherExam;
@property (assign, nonatomic) BOOL isPaper; // yes 是试卷 no 是试题
@property (strong, nonatomic) NSMutableArray *examArray;// 整个试卷的题目id列表(列表里面的 has_answered 字段来判断是否作答)

@property (strong, nonatomic) NSString *sheetTitle;

@property (strong, nonatomic) NSIndexPath *currentIndexpath;

@end

NS_ASSUME_NONNULL_END
