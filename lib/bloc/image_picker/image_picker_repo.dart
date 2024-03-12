import 'package:image_picker/image_picker.dart';

class ImagePickerRepository {
  Future<String> pickImageFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return '';
    }

    return image.path;
  }

  Future<String> pickImage() async {
    return 'path';
  }

  Future<String> pickVideo() async {
    return 'path';
  }
}
