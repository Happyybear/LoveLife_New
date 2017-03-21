//
//  PlayMusicViewController.m
//  LoveLife
//
//  Created by 王一成 on 16/1/5.
//  Copyright © 2016年 yangyang. All rights reserved.
//

#import "PlayMusicViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface PlayMusicViewController ()<AVAudioPlayerDelegate>
{
    UILabel * _titleLabel;
    UILabel * _authorLabel;
    UIImageView * _backImage;
    //指示条
    UISlider * _slider;
    
    AVAudioPlayer * _player;
    
    
    
}

@property (nonatomic,retain) NSTimer * timer;
@end

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage"]];
    
    [self createUI];
    
    //创建队列组
    dispatch_group_t  group = dispatch_group_create();
    
    //创建队列
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //启用异步方法
    dispatch_group_async(group, queue, ^{
        //创建播放器
        [self createAVAudioPlayer];
    });
    
    
    
    //创建一个定时器，事实改变slider
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(change) userInfo:nil repeats:YES];
    
    
    
    //设置后台播放模式,AVAudioSession是音频会话
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置类型
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //进入后台，仍然保持播放.
    [audioSession setActive:YES error:nil];
    
    //播出耳机后暂停播放，通过观察者检测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceActive:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    
}


#pragma mark -监听是否有耳机
-(void)deviceActive:(NSNotification *)notification
{
  
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        
        
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        //播放按钮
        UIButton * button = (UIButton *)[self.view viewWithTag:11];
        
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            if ([_player isPlaying])
            {
                [button setImage:[UIImage imageNamed:@"iconfont-musicbofang"] forState:UIControlStateNormal];
                [_player pause];
                self.timer.fireDate=[NSDate distantFuture];
            }
        }
    }
}

#pragma mark - 创建音频播放器

-(void)createAVAudioPlayer
{
    //NSURL创建
    //播放本地的URL
//    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:@""] error:nil];
    
    //使用NSData创建
    _player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlArray[_currentIndex]]] error:nil];
    //设置代理
    _player.delegate = self;
    //设置播放音量
    _player.volume = 0.5;
    //设置当前的播放进度
    _player.currentTime = 0;
    //设置循环次数
    _player.numberOfLoops = -1;//负数表示无限循环播放，0表示播放一次。
    //直读属性
//    _player.isPlaying;//是否正在播放
//    _player.numberOfChannels ;//声道数
//    _player.duration; //持续时间
    
    
    //预播放，将播放资源添加到播放器中，播放器自己播配播放队列
    [_player prepareToPlay];
   
}


#pragma mrak -协议方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
//        说明音频文件正常播放
    }
    else
    {
        //音频虽然播放完了，但数据解码错误
    }
}

//ios8之后废弃，自动处理
//开始被中断，比如Home键或者来电打断
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    //暂停
    [_player pause];
}
//中断打断
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    //继续
    [_player play];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"对音频文件解码错误");
}
#pragma mark -创建UI
-(void)createUI
{
    //标题
    _titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(0, 40, SCREEN_W, 80) text:nil textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:23]];
    _titleLabel.text = self.model.title;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    
    //作者
    _authorLabel = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W - 100, _titleLabel.frame.size.height + _titleLabel.frame.origin.y +10, 100, 50) text:nil textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15]];
    _authorLabel.text = self.model.artist;

    [self.view addSubview:_authorLabel];
    
    //图片
    _backImage = [FactoryUI createImageViewWithFrame:CGRectMake(10,_authorLabel.frame.size.height + _authorLabel.frame.origin.y + 15,  SCREEN_W - 20, 250) imageName:nil];
    
    [self.view addSubview:_backImage];
    //返回按钮
    UIButton * back = [FactoryUI createButtonWithFrame:CGRectMake(10, 40, 40, 40) title:nil titleColor:nil imageName:@"iconfont-back" backgroundImageName:nil target:self selector:@selector(back)];
    [self.view addSubview:back];
    
    //指示条
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(10, _backImage.frame.size.height + _backImage.frame.origin.y + 50, SCREEN_W - 20, 20)];
    
    //初始值
    _slider.value = 0;
    
    //添加时事件
    [_slider addTarget:self action:@selector(slider) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
    
    //创建按钮
    NSArray * buttonImageArr = @[@"iconfont-bofangqishangyiqu",@"iconfont-musicbofang",@"iconfont-bofangqixiayiqu"];
    for ( int i = 0; i < buttonImageArr.count; i ++) {
        UIButton * button = [FactoryUI createButtonWithFrame:CGRectMake(100 + i * 60 , _slider.frame.size.height + _slider.frame.origin.y + 10, 40, 40) title:nil titleColor:nil imageName:buttonImageArr[i] backgroundImageName:nil target:self selector:@selector(playBuutonClick:)];
        button.tag = 10 + i;
        [self.view addSubview:button];
    }
}


#pragma mark -  上一首
-(void)playBuutonClick:(UIButton *)button
{
    switch (button.tag - 10) {
        case 0:
            //上一曲
            [_player stop];
           
            if (_currentIndex == 0) {
                _currentIndex = (int)self.urlArray.count - 1;
            }
                _currentIndex --;
            
            [self createAVAudioPlayer];
            [_player play];
            break;
        case 1:
            //播放／暂停
            //判断如果正在播放，则暂停，改变按钮的状态为播放
            if (_player.isPlaying) {
                [button setImage:[UIImage imageNamed:@"iconfont-musicbofang"] forState:UIControlStateNormal];
                //暂停
                //定时器同时暂停
                [_timer setFireDate:[NSDate distantFuture]];
                [_player pause];
            }
            else
            {
                [button setImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
                [_player play];
                //定时器同时暂停
                [_timer setFireDate:[NSDate distantPast]];
                //销毁计时器
                //[_timer invalidate];
            }
            break;
        case 2:
            //下一曲
            [_player stop];
            if (_currentIndex == self.urlArray.count - 1) {
                _currentIndex = 0;
            }
            _currentIndex ++;
            [self createAVAudioPlayer];
            [_player play];
            break;
            
        default:
            break;
    }
}
#pragma mark - 定时器相当于监测slider的Value

-(void)change{
    _slider.value = _player.currentTime / _player.duration;
}

#pragma mark - 滑动条事件
-(void)slider
{
    _player.currentTime = _player.duration * _slider.value;
}


#pragma mark - 返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
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
