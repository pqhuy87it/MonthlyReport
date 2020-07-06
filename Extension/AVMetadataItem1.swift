MPMediaItem *item;
AVURLAsset *itemAsset = [item valueForProperty:MPMediaItemPropertyAssetURL];
NSArray *mDatsForFormats = [itemAsset metadataForFormat:@"org.id3"];

for (AVMetadataItem *mDatItem in mDatsForFormats){
    if (mDatItem.stringValue) {
        NSLog(@"\nkey %@\nvalue %@",mDatItem.key,mDatItem.stringValue);
    }
    NSLog(@"%@",mDatItem);

}
