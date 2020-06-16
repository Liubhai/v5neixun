//
//  CourseCommonCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/7.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseCommonCell : UITableViewCell

@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIView *LeftLineView;
@property (assign, nonatomic) BOOL showOneLine;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showOneLine:(BOOL)oneLine;

- (void)setCourseCommonCellInfo:(NSDictionary *)info searchKeyWord:(NSString *)searchKeyWord;

@end

NS_ASSUME_NONNULL_END
