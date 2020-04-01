//
//  FindListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/1.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FindListCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *typeIcon;
@property (strong, nonatomic) UILabel *typeTitle;
@property (strong, nonatomic) UIImageView *rightIcon;
@property (strong, nonatomic) UIView *lineView;

- (void)setFindListInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndex cellType:(BOOL)cellType;

@end

NS_ASSUME_NONNULL_END
