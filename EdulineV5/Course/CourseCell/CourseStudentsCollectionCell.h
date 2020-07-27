//
//  CourseStudentsCollectionCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseStudentsCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *nameLabel;

- (void)setStudentInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
