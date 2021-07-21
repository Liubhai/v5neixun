//
//  TeacherCategoryVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/16.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "TeacherCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TeacherCategoryVCDelegate <NSObject>

@optional
/** 多选时候 */
- (void)chooseCategoryArray:(NSMutableArray *)array;

/** 单选时候(除去选择意向课程) */
- (void)chooseCategoryId:(NSString *)categoryId;

/** 单选需要展示分类名称的时候 */
- (void)chooseCategoryModel:(TeacherCategoryModel *)model;

@end

@interface TeacherCategoryVC : BaseViewController

@property (weak, nonatomic) id<TeacherCategoryVCDelegate> delegate;
@property (strong, nonatomic) NSString *typeString;//默认0【0：课程；1：讲师；2：机构；3：考试；4：文库；5：资讯】

@property (strong, nonatomic) NSString *mhm_id;//机构id

@property (assign, nonatomic) BOOL isChange;// yes 首页过来的 no启动时候选择

@property (assign, nonatomic) BOOL isDownExpend;// 是当前页面展开

@property (assign, nonatomic) CGFloat tableviewHeight;// 是当前页面展开

@property (assign, nonatomic) BOOL isMainPage;// 是不是课程主页

@property (assign, nonatomic) BOOL isInstitutionApply;// 是不是机构认证请求所属行业

@property (assign, nonatomic) BOOL isApply;// 是不是认证请求所属行业

@end

NS_ASSUME_NONNULL_END
