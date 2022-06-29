import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_cloud/logic/app_bloc.dart';
import 'package:photo_cloud/logic/app_events.dart';
import 'package:photo_cloud/logic/app_state.dart';
import 'package:photo_cloud/screens/storage_image_view.dart';
import 'package:photo_cloud/widgets/pop_menu.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final images = context.watch<AppBloc>().state.images ?? [];
    final picker = useMemoized(
      () => ImagePicker(),
      [key],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(source: ImageSource.gallery);
              if (image == null) return;
              context
                  .read<AppBloc>()
                  .add(AppEventUploadImage(pathOfFileToUpload: image.path));
            },
            icon: const Icon(Icons.upload),
          ),
          const MainMenuPopUP(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8.0),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: images.map((img) => StorageImageView(image: img)).toList(),
      ),
    );
  }
}
