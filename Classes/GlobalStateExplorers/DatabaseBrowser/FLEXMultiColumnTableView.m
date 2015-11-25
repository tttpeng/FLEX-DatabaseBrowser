//
//  PTMultiColumnTableView.m
//  PTMultiColumnTableViewDemo
//
//  Created by Peng Tao on 15/11/16.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import "FLEXMultiColumnTableView.h"
#import "FLEXTableContentCell.h"
#import "FLEXTableLeftCell.h"


typedef NS_ENUM(NSInteger,UIViewSeparatorLocation) {
  UIViewSeparatorLocationTop,
  UIViewSeparatorLocationLeft,
  UIViewSeparatorLocationBottom,
  UIViewSeparatorLocationRight
};

@interface FLEXMultiColumnTableView ()
<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) UIScrollView *headerScrollView;
@property (nonatomic, weak) UITableView  *leftTableView;
@property (nonatomic, weak) UITableView  *contentTableView;
@property (nonatomic, weak) UIView       *leftHeader;

@property (nonatomic, strong) NSArray *rowData;
@end

static const CGFloat kColumnMargin = 1;

@implementation FLEXMultiColumnTableView


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
  
  self.leftTableView.frame           = CGRectMake(0, topheaderHeight, leftHeaderWidth, height - topheaderHeight);
  self.headerScrollView.frame        = CGRectMake(leftHeaderWidth, 0, width - leftHeaderWidth, topheaderHeight);
  self.headerScrollView.contentSize  = CGSizeMake( self.contentTableView.frame.size.width, self.headerScrollView.frame.size.height);
  self.contentTableView.frame        = CGRectMake(0, 0, contentWidth + [self numberOfColumns] * [self columnMargin] , height - topheaderHeight);
  self.contentScrollView.frame       = CGRectMake(leftHeaderWidth, topheaderHeight, width - leftHeaderWidth, height - topheaderHeight);
  self.contentScrollView.contentSize = self.contentTableView.frame.size;
  self.leftHeader.frame              = CGRectMake(0, 0, [self leftHeaderWidth], [self topHeaderHeight]);
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
  
  UITableView *tableView   = [[UITableView alloc] init];
  tableView.delegate       = self;
  tableView.dataSource     = self;
  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  [self addSubview:scrollView];
  [scrollView addSubview:tableView];
  
  self.contentScrollView = scrollView;
  self.contentTableView    = tableView;
  
}

- (void)loadLeftView
{
  UITableView *leftTableView = [[UITableView alloc] init];
  leftTableView.delegate       = self;
  leftTableView.dataSource     = self;
  leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.leftTableView           = leftTableView;
  [self addSubview:leftTableView];
  
  UIView *leftHeader = [[UIView alloc] init];
  leftHeader.backgroundColor = [UIColor colorWithWhite:0.950 alpha:0.668];
  self.leftHeader            = leftHeader;
  [self addSubview:leftHeader];
  
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
    view.backgroundColor = [UIColor colorWithWhite:0.850 alpha:0.650];
    
    UILabel *label = [[UILabel alloc] initWithFrame:
                      CGRectMake(0, 0, w - [self columnMargin], [self topHeaderHeight] - 1 )];
    label.backgroundColor = [UIColor whiteColor];
    label.text            = [self columnTitleForColumn:i];
    label.textAlignment   = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.font            = [UIFont systemFontOfSize:13.0];
    [view addSubview:label];
    [self.headerScrollView addSubview:view];
    x = x + w;
  }
}

- (void)loadContentData
{
  [self.contentTableView reloadData];
}

- (void)loadLeftViewData
{
  [self.leftTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIColor *backgroundColor = [UIColor whiteColor];
  if (indexPath.row % 2 != 0) {
    backgroundColor = [UIColor colorWithWhite:0.950 alpha:0.750];
  }

  if (tableView != self.leftTableView) {
    self.rowData = [self.dataSource contentAtRow:indexPath.row];
    FLEXTableContentCell *cell = [FLEXTableContentCell cellWithTableView:tableView
                                                            columnNumber:[self numberOfColumns]];
    cell.contentView.backgroundColor = backgroundColor;


    for (int i = 0 ; i < cell.labels.count; i++) {
      
      UILabel *label  = cell.labels[i];
      label.textColor = [UIColor blackColor];
      
      NSString *content = [NSString stringWithFormat:@"%@",self.rowData[i]];
      if ([content isEqualToString:@"<null>"]) {
        label.textColor = [UIColor lightGrayColor];
        content = @"NULL";
      }
      
      label.text            = content;
      label.backgroundColor = backgroundColor;
      
      UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(labelDidTap:)];
      [label addGestureRecognizer:gesture];
      label.userInteractionEnabled = YES;
      
    }
    
    return cell;
  }
  else {
    FLEXTableLeftCell *cell          = [FLEXTableLeftCell cellWithTableView:tableView];
    cell.contentView.backgroundColor = backgroundColor;
    cell.titlelabel.text             = [self.dataSource rowNameInRow:indexPath.row];
    return cell;
    
  }
}


- (void)labelDidTap:(UIGestureRecognizer *)gesture
{
  UILabel *label = (UILabel *)gesture.view;
  [self.delegate multiColumnTableView:self labelDidTapWithText:label.text];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.dataSource numberOfRowsInTableView:self];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.dataSource multiColumnTableView:self heightForContentCellInRow:indexPath.row];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (scrollView == self.contentScrollView) {
    self.headerScrollView.contentOffset = scrollView.contentOffset;
  }
  else if (scrollView == self.headerScrollView) {
    self.contentScrollView.contentOffset = scrollView.contentOffset;
  }
  else if (scrollView == self.leftTableView) {
    self.contentTableView.contentOffset = scrollView.contentOffset;
  }
  else if (scrollView == self.contentTableView) {
    self.leftTableView.contentOffset = scrollView.contentOffset;
  }
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tableView == self.leftTableView) {
    [self.contentTableView selectRowAtIndexPath:indexPath
                                       animated:NO
                                 scrollPosition:UITableViewScrollPositionNone];
  }
  else if (tableView == self.contentTableView) {
    [self.leftTableView selectRowAtIndexPath:indexPath
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
  }
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
