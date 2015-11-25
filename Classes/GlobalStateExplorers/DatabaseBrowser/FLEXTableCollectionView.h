//
//  PTTableCollectionView.h
//  PTTableCollectionView
//
//  Created by Peng Tao on 15/11/25.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLEXTableCollectionView;
@protocol FLEXTableCollectionViewDelegate <NSObject>

@required


- (NSInteger)numberOfColumnsInTableView:(FLEXTableCollectionView *)tableView;
- (NSInteger)numberOfRowsInTableView:(FLEXTableCollectionView *)tableView;
- (NSString *)columnNameInColumn:(NSInteger)column;
- (NSString *)rowNameInRow:(NSInteger)row;
- (NSString *)contentAtColumn:(NSInteger)column row:(NSInteger)row;
- (NSArray *)contentAtRow:(NSInteger)row;

- (CGFloat)multiColumnTableView:(FLEXTableCollectionView *)tableView widthForContentCellInColumn:(NSInteger)column;
- (CGFloat)multiColumnTableView:(FLEXTableCollectionView *)tableView heightForContentCellInRow:(NSInteger)row;
- (CGFloat)heightForTopHeaderInTableView:(FLEXTableCollectionView *)tableView;
- (CGFloat)WidthForLeftHeaderInTableView:(FLEXTableCollectionView *)tableView;

@end

@interface FLEXTableCollectionView : UIView

@property (nonatomic, weak) id<FLEXTableCollectionViewDelegate>dataSource;
- (void)reloadData;


@end
