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

@end

NS_ASSUME_NONNULL_END
