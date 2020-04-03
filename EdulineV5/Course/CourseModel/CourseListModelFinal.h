//
//  CourseListModelFinal.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/24.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseListModelFinal : NSObject

@property (assign, nonatomic) BOOL isExpanded;
@property (strong, nonatomic) CourseListModel *model;
@property (assign, nonatomic) CGFloat cellHeight;
@property (strong, nonatomic) NSMutableArray *child;
@property (strong, nonatomic) NSIndexPath *cellIndex;

@property (strong, nonatomic) NSString *courselayer; // 1 一层 2 二层 3 三层(涉及到目录布局) 自己属于第几层样式
@property (strong, nonatomic) NSString *allLayar;// 总共有几层
@property (assign, nonatomic) BOOL isMainPage; // yes 详情页面目录 no 播放页面目录
@property (assign, nonatomic) BOOL isPlaying; // yes 正在播放 no 

+ (CourseListModelFinal *)canculateHeight:(CourseListModel *)model cellIndex:(NSIndexPath *)cellIndex courselayer:(NSString *)courselayer allLayar:(NSString *)allLayar isMainPage:(BOOL)isMainPage;

@end

NS_ASSUME_NONNULL_END
