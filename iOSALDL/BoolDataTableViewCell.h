//
//  BoolDataTableViewCell.h
//  iOSALDL
//
//  Created by rpasek on 10/15/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoolDataTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgState;

@end

NS_ASSUME_NONNULL_END
