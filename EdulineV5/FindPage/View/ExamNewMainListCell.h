//
//  ExamNewMainListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/11.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExamNewMainListCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *faceImageView;

- (void)setExamNewMainCellInfo:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
