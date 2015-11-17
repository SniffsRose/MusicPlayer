//
//  KNMusicViewController.m
//  KNMusic
//
//  Created by KN on 15/9/7.
//  Copyright © 2015年 KN. All rights reserved.
//

#import "KNMusicViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "KNDataEngine.h"
#import "KNRadioView.h"
#import "KNDataEngine.h"
#import "KNSongListModel.h"
#import "KNSongModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FSPlaylistItem.h"
#import "KNLrcView.h"
#import "UIImageView+WebCache.h"
#import "KNTabBarController.h"

#define KNLrcIsMyLike   @"KNLrcIsMyLike"
#define KNLrcImageHead  @"KNLrcImageHead"

@interface KNMusicViewController ()<KNRadioViewDelegate,KNLrcViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    KNRadioView *_radioView;
    BOOL lrcIsMyLike;
}
@end

@implementation KNMusicViewController

+ (KNMusicViewController *)shareMusicViewController{
    static KNMusicViewController *musicVc;
    if(musicVc == nil){
        musicVc = [[KNMusicViewController alloc]init];
    }
    return musicVc;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.knTabBarController hidesTabBar:YES animated:NO];
//    [[NSNotificationCenter defaultCenter]postNotificationName:KNTabBarHiddenOrShow object:self userInfo:@{KNTabBarInfoKey:@YES}];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.knTabBarController hidesTabBar:NO animated:NO];
//    [[NSNotificationCenter defaultCenter]postNotificationName:KNTabBarHiddenOrShow object:self userInfo:@{KNTabBarInfoKey:@NO}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigation.leftImage = [UIImage imageNamed:@"nav_backbtn"];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigation.navigationBackColor = [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
    
    _songModel = [KNSongModel new];
    
    _radioView = [[KNRadioView alloc] initWithFrame:CGRectMake(0,self.navigation.size.height+self.navigation.origin.y, 320,self.view.size.height-self.navigation.size.height-self.navigation.origin.y)];
    _radioView.delegate = self;
    [self.view addSubview:_radioView];
    
    //监听进入后台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundSetSongInformation:) name:KNRadioViewSetSongInformationNotification object:nil];
    

    NSString *lrcImage = [[NSUserDefaults standardUserDefaults] objectForKey:KNLrcIsMyLike];
    lrcIsMyLike = [lrcImage boolValue];

    if(lrcIsMyLike){
        [self setLrcBackgroundImageIsMyLike];
    }else{
        [self setLrcBackgroundImageIsStar];
    }
    
}

//播放一首歌曲
-(void)playMusicWithSongLink:(KNSongListModel*)model{
    KNDataEngine *network = [KNDataEngine new];
    //
    NSString *where = [NSString stringWithFormat:@"songId = %lld",model.song_id];
    NSArray *array = [KNSongModel searchWithWhere:where orderBy:@"songId" offset:0 count:9999];
    if(array.count){
        [self playSongWithSongModel:array[0] andSonglistModel:model];
    }else{
        [network getSongInformationWith:model.song_id WithCompletionHandler:^(KNSongModel *songModel) {
            
            [self playSongWithSongModel:songModel andSonglistModel:model];
        } errorHandler:^(NSError *error) {
            if ([self isLocalMP3]) {
                //单曲循环
                [self playModleIsLock];
                [ProgressHUD showError:@"网络错误"];
            }
        }];
    }
    
}
- (void)playSongWithSongModel:(KNSongModel*)songModel andSonglistModel:(KNSongListModel*)model{
    FSPlaylistItem * item = [[FSPlaylistItem alloc] init];
    item.title = songModel.songName;
    item.url = songModel.songLink;
    
    _radioView.songlistModel = model;
    _radioView.songModel = songModel;
    //设置歌词，旋转图片
    [_radioView setRadioViewLrc];
    
    globle.isPlaying = YES;
    _songModel = songModel;
    _songListModel =model;
    self.navigation.title =songModel.songName;
    _radioView.selectedPlaylistItem = item;
    if (globle.isApplicationEnterBackground) {
        [self applicationDidEnterBackgroundSetSongInformation:nil];
    }
    [self loadLrcBackgroundImage];
}
//进入后台
- (void)applicationDidEnterBackgroundSetSongInformation:(NSNotification*)noti{
    //判断时候正在播放歌曲
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        
        //设置后台播放控制的标题和副标题
        [dict setObject:_songModel.songName forKey:MPMediaItemPropertyTitle];
        [dict setObject:_songListModel.author  forKey:MPMediaItemPropertyArtist];
//        [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"headerImage.png"]] forKey:MPMediaItemPropertyArtwork];
//        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}
-(BOOL)isLocalMP3
{
    NSFileManager * manager = [[NSFileManager alloc] init];
    NSString *filePath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld/%lld/%lld.mp3",_songListModel.ting_uid,_songListModel.song_id,_songListModel.song_id]];
    if ([manager fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
}

-(NSString *)localMP3path
{
    NSString *filePath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld/%lld/%lld.mp3",_songListModel.ting_uid,_songListModel.song_id,_songListModel.song_id]];
    return filePath;
}
//单曲循环
-(void)playModleIsLock
{
    FSPlaylistItem * item = [[FSPlaylistItem alloc] init];
    item.title = _songModel.songName;
    item.url = _songModel.songLink;
    _radioView.selectedPlaylistItem = item;
    _radioView.songlistModel = _songListModel;
    _radioView.songModel = _songModel;
    globle.isPlaying = YES;
    self.navigation.title =_songModel.songName;
}
#pragma mark - KNRadioViewDelegate

-(void)radioView:(KNRadioView *)view musicStop:(NSInteger)playModel
{
    KNSongListModel * model = nil;
    switch (playModel) {
        case 0:
        {
            self.index+=1;
            if (self.index>=[self.array count]) {
                self.index = 0;
            }
            model = [self.array objectAtIndex:self.index];
            [self playMusicWithSongLink:model];
            
        }
            break;
        case 1:
        {
            NSInteger  number = [self.array count];
            model = [self.array objectAtIndex:arc4random()%number];
            [self playMusicWithSongLink:model];
        }
            break;
        case -1:
        {
            model = self.songListModel;
            [self playModleIsLock];
        }
            break;
        default:
            break;
    }

}
-(void)radioView:(KNRadioView *)view preSwitchMusic:(UIButton *)pre
{
    if ([self.array count]!=0) {
        self.index-=1;
        if (self.index<0) {
            self.index = 0;
        }
        KNSongListModel * model = [self.array objectAtIndex:self.index];
        [self playMusicWithSongLink:model];

    }
}
-(void)radioView:(KNRadioView *)view nextSwitchMusic:(UIButton *)next
{
    if ([self.array count]!=0) {
        self.index+=1;
        if (self.index==[self.array count]) {
            self.index = self.index-1;
        }
        KNSongListModel * model = [self.array objectAtIndex:self.index];
        [self playMusicWithSongLink:model];

    }
}
-(void)radioView:(KNRadioView *)view playListButton:(UIButton *)btn
{
    [super previousToViewController];
    if(self.isTabBar){
        self.knTabBarController.selectedIndex = self.isTabBar - 10;
    }
}
-(void)radioView:(KNRadioView *)view downLoadButton:(UIButton *)btn
{
    KNDataEngine * network = [KNDataEngine new];
    [network downLoadSongWith:_songListModel.ting_uid :_songListModel.song_id :view.selectedPlaylistItem.url WithCompletionHandler:^(BOOL sucess, NSString *path) {
        _radioView.downLoadButton.enabled = NO;
        
        //保存数据到表中
        [_songListModel insetData];
        [_songModel insetData];
        
        //保存图片到沙盒路径
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *UIDPath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",_songListModel.ting_uid]];
        NSString * SIDPath = [UIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",_songListModel.song_id]];
        
        NSString * filePath  = [SIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.png",_songListModel.song_id]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_songListModel.pic_big]];
        
        if (![fileMgr fileExistsAtPath:filePath]) {
            BOOL creat =  [fileMgr createFileAtPath:filePath contents:data attributes:nil];
            if (creat) {
                NSLog(@"png文件保存成功");
                sucess = YES;
            }
        }
        
        
    } errorHandler:^(NSError *error) {
        _radioView.downLoadButton.enabled = YES;
    }];
}
- (void)radioView:(KNRadioView *)view collectButton:(UIButton *)btn{
    
    lrcIsMyLike = !lrcIsMyLike;
    
    if(lrcIsMyLike){
        [self setLrcBackgroundImageIsMyLike];
        
    }else{
        
        [self setLrcBackgroundImageIsStar];
        
    }
    
}


#pragma mark - LrcDelegate
- (void)lrcViewLongPress{
    //弹出系统的相册
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    //设置相册类型，相册集
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //获取选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //获取点选图片时，获取图片名称
    NSURL *imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    //保存获取来的图片
    __block NSString *HaedImageName = nil;
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        HaedImageName = [representation filename];
        NSLog(@"fileName : %@",HaedImageName);
        //将图片的后缀名切除
        NSArray *arr = [HaedImageName componentsSeparatedByString:@"."];
        HaedImageName = arr[0];
        //将选择的图片放到沙盒中
        NSString *HeadPath = [DocumentsPath stringByAppendingString:HaedImageName];
        //将图片输出为png,并写入沙盒指定路径
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:HeadPath atomically:YES];
        
        //保存喜好
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:KNLrcIsMyLike];
        [[NSUserDefaults standardUserDefaults] setObject:HaedImageName forKey:KNLrcImageHead];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
    [_radioView setBackgroundImage:image];
    
    
    
    
}

- (void)setLrcBackgroundImageIsMyLike{
    NSString *lrcImageHead = [[NSUserDefaults standardUserDefaults] objectForKey:KNLrcImageHead];
    if(lrcImageHead.length>0){
    NSString *imagePath = [DocumentsPath stringByAppendingString:lrcImageHead];
        if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            UIImage *image = [UIImage imageWithData:data];
            [_radioView setBackgroundImage:image];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:KNLrcIsMyLike];
        }
        return;
    }
    
    [self setLrcBackgroundImageIsStar];

}
- (void)setLrcBackgroundImageIsStar{
    [_radioView.radiolrcView.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:_songModel.songPicBig]];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:KNLrcIsMyLike];
}

- (void)loadLrcBackgroundImage{
    
    NSString *lrcImage = [[NSUserDefaults standardUserDefaults] objectForKey:KNLrcIsMyLike];
    lrcIsMyLike = [lrcImage boolValue];
    if(!lrcIsMyLike){
        [self setLrcBackgroundImageIsStar];
    }
}



- (void)previousToViewController{
    [super previousToViewController];
    if(self.isTabBar){
        self.knTabBarController.selectedIndex = self.isTabBar - 10;
    }
}
@end
