//
//  MyViewController.m
//  LoveLife
//
//  Created by 杨阳 on 15/12/29.
//  Copyright © 2015年 yangyang. All rights reserved.
//

#import "MyViewController.h"
#import "AppDelegate.h"
#import "QRCodeGenerator.h"
#import "GuanYuViewController.h"
#import "MyCollectionViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView * _tableView;
    UIImageView * _headerImageView;
    //夜间模式
    UIView * _darkView;
}

//图标
@property (nonatomic,retain) NSArray *logoArray;
//标题
@property (nonatomic,retain) NSArray * titleArray;
@end

@implementation MyViewController


static float  headerHeight = 200;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNav];
    self.titleArray = @[@"我的",@"清理缓存",@"夜间模式",@"推送消息",@"关于"];
    self.logoArray = @[@"iconfont-iconfontaixinyizhan",@"iconfont-lajitong",@"iconfont-yejianmoshi",@"iconfont-zhengguiicon40",@"iconfont-guanyu"];
    [self createUI];
    
    
}

-(void)createUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    
    _darkView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    
    
    _headerImageView =[FactoryUI createImageViewWithFrame:CGRectMake(0, -headerHeight, SCREEN_W, headerHeight) imageName:@"welcome1"];
    [_tableView addSubview:_headerImageView];
    
    //设置tableView的内容从header开始显示
    _tableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0);
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;//默认值为44
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (indexPath.row ==0 ||indexPath.row == 4 ||indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (indexPath.row == 2 || indexPath.row == 3 ) {
            UISwitch * swi = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_W - 60, 5, 50, 30)];
            //设置颜色
            swi.onTintColor = [UIColor greenColor];
            swi.tag = indexPath.row;
            [swi addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:swi];
        
        }
    }
    cell.imageView.image = [UIImage imageNamed:self.logoArray[indexPath.row]];
    cell.textLabel.text  = self.titleArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 4) {
//        GuanYuViewController * gvc = [[GuanYuViewController alloc] init];
//        [self.navigationController pushViewController:gvc animated:YES];
//    }

    switch (indexPath.row) {
        case 0:
        {
            //收藏
            MyCollectionViewController * vc =[[MyCollectionViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            //清li缓存
            [self foldeSizeWithPath:[self getPath]];
            break;
        }
        case 2:
            break;
            case 4:
        {
            GuanYuViewController * gvc = [[GuanYuViewController alloc] init];
                    [self.navigationController pushViewController:gvc animated:YES];
            break;
        }

        default:
            break;
    }
 
}

#pragma mark -- 
//switch的响应方法
-(void)changeOption:(UISwitch *)swi
{
    if (swi.tag == 2) {
        //夜间模式
        if (swi.on) {
            
            UIApplication * app = [UIApplication sharedApplication];
            AppDelegate * delegate = app.delegate;
            //设置view的背景色
            
            _darkView.backgroundColor = [UIColor blackColor];
            _darkView.alpha = 0.2;
            //关掉view的交互属性
            _darkView.userInteractionEnabled = NO;
            [delegate.window addSubview:_darkView];
        }
        else
        {
            [_darkView removeFromSuperview];
        }
    }
    else
    {
        //推送消息
        if(swi.on)
        {
            //创建本地推送任务
            [self createLocalNotication];
        }
        else
        {
            //取消本地推送任务
            [self cancleLocalNotication];
        }
    }
}

#pragma mark - 取消本地推送
-(void)cancleLocalNotication
{
    //第一种，全部取消
    //[[UIApplication sharedApplication]cancelAllLocalNotifications];
    //第二种，取消制定条件下的推送任务
    NSArray * array = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification * notication in array) {
        if ([notication.alertBody isEqualToString:@"你好久没来LoveLife"]) {
            
           
            [[UIApplication sharedApplication]cancelLocalNotification:notication];
            
            //取消推送任务icon的数值
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            
        }
    }
    
}
#pragma mark - 创建本地推送
-(void)createLocalNotication
{
    //解决ios8以后本地推送无法接受到推送消息问题
    //获取系统版本号
    float sysyemVesion = [[UIDevice currentDevice].systemVersion floatValue];
    if (sysyemVesion >= 8.0) {
        //设置推送消息的类型
        UIUserNotificationType  type =UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        //将类型添加到设置里
        UIUserNotificationSettings * setting = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        
        //将设置内容注册到系统管理中
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
    
    UILocalNotification * localNotication = [[UILocalNotification alloc] init];
    
    //设置从当前开始什么时候开始推送
    localNotication.fireDate = [NSDate dateWithTimeIntervalSinceNow:30];
    //重复推送的周期
    localNotication.repeatInterval = NSCalendarUnitDay;
    //设置推送的时区
    localNotication.timeZone = [NSTimeZone defaultTimeZone];
    //设置推送的内容
    localNotication.alertBody = @"你好久没来LoveLife";
    //设置推送音效
    localNotication.soundName = @"";
    //设置推送提示消息的个数
    localNotication.applicationIconBadgeNumber = 1;
    //将推送任务添加到系统管理中
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotication];
    
}

#pragma mark -清理缓存
//计算文件大小
-(NSString *)getPath
{
//    缓存存在于Library文件夹下的cache文件夹
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    return path;
}

-(CGFloat) foldeSizeWithPath:(NSString *)path
{
    //初始化一个文件管理类
    NSFileManager * fileManager = [NSFileManager defaultManager];
    CGFloat folderSize = 0.0;
    
    //加判断，若文件夹存在计算大小，否则直接返回
    if ([fileManager fileExistsAtPath:path]) {
        //存在则获取文件夹下的文件路径
        NSArray * fileArray = [fileManager subpathsAtPath:path];
        for (NSString * fileName in fileArray) {
            
            //获取子文件
            NSString * subFile = [path stringByAppendingPathComponent:fileName];
            long fileSize = [fileManager attributesOfItemAtPath:subFile error:nil].fileSize;//字节数
            folderSize += fileSize / 1024.0 / 1024.0 ;
            
        }
        //删除文件
        [self showTipView:folderSize];
        return folderSize;
    }
    return 0;
    
    
    

   // return folderSize;
}

-(void)showTipView:(CGFloat) folderSize
{
    if (folderSize > 0.01) {
        
        //提示用户清理缓存
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"缓存中有%.2fM，是否清楚?",folderSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
    }
    else{
        //提示应清除
        
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经清理" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //确定删除
        [self claerCacheWithPath:[self getPath]];
    }
}

-(void)claerCacheWithPath:(NSString *) path
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager isExecutableFileAtPath:path]) {
        //存在删除
   
        NSArray * subfile = [manager subpathsAtPath:path];
        for (NSString * fileName in subfile) {
            
            //如有有需要，可以过滤掉不想删除的文件
            if ([fileName hasSuffix:@".mp4"]) {
                NSLog(@"不删除");
            }
            else
            {
                NSString * absolutePath = [path stringByAppendingPathComponent:fileName];
                [manager removeItemAtPath:absolutePath error:nil];
            }
        }
    }
}
#pragma mark - scrollerView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    ..实现思路：通过改变scroolerView的偏移量来改变图片的Frame。
    if(scrollView == _tableView)
    {
        NSLog(@"%f",scrollView.contentOffset.y);
        //获取scollerVIew的偏移量
        CGFloat yOffset = scrollView.contentOffset.y;
        //yOffset初始值为－200，所以(yOffset + headerHeight)为拉伸增加的高度
        CGFloat xOffset = (yOffset + headerHeight) / 2;
        if (yOffset < -headerHeight) {
            CGRect rect =_headerImageView.frame;
            //改变imageView的frame值
            
            //imageView的父视图为TableView，imageView的初始纵坐标值为—200，当拉伸时。yOffset在—200基础上向下滑动，即减小。所以rect.origin.y = yOffset;
            rect.origin.y = yOffset;
            rect.size.height =  -yOffset;
            rect.origin.x = xOffset;
            rect.size.width = SCREEN_W + 2 * fabs(xOffset);
            _headerImageView.frame = rect;
        }
    }
}

-(void)settingNav
{
    self.titleLabel.text = @"我的";
    
    //登陆按钮
    [self.rightButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self setRightButtonClick:@selector(rightButtonClick)];
}

-(void)rightButtonClick
{
    LoginViewController * vc =[[ LoginViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)viewWillDisappear:(BOOL)animated
//
//{
//    
//    [super viewWillDisappear:animated];
//    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
//    [delegate.drawerVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//    
//    [delegate.drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
//
//    
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
//    [delegate.drawerVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    
//    [delegate.drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
