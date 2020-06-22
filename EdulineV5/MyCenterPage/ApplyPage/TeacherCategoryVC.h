//
//  TeacherCategoryVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/16.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TeacherCategoryVCDelegate <NSObject>

@optional
- (void)chooseCategoryArray:(NSMutableArray *)array;

@end

@interface TeacherCategoryVC : BaseViewController

@property (weak, nonatomic) id<TeacherCategoryVCDelegate> delegate;
@property (strong, nonatomic) NSString *typeString;//默认0【0：课程；1：讲师；2：机构；】

@property (assign, nonatomic) BOOL isChange;// yes 首页过来的 no启动时候选择

@end

NS_ASSUME_NONNULL_END
