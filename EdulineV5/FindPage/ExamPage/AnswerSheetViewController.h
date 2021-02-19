//
//  AnswerSheetViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/26.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnswerSheetViewController : BaseViewController

@property (strong, nonatomic) NSMutableArray *examArray;// 整个试卷的题目id列表(列表里面的 has_answered 字段来判断是否作答)

@end

NS_ASSUME_NONNULL_END
