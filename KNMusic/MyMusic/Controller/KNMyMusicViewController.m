//
//  KNMyMusicViewController.m
//  KNMusic
//
//  Created by KN on 15/9/9.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNMyMusicViewController.h"
#import "KNSongListModel.h"
#import "KNMusicViewController.h"
#import "KNSongListTableViewCell.h"

@interface KNMyMusicViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,strong) NSArray *songlists;
@end

@implementation KNMyMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    [self initialize];
    
    
    //获取数据
    self.songlists = [KNSongListModel searchWithWhere:nil orderBy:@"song_id" offset:0 count:9999];
}
- (void)initialize{
    
    self.navigation.title = @"我的音乐";
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigation.navigationBackColor = [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navigation.size.height + self.navigation.origin.y, self.view.size.width, self.view.size.height - self.navigation.size.height - 48.5f) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //获取更新的数据
    self.songlists = [KNSongListModel searchWithWhere:nil orderBy:@"song_id" offset:0 count:9999];
    [self.tableView reloadData];
    
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songlists.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"celll";
    KNSongListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[KNSongListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.model = self.songlists[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //播放选中的歌曲
    KNMusicViewController *musicVc = [KNMusicViewController shareMusicViewController];
    musicVc.songListModel = [self.songlists objectAtIndex:indexPath.row];
    musicVc.array = [self.songlists mutableCopy];
    musicVc.index = indexPath.row;
    
    [musicVc playMusicWithSongLink:[self.songlists objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:musicVc animated:YES];
}
@end
