//
//  UITableView+EmptyData.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/12.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "UITableView+EmptyData.h"

@implementation UITableView (EmptyData)

- (void)tableViewDisplayWitMsg:(NSString *)message img:(NSString *)imageName ifNecessaryForRowCount:(NSUInteger)rowCount isLoading:(BOOL)isLoding tableViewShowHeight:(CGFloat)height {
    
    if (rowCount == 0&&!isLoding) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        UIView *placeV = [[UIView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetHeight(self.frame))];
        placeV.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *placeImg;
        placeImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,(CGRectGetHeight(self.frame) - (150 + 20 + 10)) / 2.0,CGRectGetWidth([UIScreen mainScreen].bounds),150)];//CGRectGetHeight([UIScreen mainScreen].bounds)-height+(height-150)/2.0
        placeImg.contentMode = UIViewContentModeScaleAspectFit;
        placeImg.image = [UIImage imageNamed:imageName];
        [placeV addSubview:placeImg];
        
        messageLabel.frame = CGRectMake(0, CGRectGetMaxY(placeImg.frame)+10, CGRectGetWidth(placeImg.frame), 20);
        [placeV addSubview:messageLabel];
        self.backgroundView = placeV;
    } else {
        self.backgroundView = nil;
    }
    
}

@end
