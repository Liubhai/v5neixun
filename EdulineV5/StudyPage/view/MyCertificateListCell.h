//
//  MyCertificateListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/3/30.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCertificateListCell : UITableViewCell

@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) UILabel *fromLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImageView *faceImage;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *getTimeLabel;
@property (strong, nonatomic) UILabel *datelineLabel;

- (void)setMyCertificateListCellInfo:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
