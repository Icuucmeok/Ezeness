import 'dart:developer';

import 'package:ezeness/data/models/hashtag/hashtag.dart';
import 'package:ezeness/data/models/user/user.dart';
import 'package:ezeness/data/utils/error_handler.dart';
import 'package:ezeness/generated/l10n.dart';
import 'package:ezeness/logic/cubit/hashtag/hashtag_cubit.dart';
import 'package:ezeness/logic/cubit/hashtag_mentions_text_field/hashtag_mentions_text_field_cubit.dart';
import 'package:ezeness/logic/cubit/mention/mention_cubit.dart';
import 'package:ezeness/presentation/utils/helpers.dart';
import 'package:ezeness/presentation/utils/text_input_formatter.dart';
import 'package:ezeness/presentation/widgets/common/common.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertagger/fluttertagger.dart';

class MentionHashtagTextField extends StatefulWidget {
  const MentionHashtagTextField({
    // super.key,
    required this.controller,
    this.hintText,
    this.suffixWidget,
    this.minLine,
    this.isReadOnly = false,
    this.validator,
    this.horizontalMargin,
    this.verticalPadding,
    this.maxLine,
    required this.label,
    this.showMaxLengthNumber = true,
    this.isDecimal = false,
    this.isNumber = false,
    this.isEmpty = false,
    this.withBorder = true,
    this.maxLength,
    this.onSave,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.isUnderLineStyle = false,
    this.withButtons = false,
  });

  final FlutterTaggerController controller;

  final String label;
  final bool withButtons;
  final String? hintText;
  final bool isNumber;
  final bool isEmpty;
  final bool isDecimal;
  final bool isReadOnly;
  final bool withBorder;
  final bool showMaxLengthNumber;
  final String? Function(String? value)? validator;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final double? verticalPadding;
  final double? horizontalMargin;
  final Widget? suffixWidget;
  final VoidCallback? onSave;
  final VoidCallback? onChanged;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;

  final bool isUnderLineStyle;

  @override
  State<MentionHashtagTextField> createState() =>
      _MentionHashtagTextFieldState();
}

class _MentionHashtagTextFieldState extends State<MentionHashtagTextField> {
  bool isRtlText = false;

  @override
  void initState() {
    widget.controller.addListener(_handleTextChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    final controller = widget.controller;

    // Ensure the selection is within the valid range
    final textLength = controller.text.length;
    final selection = controller.selection;

    if (selection.end > textLength) {
      // Set the selection to a valid range
      controller.selection = TextSelection.collapsed(offset: textLength);
    }
  }

  @override
  Widget build(BuildContext context) {
    final flutterTagger = FlutterTagger(
      controller: widget.controller,
      onSearch: (query, triggerCharacter) {
        if (triggerCharacter == "@") {
          context.read<HashtagMentionsTextFieldCubit>().setMentionsActive();
          context.read<MentionCubit>().getMention(query);
        }
        if (triggerCharacter == "#") {
          context.read<HashtagMentionsTextFieldCubit>().setHashtagsActive();
          context.read<HashtagCubit>().getHashtag(query);
        }
      },
      triggerCharacterAndStyles: {
        '@': TextStyle(color: AppColors.primaryColor),
        '#': TextStyle(color: AppColors.primaryColor),
      },
      overlayPosition: OverlayPosition.top,
      overlayHeight: MediaQuery.of(context).size.height * 0.3,
      overlay: _Overlay(
        controller: widget.controller,
      ),
      builder: (context, textFieldKey) {
        return TextField(
          key: textFieldKey,
          onTap: widget.onTap,
          readOnly: widget.isReadOnly,
          maxLength: widget.maxLength,
          maxLines: widget.maxLine ?? 1,
          minLines: widget.minLine ?? 1,
          keyboardType: widget.isNumber ? TextInputType.number : null,
          inputFormatters: widget.inputFormatters != null
              ? widget.inputFormatters
              : <TextInputFormatter>[
                  if (widget.isNumber && !widget.isDecimal)
                    FilteringTextInputFormatter.digitsOnly,
                  if (widget.isNumber && widget.isDecimal)
                    DecimalTextInputFormatter()
                ],
          textDirection: isRtlText ? TextDirection.rtl : TextDirection.ltr,
          style: Theme.of(context).textTheme.bodyLarge,
          cursorColor: AppColors.primaryColor,
          controller: widget.controller,
          decoration: InputDecoration(
            counterText: widget.showMaxLengthNumber ? null : "",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: widget.hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w300),
            suffixIcon: widget.suffixWidget,
            label: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 15.sp,
                    ),
                children: [
                  TextSpan(text: widget.label),
                  if (widget.isEmpty && !widget.isReadOnly)
                    TextSpan(
                      text: "   (${S.current.optional})",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.greyDark,
                            fontSize: 15.sp,
                          ),
                    ),
                ],
              ),
            ),
            filled: true,
            fillColor: Colors.transparent,
            focusedBorder: widget.isUnderLineStyle
                ? UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: AppColors.textFieldBorderLight, width: 1.w),
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: AppColors.textFieldBorderLight, width: 1.w),
                  ),
            enabledBorder: widget.withBorder
                ? widget.isUnderLineStyle
                    ? UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: AppColors.textFieldBorderLight, width: 1.w),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: AppColors.textFieldBorderLight, width: 1.w),
                      )
                : InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
                horizontal: Constants.mainPadding,
                vertical: widget.verticalPadding ?? 15),
            border: widget.withBorder
                ? widget.isUnderLineStyle
                    ? UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))
                : InputBorder.none,
          ),
          onChanged: (v) {
            if (widget.onChanged != null) {
              widget.onChanged!();
            }
            setState(() {
              isRtlText = Helpers.isRtlText(v);
            });
          },
          enableInteractiveSelection: true,
          contextMenuBuilder:
              (BuildContext context, EditableTextState editableTextState) {
            return AdaptiveTextSelectionToolbar(
              anchors: editableTextState.contextMenuAnchors,
              children: editableTextState.contextMenuButtonItems
                  .map((ContextMenuButtonItem buttonItem) {
                return CupertinoButton(
                  borderRadius: null,
                  color: (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.greyDark
                      : AppColors
                          .whiteColor), // Here you can change the background color
                  disabledColor: Colors.green,
                  onPressed: buttonItem.onPressed,
                  padding: const EdgeInsets.all(10.0),
                  pressedOpacity: 0.7,
                  child: SizedBox(
                    // width: 50.0,
                    child: Text(
                        CupertinoTextSelectionToolbarButton.getButtonLabel(
                          context,
                          buttonItem,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                );
              }).toList(),
            );
          },
          scrollPhysics: BouncingScrollPhysics(),
        );
      },
    );

    return !widget.withButtons
        ? flutterTagger
        : Column(
            children: [
              flutterTagger,
              SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => widget.controller.text += "#",
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.grey),
                      ),
                      child: Text(
                        "#${S.current.hashTags}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => widget.controller.text += "@",
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.grey),
                      ),
                      child: Text(
                        "@${S.current.userName}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
  }
}

class _Overlay extends StatefulWidget {
  const _Overlay({
    required this.controller,
  });

  final FlutterTaggerController controller;

  @override
  State<_Overlay> createState() => _OverlayState();
}

class _OverlayState extends State<_Overlay> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HashtagMentionsTextFieldCubit,
        HashtagMentionsTextFieldStates>(
      builder: (context, state) {
        log(state.runtimeType.toString());

        if (state is HashTagsActiveState) return _buildHashtagOverlay(context);
        if (state is MentionsActiveState) return _buildMentionOverlay(context);
        return SizedBox.shrink();
      },
    );
  }

  bool viewOverlay = true;

  void onDataAction(bool viewOverlay) {
    setState(() {
      this.viewOverlay = viewOverlay;
    });
  }

  Widget _buildHashtagOverlay(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child:
          BlocConsumer<HashtagCubit, HashtagState>(listener: (context, state) {
        if (state is HashtagLoaded) {
          List<HashtagModel> list = state.response.hashtagList!;

          if (list.isEmpty) {
            onDataAction(false);
            return;
          }
          onDataAction(true);
        } else {
          onDataAction(true);
        }
      }, builder: (context, state) {
        if (!viewOverlay) return SizedBox.shrink();

        if (state is HashtagLoaded) {
          List<HashtagModel> list = state.response.hashtagList!;
          if (list.isEmpty) {
            return Material(
                child: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkColor
                  : AppColors.grey,
              child: EmptyCard(withIcon: false),
            ));
          }

          return Material(
              child: Container(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkColor
                      : AppColors.grey,
                  child: ListView(
                    children: list
                        .map((e) => ListTile(
                              title: Text("#${e.name}"),
                              trailing: Text("${e.count} POSTS"),
                              onTap: () {
                                widget.controller
                                    .addTag(id: "${e.name}", name: "${e.name}");
                              },
                            ))
                        .toList(),
                  )));
        }
        if (state is HashtagLoading) {
          return Material(
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkColor
                  : AppColors.grey,
              child: SizedBox(
                width: 500,
                height: 300,
                child: CenteredCircularProgressIndicator(),
              ),
            ),
          );
        }
        if (state is HashtagFailure) {
          return Material(
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkColor
                  : AppColors.grey,
              child: Center(
                child: Text(
                  ErrorHandler(exception: state.exception).getErrorMessage(),
                ),
              ),
            ),
          );
        }
        return SizedBox();
      }),
    );
  }

  Widget _buildMentionOverlay(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child:
          BlocConsumer<MentionCubit, MentionState>(listener: (context, state) {
        if (state is MentionLoaded) {
          List<User> list = state.response.userList!;

          if (list.isEmpty) {
            onDataAction(false);
            return;
          }
          onDataAction(true);
        } else {
          onDataAction(true);
        }
      }, builder: (context, state) {
        if (!viewOverlay) return SizedBox.shrink();

        if (state is MentionLoaded) {
          List<User> list = state.response.userList!;
          if (list.isEmpty) {
            return Material(
              child: Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkColor
                    : AppColors.grey,
                child: EmptyCard(withIcon: false),
              ),
            );
          }
          return Material(
              child: Container(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkColor
                      : AppColors.grey,
                  child: ListView(
                    children: list
                        .map((e) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(e.image ?? ""),
                              ),
                              title: Text(
                                "@${e.getUserName()}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                e.posts != null ? "${e.posts ?? ""} POSTS" : "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text("${e.name}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.darkGrey)),
                              onTap: () {
                                widget.controller.addTag(
                                    id: "${e.username}", name: "${e.username}");
                              },
                            ))
                        .toList(),
                  )));
        }
        if (state is MentionLoading) {
          return Material(
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkColor
                  : AppColors.grey,
              child: SizedBox(
                width: 500,
                height: 300,
                child: CenteredCircularProgressIndicator(),
              ),
            ),
          );
        }
        if (state is MentionFailure) {
          return Material(
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkColor
                  : AppColors.grey,
              child: Center(
                child: Text(
                  ErrorHandler(exception: state.exception).getErrorMessage(),
                ),
              ),
            ),
          );
        }
        return SizedBox();
      }),
    );
  }
}
