//
//  GuanYuViewController.m
//  LoveLife
//
//  Created by 王一成 on 16/1/5.
//  Copyright © 2016年 yangyang. All rights reserved.
//

#import "GuanYuViewController.h"
#import "QRCodeGenerator.h"
#import "AppDelegate.h"
@interface GuanYuViewController ()

@end

@implementation GuanYuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"关于";
    
    self.leftButton = [FactoryUI createButtonWithFrame:CGRectMake(10, 10, 40, 40) title:nil titleColor:nil imageName:nil backgroundImageName:nil target:self selector:@selector(back)];
    [self.leftButton setImage:[UIImage imageNamed:@"iconfont-back"] forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_W - 200) / 2, (SCREEN_H - 200) / 2, 200, 200)];
    imageView.image = [QRCodeGenerator qrImageForString:@"www.baidu.com" imageSize:300];
    //300是二维码的清晰度，数值越大二维码越清晰
    
    [self.view addSubview:imageView];
}





-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
