//
//  ExamDetailViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/5.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamDetailViewController.h"
#import "TYAttributedLabel.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface ExamDetailViewController ()

@end

@implementation ExamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
//    TYAttributedLabel *lable1111 = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 500)];
//
//    NSString *origin = @"<p><span style=\"font-family:'Courier New', Courier, monospace;\">基于大众点评<\/span><span class=\"text-huge\" style=\"color:hsl(0,75%,60%);\">搜索以及推荐<\/span>业务，<span style=\"color:hsl(0,75%,60%);\">从企业实际项<\/span><span class=\"text-big\"><strong>目落地实践的角<\/strong><\/span>度<span class=\"text-big\"><i>出发<\/i><\/span>，<u>在使用<\/u><span class=\"text-big\">S<s>pringBoot加my<\/s><\/span>ba<sub>tis完成用户登<\/sub>录<sup>、注册、商<\/sup>家入<mark class=\"marker-green\">驻以及结<\/mark>合<\/p><hr><ol style=\"list-style-type:decimal;\"><li>搭建运营后台门店服务管理功能后，<\/li><\/ol><figure class=\"table\"><table><tbody><tr><td>12313<\/td><td>&nbsp;<\/td><td>123123<\/td><td>1231<\/td><\/tr><tr><td>123123<\/td><td>&nbsp;<\/td><td>123123<\/td><td>&nbsp;<\/td><\/tr><tr><td>&nbsp;<\/td><td>123123<\/td><td>123123<\/td><td>12321<\/td><\/tr><\/tbody><\/table><\/figure><p>&nbsp;<\/p><p>&nbsp;<\/p><figure class=\"image\"><img src=\"https:\/\/tv5.51eduline.com\/storage\/upload\/20210205\/411b633e76e14e1a78e74511163b5fae.png\"><figcaption>1312323213213<\/figcaption><\/figure><ol style=\"list-style-type:decimal;\"><li>借助ElasticSearch的最新版本ES7逐步迭代，完成高相关性进阶搜索服务，并基于spark mllib2.4.4构建个性化千人千面推荐系统。<\/li><\/ol><figure class=\"image image-style-align-left\"><img src=\"https:\/\/tv5.51eduline.com\/storage\/upload\/20210205\/7366ba7ce69edc489f0d18d46050273a.png\"><\/figure><p>&nbsp;<\/p><p>&nbsp;<\/p><p>挺好挺好挺好挺好1231他<\/p><p>&nbsp;<\/p><p><br>&nbsp;<\/p><p>f（x）=sin<sup>2<\/sup>a<\/p><p>&nbsp;<\/p><p>&nbsp;<\/p>";
//
//    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[origin dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//
//    lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
//    [self.view addSubview:lable1111];
    
//    UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 500)];
//
//    NSString *origin = @"<p><span style=\"font-family:'Courier New', Courier, monospace;\">\U57fa\U4e8e\U5927\U4f17\U70b9\U8bc4</span><span class=\"text-huge\" style=\"color:hsl(0,75%,60%);\">\U641c\U7d22\U4ee5\U53ca\U63a8\U8350</span>\U4e1a\U52a1\Uff0c<span style=\"color:hsl(0,75%,60%);\">\U4ece\U4f01\U4e1a\U5b9e\U9645\U9879</span><span class=\"text-big\"><strong>\U76ee\U843d\U5730\U5b9e\U8df5\U7684\U89d2</strong></span>\U5ea6<span class=\"text-big\"><i>\U51fa\U53d1</i></span>\Uff0c<u>\U5728\U4f7f\U7528</u><span class=\"text-big\">S<s>pringBoot\U52a0my</s></span>ba<sub>tis\U5b8c\U6210\U7528\U6237\U767b</sub>\U5f55<sup>\U3001\U6ce8\U518c\U3001\U5546</sup>\U5bb6\U5165<mark class=\"marker-green\">\U9a7b\U4ee5\U53ca\U7ed3</mark>\U5408</p><hr><ol style=\"list-style-type:decimal;\"><li>\U642d\U5efa\U8fd0\U8425\U540e\U53f0\U95e8\U5e97\U670d\U52a1\U7ba1\U7406\U529f\U80fd\U540e\Uff0c</li></ol><figure class=\"table\"><table><tbody><tr><td>12313</td><td>&nbsp;</td><td>123123</td><td>1231</td></tr><tr><td>123123</td><td>&nbsp;</td><td>123123</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>123123</td><td>123123</td><td>12321</td></tr></tbody></table></figure><p>&nbsp;</p><p>&nbsp;</p><figure class=\"image\"><img src=\"https://tv5.51eduline.com/storage/upload/20210205/411b633e76e14e1a78e74511163b5fae.png\"><figcaption>1312323213213</figcaption></figure><ol style=\"list-style-type:decimal;\"><li>\U501f\U52a9ElasticSearch\U7684\U6700\U65b0\U7248\U672cES7\U9010\U6b65\U8fed\U4ee3\Uff0c\U5b8c\U6210\U9ad8\U76f8\U5173\U6027\U8fdb\U9636\U641c\U7d22\U670d\U52a1\Uff0c\U5e76\U57fa\U4e8espark mllib2.4.4\U6784\U5efa\U4e2a\U6027\U5316\U5343\U4eba\U5343\U9762\U63a8\U8350\U7cfb\U7edf\U3002</li></ol><figure class=\"image image-style-align-left\"><img src=\"https://tv5.51eduline.com/storage/upload/20210205/7366ba7ce69edc489f0d18d46050273a.png\"></figure><p>&nbsp;</p><p>&nbsp;</p><p>\U633a\U597d\U633a\U597d\U633a\U597d\U633a\U597d1231\U4ed6</p><p>&nbsp;</p><p><br>&nbsp;</p><p>f\Uff08x\Uff09=sin<sup>2</sup>a</p><p>&nbsp;</p><p>&nbsp;</p>";
//
//    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[origin dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//
//    lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
//    [lable1111 sizeToFit];
//    [lable1111 setHeight:lable1111.height];
//    [self.view addSubview:lable1111];
    
    // Do any additional setup after loading the view.
}

- (void)getData {
    if (SWNOTEmptyStr(_examIds)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path examPointIdListNet] WithAuthorization:nil paramDic:@{@"point_ids":_examIds,@"module_id":_examType} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    NSArray *pass = [NSArray arrayWithArray:responseObject[@"data"][@"rules"]];
                    if (SWNOTEmptyArr(pass)) {
                        NSDictionary *passDict = [NSDictionary dictionaryWithDictionary:pass[0]];
                        NSArray *passArray = [NSArray arrayWithArray:passDict[@"data"]];
                        if (SWNOTEmptyArr(passArray)) {
                            NSDictionary *passfinalDict = [NSDictionary dictionaryWithDictionary:passArray[0]];
                            [self getExamDetailForExamIds:[NSString stringWithFormat:@"%@",passfinalDict[@"topic_id"]]];
                        }
                    }
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)getExamDetailForExamIds:(NSString *)examIds {
    if (SWNOTEmptyStr(examIds)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path examPointDetailDataNet] WithAuthorization:nil paramDic:@{@"topic_id":examIds} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    
                    NSArray *pass = [NSArray arrayWithArray:responseObject[@"data"]];
                    if (SWNOTEmptyArr(pass)) {
                        NSString *origin = [NSString stringWithFormat:@"%@",pass[0][@"title"]];
                        
//                        WKWebIntroview *view = [[WKWebIntroview alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 500)];
//                        view.backgroundColor = [UIColor whiteColor];
//                        view.scrollView.scrollEnabled = NO;
//                        [view loadHTMLString:origin baseURL:nil];
//                        [self.view addSubview:view];
                        
//                        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
//                        [web loadHTMLString:origin baseURL:nil];
//                        [self.view addSubview:web];
//
                        UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 100)];
                        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[origin dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];

                        lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
                        [lable1111 sizeToFit];
                        [lable1111 setHeight:lable1111.height];
                        [self.view addSubview:lable1111];
                    }
                    
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
