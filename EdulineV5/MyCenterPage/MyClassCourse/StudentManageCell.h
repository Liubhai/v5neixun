//
//  StudentManageCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol StudentManageCellDelegate <NSObject>

@optional
- (void)removeStudent:(NSIndexPath *)cellIndexPath;

@end

@interface StudentManageCell : UITableViewCell

@property (weak, nonatomic) id<StudentManageCellDelegate> delegate;

@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *dateLineLabel;
@property (strong, nonatomic) UILabel *introLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIButton *followButton;
@property (strong, nonatomic) NSIndexPath *cellIndex;

- (void)setStudentInfo:(NSDictionary *)dict cellIndexPath:(NSIndexPath *)cellIndexPath;

@end

NS_ASSUME_NONNULL_END
