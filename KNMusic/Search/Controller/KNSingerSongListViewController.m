//
//  KNSingerSongListViewController.m
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNSingerSongListViewController.h"
#import "UIScrollView+BottomRefreshControl.h"
#import "KNMusicViewController.h"
#import "KNDataEngine.h"
#import "KNSongListTableViewCell.h"

@interface KNSingerSongListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTableView;
    NSMutableArray *array;
    BOOL isLoadingMore;
    BOOL isCanLoadMore;
    int song_total;
    
    
}
@end

@implementation KNSingerSongListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigation.rightImage = [UIImage imageNamed:@"nav_music"];
    self.navigation.leftImage = [UIImage imageNamed:@"nav_backbtn"];
    
    self.navigation.title = [NSString stringWithFormat:@"%@(歌曲%d",self.singerModel.name,self.singerModel.songs_total];
    self.navigation.navigationBackColor = [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigation.size.height + self.navigation.origin.y, self.view.size.width, self.view.size.height - self.navigation.size.height - 48.5f)];
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:myTableView];
    
    isCanLoadMore = YES;
    
    //上啦加载
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    
    //设置上啦属性
    refreshControl.triggerVerticalOffset = 70;
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在为乃加载更多捏,喵~"];
    [refreshControl addTarget:self action:@selector(loadMoreSinger) forControlEvents:UIControlEventValueChanged];
    myTableView.bottomRefreshControl = refreshControl;
    [self loadMoreSinger];
}

- (void)loadMoreSinger{
    
    if(isCanLoadMore){
        //获取更多数据，获取后停止加载动画
        KNDataEngine *network = [[KNDataEngine alloc]init];
        [network getSingerSongListWith:self.singerModel.ting_uid :song_total WithCompletionHandler:^(KNSongList *songList) {
            song_total += 20;
            array = songList.songLists;
            [myTableView reloadData];
            if(song_total < self.singerModel.songs_total){
                isCanLoadMore = YES;
            }else{
                isCanLoadMore = NO;
            }
            //停止“加载"动画
            [myTableView.bottomRefreshControl endRefreshing];
        } errorHandler:^(NSError *error) {
            
            [myTableView.bottomRefreshControl endRefreshing];
        }];
        
        
    }else{
        [myTableView.bottomRefreshControl endRefreshing];
    }
    
}

//#pragma mark - navigationDelegate
//- (void)rightButtonClickEvent{
//    if(globle.isPlaying){
//        KNMusicViewController *musicVc = [KNMusicViewController shareMusicViewController];
//        [self.navigationController pushViewController:musicVc animated:YES];
//    }
//}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"celll";
    KNSongListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[KNSongListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.model = array[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KNMusicViewController *musicVc = [KNMusicViewController shareMusicViewController];
    musicVc.songListModel = [array objectAtIndex:indexPath.row];
    musicVc.array = array;
    musicVc.index = indexPath.row;
    
    [musicVc playMusicWithSongLink:[array objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:musicVc animated:YES];
}

@end
