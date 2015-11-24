//
//  FLEXTableLeftCell.m
//  UICatalog
//
//  Created by Peng Tao on 15/11/24.
//  Copyright © 2015年 f. All rights reserved.
//

#import "FLEXTableLeftCell.h"

@implementation FLEXTableLeftCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                           height:(CGFloat)height
{
  static NSString *identifier = @"FLEXTableLeftCell";
  FLEXTableLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[FLEXTableLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    CGFloat width  = tableView.frame.size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    view.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
    [cell.contentView addSubview:view];
    
   UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width - 1, height - 1)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:textLabel];
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    textLabel.backgroundColor = [UIColor whiteColor];
    cell.titlelabel = textLabel;
    
  }
  return cell;

}

@end
