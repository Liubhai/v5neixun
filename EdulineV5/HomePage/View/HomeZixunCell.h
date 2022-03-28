//
//  HomeZixunCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/28.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeZixunCellDelegate <NSObject>

@optional
- (void)goToZixunDetailPage:(NSString *)teacherId;

@end

@interface HomeZixunCell : UITableViewCell

@property (weak, nonatomic) id<HomeZixunCellDelegate> delegate;

@property (strong, nonatomic) UIScrollView *teacherScrollView;
@property (strong, nonatomic) NSMutableArray *teacherInfoArray;

- (void)setTeacherArrayInfo:(NSMutableArray *)infoArray;

@end

NS_ASSUME_NONNULL_END
