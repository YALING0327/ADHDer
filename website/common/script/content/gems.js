const blocks = {
  '4gems': {
    gems: 4,
    iosProducts: ['com.adhderapp.ios.Adhder.4gems'],
    androidProducts: ['com.adhderapp.android.adhder.iap.4gems'],
    price: 99, // in cents, web only
  },
  '21gems': {
    gems: 21,
    iosProducts: [
      'com.adhderapp.ios.Adhder.20gems',
      'com.adhderapp.ios.Adhder.21gems',
    ],
    androidProducts: [
      'com.adhderapp.android.adhder.iap.20.gems',
      'com.adhderapp.android.adhder.iap.21.gems',
    ],
    price: 499, // in cents, web only
  },
  '42gems': {
    gems: 42,
    iosProducts: ['com.adhderapp.ios.Adhder.42gems'],
    androidProducts: ['com.adhderapp.android.adhder.iap.42gems'],
    price: 999, // in cents, web only
  },
  '84gems': {
    gems: 84,
    iosProducts: ['com.adhderapp.ios.Adhder.84gems'],
    androidProducts: ['com.adhderapp.android.adhder.iap.84gems'],
    price: 1999, // in cents, web only
  },
};

// Add the block key to all blocks
Object.keys(blocks).forEach(blockKey => {
  const block = blocks[blockKey];
  block.key = blockKey;
});

export default blocks;
