//
//  KNSearchViewController.m
//  KNMusic
//
//  Created by KN on 15/9/3.
//  Copyright (c) 2015年 KN. All rights reserved.
//

#import "KNSearchViewController.h"
#import "KNSingerSongListViewController.h"
#import "KNSearchTableViewCell.h"
#import "KNMusicViewController.h"

@interface KNSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *array;
}
@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation KNSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    [self initialize];

    
    //添加搜索栏
    [self addSearchBar];

    //添加表
    [self addTable];

    //获取数据
    array = [NSMutableArray array];
    KNSingerModel *model = [KNSingerModel new];
    array = [model itemTop100];
}

- (void)initialize{
    [self.navigationController setNavigationBarHidden:YES animated:NO];//隐藏自带
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    self.navigation.rightImage = [UIImage imageNamed:@"nav_music"];
    self.navigation.title = @"音乐";
    self.navigation.navigationBackColor = [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
}

- (void)addSearchBar{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, self.navigation.size.height+self.navigation.origin.y, self.view.size.width, 44.0f)];
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索:歌手";
    self.searchBar.showsCancelButton = YES;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;//自动修正
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;//自动大小写
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
}

- (void)addTable{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchBar.bounds.size.height+self.searchBar.origin.y, self.view.bounds.size.width, self.view.size.height - self.navigation.size.height)];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.searchBar];
}
//
//#pragma mark - navigationDelegate
//- (void)rightButtonClickEvent{
//    if(globle.isPlaying){
//        KNMusicViewController *musicVc = [KNMusicViewController shareMusicViewController];
//        [self.navigationController pushViewController:musicVc animated:YES];
//    }
//}


#pragma mark - searchDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    if(array.count != 0){
        [array removeAllObjects];
    }
    
    [ProgressHUD show:@"正在加载"];
    [self getSingerData];
}

- (void)getSingerData{
    KNSingerModel *model = [[KNSingerModel alloc]init];
    array = [model itemWith:_searchBar.text];
    if(array.count){
        [_tableView reloadData];
        [ProgressHUD dismiss];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        
        //将表格滚动到第一行
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
}
#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *dentifier = @"cell";
    KNSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dentifier];
    if(cell == nil){
        cell = [[KNSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:dentifier];
    }
    KNSingerModel *model = [array objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KNSingerSongListViewController *pushController = [[KNSingerSongListViewController alloc]init];
    KNSingerModel *model = [array objectAtIndex:indexPath.row];
    pushController.singerModel = model;
    [self.navigationController pushViewController:pushController animated:YES];
}



@end
