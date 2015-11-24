//
//  FLEXTableContentCell.m
//  UICatalog
//
//  Created by Peng Tao on 15/11/24.
//  Copyright © 2015年 f. All rights reserved.
//

#import "FLEXTableContentCell.h"
#import "FLEXMultiColumnTableView.h"

@interface FLEXTableContentCell ()

@end

@implementation FLEXTableContentCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
                           height:(CGFloat)height
                   withDataSource:(id<FLEXTableContentCellDatasource>)dataSource
{
  
  static NSString *identifier = @"FLEXTableContentCell";
  FLEXTableContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[FLEXTableContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    CGFloat x = 0.0;
    CGFloat w = 0.0;
    NSMutableArray *labels = [NSMutableArray array];
    for (int i = 0; i < [dataSource numberColumnsForCell] ; i++) {
      w = [dataSource tableContentCell:cell widthForntCellInColumn:i];
      
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, height - 1)];
      [labels addObject:label];
      x = x + w + 1;
      
      if (i == [dataSource numberColumnsForCell] - 1) {
        w += 1;
      }
      [cell.contentView addSubview:label];
      cell.contentView.backgroundColor = [UIColor lightGrayColor];
      label.backgroundColor = [UIColor whiteColor];
    }
    cell.labels = labels;

  }
  return cell;
}


@end
