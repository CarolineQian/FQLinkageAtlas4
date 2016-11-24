//
//  photoCell.m
//  FQPhotoAlbum
//
//  Created by 冯倩 on 2016/11/22.
//  Copyright © 2016年 冯倩. All rights reserved.
//

#import "photoCell.h"

@implementation photoCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 70 - 4, 70 - 4)];
        [self addSubview:_photoImageView];
        
        self.backgroundView = [[UIView alloc]init];
        self.backgroundView.backgroundColor = [UIColor lightGrayColor];
        self.selectedBackgroundView = [[UIView alloc]init];
        self.selectedBackgroundView.backgroundColor = [UIColor redColor];
    }
    return self;
}


@end
