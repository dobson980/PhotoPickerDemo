# PhotoPickerDemo

PhotoPickerDemo is a SwiftUI application that demonstrates how to implement both single and multiple photo pickers using `PhotosUI`. This app allows users to select images from their photo library and display them within the app.

## Features

- **Single Photo Picker**: Select and display a single image.
- **Multiple Photo Picker**: Select and display multiple images.

## Screenshots

![PhotoPickerDemo](screenshots/demo.gif)

## Requirements

- iOS 15.0+
- Xcode 13.0+
- SwiftUI

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/dobson980/PhotoPickerDemo.git
   ```
2. Open the project in Xcode:
   ```bash
   cd PhotoPickerDemo
   open PhotoPickerDemo.xcodeproj
   ```

## Usage

### Single Photo Picker

The `SinglePhotoPicker` view allows users to pick a single image from their photo library. The selected image is displayed in the app.

### Multiple Photo Picker

The `MultiPhotoPicker` view allows users to pick multiple images from their photo library. The selected images are displayed in a scrollable list.

## Code Overview

### PhotoPickerDemoApp

`PhotoPickerDemoApp` is the entry point of the app.

```swift
import SwiftUI

@main
struct PhotoPickerDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### ContentView

`ContentView` sets up a `TabView` with two tabs: one for the single photo picker and one for the multiple photo picker.

```swift
import SwiftUI
import PhotosUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Tab("SinglePhoto", systemImage: "photo") {
                SinglePhotoPicker()
            }
            Tab("MultiPhoto", systemImage: "photo") {
                MultiPhotoPicker()
            }
        }
    }
}

#Preview {
    ContentView()
}
```

### SinglePhotoPicker

`SinglePhotoPicker` allows users to pick a single image and display it.

```swift
import SwiftUI
import PhotosUI

struct SinglePhotoPicker: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var image: Image?
    
    var body: some View {
        
        VStack {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                (image ?? Image(systemName: "photo.artframe"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 200)
                    .padding(.bottom, 40)
            }
            .onChange(of: selectedItem) {
                Task {
                    if let newImage = try? await selectedItem?.loadTransferable(type: Image.self) {
                       image = newImage
                    } else {
                        print("failed")
                    }
                }
            }
            
            Text("Upload an Image")
        }
    }
}

#Preview {
    SinglePhotoPicker()
}
```

### MultiPhotoPicker

`MultiPhotoPicker` allows users to pick multiple images and display them in a scrollable list.

```swift
import SwiftUI
import PhotosUI

struct MultiPhotoPicker: View {
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<selectedImages.count, id: \.self) { i in
                        selectedImages[i]
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                }
            }
            .toolbar {
                PhotosPicker("Select Image", selection: $selectedItems, matching: .images)
            }
            .onChange(of: selectedItems) {
                Task {
                    selectedImages.removeAll()
                    
                    for item in selectedItems {
                        if let image = try? await item.loadTransferable(type: Image.self) {
                            selectedImages.append(image)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MultiPhotoPicker()
}
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
```
