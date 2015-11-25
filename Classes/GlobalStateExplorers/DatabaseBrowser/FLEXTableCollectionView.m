//
//  PTTableCollectionView.m
//  PTTableCollectionView
//
//  Created by Peng Tao on 15/11/25.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import "FLEXTableCollectionView.h"
#import "FLEXTableLeftCell.h"
#import "FLEXTableContentCell.h"


typedef NS_ENUM(NSInteger,UIViewSeparatorLocation) {
  UIViewSeparatorLocationTop,
  UIViewSeparatorLocationLeft,
  UIViewSeparatorLocationBottom,
  UIViewSeparatorLocationRight
};


#define kDefaultBackgroundColor [UIColor colorWithWhite:0.850 alpha:1.000]

@interface FLEXTableCollectionView ()
<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView     *contentScrollView;
@property (nonatomic, weak) UIScrollView     *headerScrollView;
@property (nonatomic, weak) UITableView      *leftTableView;
@property (nonatomic, weak) UICollectionView *contentCollectionView;
@property (nonatomic, weak) UIView           *leftHeader;

@property (nonatomic, strong) NSArray *currentSectionData;

@end

@implementation FLEXTableCollectionView

static const CGFloat kColumnMargin = 1;


- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self loadUI];
  }
  return self;
}

- (void)didMoveToSuperview
{
  [super didMoveToSuperview];
  [self reloadData];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  CGFloat width  = self.frame.size.width;
  CGFloat height = self.frame.size.height;
  CGFloat topheaderHeight = [self topHeaderHeight];
  CGFloat leftHeaderWidth = [self leftHeaderWidth];
  
  CGFloat contentWidth = 0.0;
  NSInteger rowsCount = [self.dataSource numberOfColumnsInTableView:self];
  for (int i = 0; i < rowsCount; i++) {
    contentWidth += [self.dataSource multiColumnTableView:self widthForContentCellInColumn:i];
  }
  contentWidth = contentWidth + ([self numberOfColumns] - 1) * [self columnMargin];
  
  self.leftTableView.frame           = CGRectMake(0, topheaderHeight, leftHeaderWidth, height - topheaderHeight);
  self.headerScrollView.frame        = CGRectMake(leftHeaderWidth, 0, width - leftHeaderWidth, topheaderHeight);
  self.headerScrollView.contentSize  = CGSizeMake( self.contentCollectionView.frame.size.width, self.headerScrollView.frame.size.height);
  self.contentCollectionView.frame        = CGRectMake(0, 0, contentWidth , height - topheaderHeight);
  self.contentScrollView.frame       = CGRectMake(leftHeaderWidth, topheaderHeight, width - leftHeaderWidth, height - topheaderHeight);
  self.contentScrollView.contentSize = self.contentCollectionView.frame.size;
  self.leftHeader.frame              = CGRectMake(0, 0, [self leftHeaderWidth], [self topHeaderHeight]);
  
  for (UIView *subView in self.leftHeader.subviews) {
    [subView removeFromSuperview];
  }
  [self addSeparatorLineInView:self.leftHeader andWidth:1 andLocation:UIViewSeparatorLocationRight andColor:[UIColor grayColor]];
  [self addSeparatorLineInView:self.leftHeader andWidth:1 andLocation:UIViewSeparatorLocationBottom andColor:[UIColor grayColor]];
}


- (void)loadUI
{
  [self loadHeaderScrollView];
  [self loadContentScrollView];
  [self loadLeftView];
}

- (void)reloadData
{
  [self loadLeftViewData];
  [self loadContentData];
  [self loadHeaderData];
}
#pragma mark - UI

- (void)loadHeaderScrollView
{
  UIScrollView *headerScrollView = [[UIScrollView alloc] init];
  headerScrollView.delegate      = self;
  self.headerScrollView          = headerScrollView;
  [self addSubview:headerScrollView];
}

- (void)loadContentScrollView
{
  
  UIScrollView *scrollView = [[UIScrollView alloc] init];
  scrollView.bounces       = NO;
  scrollView.delegate      = self;
  
  
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
  
  UICollectionView *collectionView   = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
  collectionView.delegate       = self;
  collectionView.dataSource     = self;
  collectionView.backgroundColor = kDefaultBackgroundColor;
  [collectionView setCollectionViewLayout:layout];
  [collectionView registerClass:[FLEXTableContentCell class] forCellWithReuseIdentifier:@"FLEXTableContentCell"];
  
  [self addSubview:scrollView];
  [scrollView addSubview:collectionView];
  
  self.contentScrollView     = scrollView;
  self.contentCollectionView = collectionView;
  
}

- (void)loadLeftView
{
  UITableView *leftTableView = [[UITableView alloc] init];
  leftTableView.delegate = self;
  leftTableView.dataSource = self;
  leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  leftTableView.backgroundColor = kDefaultBackgroundColor;
  
  self.leftTableView = leftTableView;
  UIView *leftHeader = [[UIView alloc] init];
  leftHeader.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
  self.leftHeader = leftHeader;
  [self addSubview:leftHeader];
  [self addSubview:leftTableView];
  
  
  
  
}


#pragma mark - Data

- (void)loadHeaderData
{
  NSArray *subviews = self.headerScrollView.subviews;
  
  for (UIView *subview in subviews) {
    [subview removeFromSuperview];
  }
  CGFloat x = 0.0;
  CGFloat w = 0.0;
  for (int i = 0; i < [self numberOfColumns] ; i++) {
    w = [self contentWidthForColumn:i] + [self columnMargin];
    UIView *view = [[UIView alloc] initWithFrame:
                    CGRectMake(x, 0, w , [self topHeaderHeight])];
    view.backgroundColor = kDefaultBackgroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:
                      CGRectMake(0, 0, w - [self columnMargin], [self topHeaderHeight] - 1 )];
    label.backgroundColor = [UIColor whiteColor];
    label.text = [self columnTitleForColumn:i];
    label.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:label];
    [self.headerScrollView addSubview:view];
    x = x + w;
  }
}

- (void)loadContentData
{
  [self.contentCollectionView reloadData];
}

- (void)loadLeftViewData
{
  [self.leftTableView reloadData];
}



#pragma mark -
#pragma mark DataSource Accessor

- (NSInteger)numberOfrows
{
  return [self.dataSource numberOfRowsInTableView:self];
}

- (NSInteger)numberOfColumns
{
  return [self.dataSource numberOfColumnsInTableView:self];
}

- (NSString *)columnTitleForColumn:(NSInteger)column
{
  return [self.dataSource columnNameInColumn:column];
}

- (NSString *)rowTitleForRow:(NSInteger)row
{
  return [self.dataSource rowNameInRow:row];
}

- (NSString *)contentAtColumn:(NSInteger)column row:(NSInteger)row;
{
  return [self.dataSource contentAtColumn:column row:row];
}

- (CGFloat)contentWidthForColumn:(NSInteger)column
{
  return [self.dataSource multiColumnTableView:self widthForContentCellInColumn:column];
}

- (CGFloat)contentHeightForRow:(NSInteger)row
{
  return [self.dataSource multiColumnTableView:self heightForContentCellInRow:row];
}

- (CGFloat)topHeaderHeight
{
  return [self.dataSource heightForTopHeaderInTableView:self];
}

- (CGFloat)leftHeaderWidth
{
  return [self.dataSource WidthForLeftHeaderInTableView:self];
}

- (CGFloat)columnMargin
{
  return kColumnMargin;
}


#pragma mark -
#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (scrollView == self.headerScrollView) {
    self.contentScrollView.contentOffset = scrollView.contentOffset;
  }
  else if (scrollView == self.contentScrollView) {
    self.headerScrollView.contentOffset = scrollView.contentOffset;
  }
  else if (scrollView == self.leftTableView) {
    self.contentCollectionView.contentOffset = scrollView.contentOffset;
  }
  else if (scrollView == self.contentCollectionView) {
    self.leftTableView.contentOffset = scrollView.contentOffset;
  }

}


#pragma mark -
#pragma mark - DataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  FLEXTableLeftCell *cell = [FLEXTableLeftCell cellWithTableView:tableView
                                                      height:[self contentHeightForRow:indexPath.row]];
  cell.titlelabel.text = [self.dataSource rowNameInRow:indexPath.row];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self numberOfrows];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) {
    self.currentSectionData = [self.dataSource contentAtRow:indexPath.section];
  }
  
  FLEXTableContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FLEXTableContentCell" forIndexPath:indexPath];  
  cell.textlabel.text =  [NSString stringWithFormat:@"%@",self.currentSectionData[indexPath.row]];
//  cell.layer.shouldRasterize = YES;
//  cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
//  cell.textlabel.text = [self contentAtColumn:indexPath.row row:indexPath.section];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self contentHeightForRow:indexPath.row] + 1;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return [self numberOfrows];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
  return [self numberOfColumns];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return CGSizeMake([self contentWidthForColumn:indexPath.row], [self contentHeightForRow:indexPath.section]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
  return [self columnMargin];
  
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
  return UIEdgeInsetsMake(0, 0, 1, 0);
}

#pragma mark -
#pragma mark - Private



- (void)addSeparatorLineInView:(UIView *)view
                      andWidth:(CGFloat)lineWidth
                   andLocation:(UIViewSeparatorLocation)location
                      andColor:(UIColor *)color
{
  CGFloat width  = view.frame.size.width;
  CGFloat height = view.frame.size.height;
  UIView *line = [[UIView alloc] init];
  line.backgroundColor = color;
  switch (location) {
    case UIViewSeparatorLocationTop:
      line.frame = CGRectMake(0, 0, width, lineWidth);
      [view addSubview:line];
      break;
    case UIViewSeparatorLocationLeft:
      line.frame = CGRectMake(0, 0, lineWidth, height);
      [view addSubview:line];
      break;
    case UIViewSeparatorLocationBottom:
      line.frame = CGRectMake(0, height - lineWidth, width, lineWidth);
      [view addSubview:line];
      break;
    case UIViewSeparatorLocationRight:
      line.frame = CGRectMake(width - lineWidth, 0, lineWidth, height);
      [view addSubview:line];
      break;
  }
}

- (UIColor *)randomColor{
  
  CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
  CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
  CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}
@end
