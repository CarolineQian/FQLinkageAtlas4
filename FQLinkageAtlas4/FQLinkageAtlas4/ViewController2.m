//
//  ViewController2.m
//  imageThree
//
//  Created by 冯倩 on 2016/11/21.
//  Copyright © 2016年 冯倩. All rights reserved.
//

#import "ViewController2.h"
#import "photoCell.h"

@interface ViewController2 ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIScrollView        *_mainScrollView;     //中间主scrollView
    UIPageControl       *_wheelPageControl;
    UICollectionView    *_bottomCollectionView;
    UIView              *_underLineView;      //底部线条
    
    UIScrollView         *_scrollView1;
    UIScrollView         *_scrollView2;
    UIScrollView         *_scrollView3;
    
    UIImageView         *_image1;
    UIImageView         *_image2;
    UIImageView         *_image3;
    
    NSArray             *_imageArray;         //图片数组
    NSInteger           _currentImageIndex;   //滑动时记录当前数组下标
}


@end

@implementation ViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"图片";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self layoutUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - InitData
- (void)initData
{
    _imageArray = @[@"http://image.photophoto.cn/m-15/Identifiers/Number/0370060487.jpg",
                    @"http://d.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=bbde1034d62a283443f33e0d6b85e5d2/4bed2e738bd4b31c5c86949285d6277f9e2ff865.jpg",
                    @"http://img.sootuu.com/vector/200801/097/479.jpg",
                    @"http://hiphotos.baidu.com/yirenqixi/pic/item/11cedd8fed1fb2fc503d92ac.jpg",
                    @"http://img.incake.net/UpImages/xin/172-1.png",
                    @"http://pic17.nipic.com/20111122/8372622_104529289168_2.jpg",
                    @"http://image.photophoto.cn/nm-15/037/006/0370060386.jpg",
                    @"http://imgm.photophoto.cn/015/037/006/0370060145.jpg",
                    @"http://img.taopic.com/uploads/allimg/140306/235030-140306150U849.jpg",
                    @"http://img.incake.net/UpImages/xin/177-1.png",
                    @"http://img2.ooopic.com/14/64/33/47bOOOPIC7c_202.jpg",
                    @"http://pic.wenwen.soso.com/p/20091001/20091001052655-375871054.jpg",
                    @"http://y1.ifengimg.com/cmpp/2014/06/13/09/f66972b9-a8a7-4670-9fa9-e5fe32cdbe56.jpg",
                    @"http://e.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=5bbb462fd000baa1ba794fbd7720952a/55e736d12f2eb9385fd6f131d4628535e4dd6fbe.jpg"
                    ];
    _currentImageIndex = 0;
}

#pragma mark - LayoutUI
- (void)layoutUI
{
    //_mainScrollView
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.width, self.view.height - 300)];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    _mainScrollView.backgroundColor = [UIColor grayColor];
    _mainScrollView.showsHorizontalScrollIndicator=YES;
    _mainScrollView.showsVerticalScrollIndicator=YES;
    _mainScrollView.contentSize = CGSizeMake(self.view.width * 3, 0);
    _mainScrollView.pagingEnabled = YES;
    [_mainScrollView setContentOffset:CGPointMake(self.view.width, 0) animated:NO];
    [self.view addSubview:_mainScrollView];
    
    //三个ScrollView
    _scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _mainScrollView.width, _mainScrollView.height)];
    _scrollView1.delegate = self;
    _scrollView1.backgroundColor = [UIColor redColor];
    
    _scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.width, 0, _mainScrollView.width, _mainScrollView.height)];
    _scrollView2.delegate = self;
    _scrollView2.minimumZoomScale = 1.0;
    _scrollView2.maximumZoomScale = 2.0;
    _scrollView2.zoomScale = 1.0;
    _scrollView2.backgroundColor = [UIColor greenColor];
    
    _scrollView3 = [[UIScrollView alloc] initWithFrame:CGRectMake(2*self.view.width, 0, _mainScrollView.width, _mainScrollView.height)];
    _scrollView3.delegate = self;
    _scrollView3.backgroundColor = [UIColor blueColor];
    
    //三个UIImageView
    _image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView1.width, _scrollView1.height)];
    _image1.backgroundColor = [UIColor blackColor];
    [_scrollView1 addSubview:_image1];
    _image2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView2.width, _scrollView2.height)];
    _image2.backgroundColor = [UIColor whiteColor];
    [_scrollView2 addSubview:_image2];
    _image3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,_scrollView3.width, _scrollView3.height)];
    _image3.backgroundColor = [UIColor grayColor];
    [_scrollView3 addSubview:_image3];
    
    for (UIScrollView * sclView in @[_scrollView1,_scrollView2,_scrollView3])
    {
        [_mainScrollView addSubview:sclView];
    }
    
    //UIPageControl
    _wheelPageControl = [[UIPageControl alloc] init];
    _wheelPageControl.numberOfPages = _imageArray.count;
    _wheelPageControl.currentPage = 0;
    CGPoint p = CGPointMake(self.view.width * 0.5, 0.8 * self.view.height);
    _wheelPageControl.center = p;
    _wheelPageControl.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_wheelPageControl];
    //上面数据初始化
    [self updateScrollImage];
    
    //底部collectionView
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.height - 70, self.view.width, 70) collectionViewLayout:flowLayout];
    _bottomCollectionView.showsHorizontalScrollIndicator=NO;
    _bottomCollectionView.showsVerticalScrollIndicator=NO;
    _bottomCollectionView.bounces = NO;    //关闭回弹
    _bottomCollectionView.backgroundColor = [UIColor grayColor];
    _bottomCollectionView.delegate = self;
    _bottomCollectionView.dataSource = self;
    [_bottomCollectionView registerClass:[photoCell class] forCellWithReuseIdentifier:@"cellId1"];
    [self.view addSubview:_bottomCollectionView];
    
    //默认第一个为选中状态
    [_bottomCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

    
    //条件判断
    if (_imageArray.count == 1)
    {
        _mainScrollView.scrollEnabled = NO;
    }
    
}

#pragma mark - Methods
//拖动scrollView时响应
-(void) updateScrollImage
{
    _scrollView2.zoomScale = 1;
    
    NSInteger left;
    NSInteger right;
    
    left = (int)(_currentImageIndex + _imageArray.count -1) % _imageArray.count;
    right = (int)(_currentImageIndex + 1) % _imageArray.count;
    
    [_image1 sd_setImageWithURL:[NSURL URLWithString:_imageArray[left]]];
    [_image2 sd_setImageWithURL:[NSURL URLWithString:_imageArray[_currentImageIndex]]];
    [_image3 sd_setImageWithURL:[NSURL URLWithString:_imageArray[right]]];
    
    //偏移回来
    [_mainScrollView setContentOffset:CGPointMake(_mainScrollView.width, 0) animated:NO];
    _wheelPageControl.currentPage = _currentImageIndex;
    
    NSLog(@"数组下标为%ld",_currentImageIndex);
    
}


#pragma mark - UIScrollView

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _mainScrollView)
    {
        int page = scrollView.contentOffset.x / scrollView.width;  //偏移了几张图
        //左滑
        if (page == 0)
        {
            _currentImageIndex = (_currentImageIndex + _imageArray.count - 1) % _imageArray.count;
        }
        //右滑
        else if(page == 2)
        {
            _currentImageIndex = (_currentImageIndex + 1) % _imageArray.count;
        }
        
        [self updateScrollImage];
        
        //动画
        [_bottomCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_currentImageIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
        
    }
    else
        return;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    for (UIView *v in scrollView.subviews)
    {
        return v;
    }
    return nil;
}


#pragma mark - UICollectionViewDataSource
/*
 ***cell个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _imageArray.count;
    
}
//section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
/*
 ***cell内容
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        // 获取单元格
        photoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId1" forIndexPath:indexPath];
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[indexPath.row]]];
        return cell;
}

//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //
    NSLog(@"%ld====%ld",(long)indexPath.section,(long)indexPath.item);
    [_image2 sd_setImageWithURL:[NSURL URLWithString:_imageArray[indexPath.item]]];
    _currentImageIndex = indexPath.item;
    _scrollView2.zoomScale = 1;

}

//设置标题头的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //水平滑动时：第一个参数有效
    //竖直滑动时：第二个参数有效
    return CGSizeMake(0, 0);
}
//设置标题尾的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    //水平滑动时：第一个参数有效
    //竖直滑动时：第二个参数有效
    return CGSizeMake(0, 0);
}

//设置item的大小
//item的默认大小：50*50
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //第一个参数：设置item的宽
    //第二个参数：设置item的高
    return CGSizeMake(70, 70);
}

//设置水平间隙  ： 默认10
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//设置竖直间隙  ： 默认10
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//设置边距(整体)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上左下右
    return UIEdgeInsetsMake(-10 ,0, -10, 0);
}

@end
