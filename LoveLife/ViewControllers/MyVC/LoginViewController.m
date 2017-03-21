//
//  LoginViewController.m
//  LoveLife
//
//  Created by 王一成 on 16/1/6.
//  Copyright © 2016年 yangyang. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.leftButton  setImage:[UIImage imageNamed:@"UMS_nav_button_back"] forState:UIControlStateNormal];
    [self setLeftButtonClick:@selector(back)];
    [self createUI];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI
{
    NSArray * buttonArr = @[@"qq.png",@"weixin.jpg",@"sina.png"];
    for (int i = 0; i < buttonArr.count ; i ++) {
        UIButton  * button =[FactoryUI createButtonWithFrame:CGRectMake(i * SCREEN_W / 3, 200, 50, 50) title:nil titleColor:nil imageName:buttonArr[i] backgroundImageName:nil target:self selector:@selector(login:)];
        button.tag = 10 + i;
        [self.view addSubview:button];
    }
}

-(void)login:(UIButton *)button
{
    switch (button.tag - 10) {
        case 0:
        {
            //QQ登录
            
            
            //指定登陆的第三方平台
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            
            //点击之后的回调
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //获取到的用户信息
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                    //保存数据
                    [self saveData:snsAccount];
                    
                    NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                    
                }});

            break;
        }
        case 1:
        {
            //微信登陆
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity * response){
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UMSocialAccountEntity * account =[[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
                    [self saveData:account];
                }
                
            });
            break;
        }
        case 2:
        {
            //新浪登陆
            //指定登陆的第三方平台
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            
            //点击之后的回调
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //获取到的用户信息
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    //保存数据
                    [self saveData:snsAccount];
                    
                    NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                    
                }});
            break;
        }
        default:
            break;
    }
}

//保存数据
-(void)saveData:(UMSocialAccountEntity *)snsAccount
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setObject:snsAccount.userName forKey:@"userName"];
    //                    [user setObject:snsAccount.usid forKey:@"usid"];
    [user setObject:snsAccount.iconURL forKey:@"iconURL"];
    //拿到需要的信息之后返回上一级页面
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
