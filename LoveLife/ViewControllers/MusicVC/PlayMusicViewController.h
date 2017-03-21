//
//  PlayMusicViewController.h
//  LoveLife
//
//  Created by 王一成 on 16/1/5.
//  Copyright © 2016年 yangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
@interface PlayMusicViewController : UIViewController

//传值
@property (nonatomic , retain) MusicModel * model;
//MP3文件
@property (nonatomic , retain) NSArray * urlArray;
//当前的播放值
@property (nonatomic , assign) int currentIndex;
@end
