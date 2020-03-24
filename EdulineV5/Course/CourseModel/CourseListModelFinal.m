//
//  CourseListModelFinal.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/24.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseListModelFinal.h"
#import "V5_Constant.h"

@implementation CourseListModelFinal

+ (CourseListModelFinal *)canculateHeight:(CourseListModel *)model cellIndex:(nonnull NSIndexPath *)cellIndex courselayer:(nonnull NSString *)courselayer allLayar:(nonnull NSString *)allLayar isMainPage:(BOOL)isMainPage {
    CourseListModelFinal *modelFinal = [[CourseListModelFinal alloc] init];
    modelFinal.model = model;
    modelFinal.allLayar = allLayar;
    modelFinal.courselayer = courselayer;
    modelFinal.isMainPage = isMainPage;
    if (modelFinal.isExpanded) {
        if (SWNOTEmptyArr(modelFinal.child)) {
            modelFinal.cellHeight = 50 * (modelFinal.child.count + 1);
        } else {
            modelFinal.cellHeight = 50;
        }
    } else {
        modelFinal.cellHeight = 50;
    }
    return modelFinal;
}

- (void)setIsExpanded:(BOOL)isExpanded {
    _isExpanded = isExpanded;
    if (isExpanded) {
        if (SWNOTEmptyArr(_child)) {
            _cellHeight = 50 * (_child.count + 1);
        } else {
            _cellHeight = 50;
        }
    } else {
        _cellHeight = 50;
    }
}

@end
