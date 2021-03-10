//
//  ExamRecordList.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/3/3.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamRecordList : BaseViewController

@property (strong, nonatomic) NSString *courseType;// 类型( 2 公开考试 4 套卷练习)

@property (strong, nonatomic) NSString *examListType;// 类型(错题本 error、题目收藏 collect)

@end

NS_ASSUME_NONNULL_END
