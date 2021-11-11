//
//  LabelUserInfo.h
//  NewCCDemo
//
//  Created by cc on 2016/11/23.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldUserInfo : UITextField

@property(nonatomic,strong)UILabel              *leftLabel;
@property(nonatomic,strong)UIView               *leftLabelView;
- (void)textFieldWithLeftText:(NSString *)leftText placeholder:(NSString *)placeholder lineLong:(BOOL)lineLong text:(NSString *)text ;
- (void)textFieldWithLeftText:(NSString *)leftText placeholderAttri:(NSAttributedString *)placeholder lineLong:(BOOL)lineLong text:(NSString *)text;

@end
