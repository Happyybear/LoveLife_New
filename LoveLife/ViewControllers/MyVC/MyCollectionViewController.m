//
//  MyCollectionViewController.m
//  LoveLife
//
//  Created by 王一成 on 16/1/6.
//  Copyright © 2016年 yangyang. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "DBManager.h"
#import "ReadModel.h"
#import "ArticalCell.h"
#import "ArticalDetailViewController.h"
#import "AppDelegate.h"
@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
}
@property (nonatomic,retain) NSMutableArray * dataArrary;
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setNav];
    [self crateUI];
    [self loadData];
}



- (void)viewWillDisappear:(BOOL)animated

{
    
    [super viewWillDisappear:animated];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.drawerVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    [delegate.drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    
    
    
    
    
}

#pragma mark -删除cell
//设置编辑类型
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//设置cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除的思路：1先删除数据库中的数据，2然后删除界面的cell 3。刷新数据
    DBManager * manager = [DBManager defaultManager];
    ReadModel * model = [[ReadModel alloc] init];
    model = self.dataArrary[indexPath.row];
    [manager deleteNameFromTable:model.dataID];
    
    //删除cell
    [self.dataArrary removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    //刷新
    [_tableView reloadData];
//    [self loadData];
}
#pragma mark －取出数据
-(void)loadData
{
    DBManager * manager = [DBManager defaultManager];
    self.dataArrary = [[NSMutableArray alloc] init];
//    self.dataArrary = [NSMutableArray arrayWithObjects:[manager getData], nil];
    NSArray  *arr= [manager getData];
    self.dataArrary = [NSMutableArray arrayWithArray:arr];
    [_tableView reloadData];
}
-(void)setNav{
    self.titleLabel.text = @"我的收藏";
    [self.leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self setLeftButtonClick:@selector(leftButtonClick)];
}


-(void)crateUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArrary.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ArticalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (self.dataArrary) {
        ReadModel * model = self.dataArrary[indexPath.row];
        [cell refreshUI:model];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticalDetailViewController * vc = [[ArticalDetailViewController alloc] init];
    ReadModel * model = self.dataArrary[indexPath.row];
    vc.readModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(void)leftButtonClick
{
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
