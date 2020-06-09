//
//  TeacherMainPageVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeacherMainPageVC : BaseViewController

@property (strong, nonatomic) NSString *teacherId;
@property (strong, nonatomic) NSDictionary *teacherInfoDict;

@end

NS_ASSUME_NONNULL_END
