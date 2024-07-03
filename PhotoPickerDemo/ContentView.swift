import SwiftUI
import PhotosUI

struct ContentView: View {
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
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        image = Image(uiImage: uiImage)
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
    ContentView()
}
