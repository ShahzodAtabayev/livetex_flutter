import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livetex_flutter/livetex_flutter.dart';

class FooterWidget extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;

  const FooterWidget(
      {super.key,
      required this.focusNode,
      required this.textEditingController});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  bool _isValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    _focusNode = widget.focusNode;
    _controller = widget.textEditingController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      color: Colors.white70,
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: mediaQuery.padding.bottom + 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              onChanged: (value) {
                setState(() {
                  _isValid = value.replaceAll(' ', '').isNotEmpty;
                });
              },
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Enter message',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelAlignment: FloatingLabelAlignment.start,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                floatingLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  onPressed: () {
                    _showSelectionBottomSheet();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(Icons.attach_file_rounded),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _isValid ? _sendMessagePressed : null,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _isValid ? Colors.blue : Colors.blueGrey,
              ),
              child: _isLoading
                  ? Container(
                      width: 20,
                      height: 20,
                      padding: const EdgeInsets.all(12),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.black38,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessagePressed() async {
    setState(() {
      _isLoading = true;
    });
    try {
      LiveTexFlutter.instance.messagesHandler.sendTextMessage(_controller.text);
      _controller.clear();
      setState(() {
        _isValid = false;
      });
    } catch (e, s) {
      log("Error sending message", error: e, stackTrace: s);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showSelectionBottomSheet() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final fileUploadedResponse = await LiveTexFlutter
          .instance.networkManager.apiManager
          .uploadFile(File(pickedImage.path));
      await LiveTexFlutter.instance.messagesHandler
          .sendFileMessage(fileUploadedResponse);
    }
    // final actions = <SelectionButtonsItem>[];
    // actions.add(
    //   SelectionButtonsItem(
    //     backgroundColor: Colors.transparent,
    //     icon: Assets.icons.icGallery.svg(
    //       width: Dimensions.iconSize24,
    //       colorFilter: ColorFilter.mode(BeepulThemes.getIconPrimaryColor(isDarkMode), BlendMode.srcIn),
    //     ),
    //     suffixIcon: Icon(
    //       Icons.chevron_right_outlined,
    //       color: BeepulThemes.getIconPrimaryColor(isDarkMode),
    //     ),
    //     onTap: () {
    //       cubit.pickImageFromGallery();
    //       Navigator.pop(context);
    //     },
    //     isTitle: false,
    //     title: context.locale.uploadFromGallery,
    //   ),
    // );
    // actions.add(SelectionButtonsItem(
    //   backgroundColor: Colors.transparent,
    //   icon: Assets.icons.icPhotograph.svg(
    //     colorFilter: ColorFilter.mode(BeepulThemes.getIconPrimaryColor(isDarkMode), BlendMode.srcIn),
    //   ),
    //   suffixIcon: Icon(
    //     Icons.chevron_right_outlined,
    //     color: BeepulThemes.getIconPrimaryColor(isDarkMode),
    //   ),
    //   onTap: () {
    //     cubit.pickImageFromCamera();
    //     Navigator.pop(context);
    //   },
    //   isTitle: false,
    //   title: context.locale.photograph,
    // ));
    // CustomBottomSheet.baseBottomSheet(
    //   context: context,
    //   useBottomPadding: true,
    //   padding: EdgeInsets.zero,
    //   child: MultiSelectionBottomSheetWidget(items: actions),
    // );
  }
}
