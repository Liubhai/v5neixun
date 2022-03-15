//
//  ExamNewSecendTypeVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/11.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "TeacherCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ExamNewSecendTypeVCDelegate <NSObject>

@optional
- (void)chooseExamType:(NSDictionary *)info;

@end

@interface ExamNewSecendTypeVC : BaseViewController

@property (weak, nonatomic) id<ExamNewSecendTypeVCDelegate> delegate;
@property (strong, nonatomic) NSString *typeId;// 当前选中的类型
@property (strong, nonatomic) NSString *typeString;// 区分课程还是公开考试

@end

NS_ASSUME_NONNULL_END
