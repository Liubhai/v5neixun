//
//  ExamMainListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/13.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExamMainListCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *typeIcon;
@property (strong, nonatomic) UILabel *typeTitle;

- (void)setExamMainListInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndex;

@end

NS_ASSUME_NONNULL_END
