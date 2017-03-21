//
//  LeftViewController.m
//  LoveLife
//
//  Created by 杨阳 on 15/12/29.
//  Copyright © 2015年 yangyang. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "FoodViewController.h"
#import "HomeViewController.h"
#import "MyTabBarViewController.h"
@interface LeftViewController ()
{
    UIImageView * headImage;
    UILabel * name;
}
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(255, 156, 187, 1);
    
    headImage = [FactoryUI createImageViewWithFrame:CGRectMake((SCREEN_W - 100 - 80) / 2, 80, 80, 80) imageName:nil];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 40;
    [self.view addSubview:headImage];
    
    //昵称
    name =[FactoryUI createLabelWithFrame:CGRectMake(0, headImage.frame.size.height + headImage.frame.origin.y + 10, SCREEN_W - 100, 30) text:nil textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:18]];
    name.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:name];
    
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(200, 200, 40, 40);
    [self.view addSubview:back];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    back.backgroundColor = [UIColor redColor];
    
    UIButton * back1 = [UIButton buttonWithType:UIButtonTypeCustom];
    back1.frame = CGRectMake(200, 250, 40, 40);
    [self.view addSubview:back1];
    [back1 addTarget:self action:@selector(back1) forControlEvents:UIControlEventTouchUpInside];
    back1.backgroundColor = [UIColor redColor];

   
}

//测试返回
-(void)back
{
    
//    [self.mm_drawerController popoverPresentationController];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
         MyTabBarViewController *tabv = (MyTabBarViewController *)self.mm_drawerController.centerViewController;
        HomeViewController *hv = (HomeViewController *)tabv.homenVc;
        FoodViewController * fv = [[FoodViewController alloc]init];
        //push新的页面
//        [hv.navigationController pushViewController:fvc animated:YES];
        //tabbar跳转
        tabv.selectedIndex = 2;

    }];
}



-(void)viewWillAppear:(BOOL)animated
{
    //
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [headImage sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"iconURL"]]];
    name.text = [user objectForKey:@"userName"];
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
