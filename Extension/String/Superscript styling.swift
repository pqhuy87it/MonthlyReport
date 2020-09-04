https://stackoverflow.com/questions/21415963/nsattributedstring-superscript-styling/21603232

UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:20.0];

NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"GGG®GGG"
                                                                                     attributes:@{NSFontAttributeName: [fnt fontWithSize:20]}];
[attributedString setAttributes:@{NSFontAttributeName : [fnt fontWithSize:10]
                                  , NSBaselineOffsetAttributeName : @10} range:NSMakeRange(3, 1)];
                                  
![](https://i.stack.imgur.com/XBtK7.png)
