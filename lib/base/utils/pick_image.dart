import "package:image_picker/image_picker.dart";


pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? pickedImage = await imagePicker.pickImage(source: source);

  if(pickedImage != null) {
    return await pickedImage.readAsBytes();
  }
}