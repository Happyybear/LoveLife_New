//
//  ArticalDetailViewController.m
//  LoveLife
//
//  Created by 杨阳 on 15/12/30.
//  Copyright © 2015年 yangyang. All rights reserved.
//

#import "ArticalDetailViewController.h"
#import "DBManager.h"
#import "AppDelegate.h"
@interface ArticalDetailViewController ()

@end

@implementation ArticalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNav];
    [self createUI];
}


- (void)viewWillDisappear:(BOOL)animated

{
    
    [super viewWillDisappear:animated];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.drawerVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    [delegate.drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    
    
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    DBManager * manager = [DBManager defaultManager];
    if ([manager isHasDataIDFromTable:self.readModel.dataID]) {
        UIButton * collect = [self.view viewWithTag:10];
        collect.selected = YES;
    }
}
#pragma mark - 创建UI
-(void)createUI
{
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    //loadHTMLString加载的类似标签式的字符串，loadRequest加载的是网址
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:ARTICALDETAILURL,self.readModel.dataID]]]];
    //使得webView适应屏幕大小
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    //webView与javaSript的交互
    
    UIButton *collecButton = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W - 50, 50, 40, 40) title:nil titleColor:nil imageName:@"iconfont-iconfontshoucang.png" backgroundImageName:nil target:self selector:@selector(collect:)];
    [self.view addSubview:collecButton];
    collecButton.tag = 10;
    [collecButton setImage:[UIImage imageNamed:@"iconfont-iconfontshoucang-2"] forState:UIControlStateSelected];
}


-(void)collect:(UIButton *)button{
    button.selected = YES;
    DBManager *manager = [DBManager defaultManager];
    if ([manager isHasDataIDFromTable:self.readModel.dataID]) {
        //说明已收藏
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经收藏" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        //ios9之后的提示框
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请不要重复收藏" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:alert1];
//        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        //未曾收藏,则插入一条数据
        [manager insertDataModel:self.readModel];
    }
}


#pragma mark - 设置导航
-(void)settingNav
{
    self.titleLabel.text = @"详情";
    [self.leftButton setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_pressed"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"iconfont-fenxiang"] forState:UIControlStateNormal];
    
    [self setLeftButtonClick:@selector(leftButtonClick)];
    [self setRightButtonClick:@selector(rightButtonClick)];
}

#pragma mark - 按钮响应函数
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
-(void)rightButtonClick
{
    //下载网络图片
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.readModel.pic]]];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:APPKEY shareText:[NSString stringWithFormat:ARTICALDETAILURL,self.readModel.dataID] shareImage:image shareToSnsNames:@[UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline] delegate:nil];
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
