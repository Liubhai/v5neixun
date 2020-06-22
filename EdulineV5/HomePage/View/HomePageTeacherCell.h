//
//  HomePageTeacherCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomePageTeacherCellDelegate <NSObject>

@optional
- (void)goToTeacherMainPage:(NSString *)teacherId;

@end

@interface HomePageTeacherCell : UITableViewCell

@property (weak, nonatomic) id<HomePageTeacherCellDelegate> delegate;

@property (strong, nonatomic) UIScrollView *teacherScrollView;
@property (strong, nonatomic) NSMutableArray *teacherInfoArray;

- (void)setTeacherArrayInfo:(NSMutableArray *)infoArray;

@end

NS_ASSUME_NONNULL_END
