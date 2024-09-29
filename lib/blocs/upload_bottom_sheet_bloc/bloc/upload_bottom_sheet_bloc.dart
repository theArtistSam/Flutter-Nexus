import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/repositories/content_repository.dart';
import 'package:nexus/services/extractive_model_service.dart';
import 'package:nexus/utils/enums.dart';
import 'package:nexus/utils/extraction.dart';
import 'package:path/path.dart' as path;

part 'upload_bottom_sheet_event.dart';
part 'upload_bottom_sheet_state.dart';

class UploadBottomSheetBloc
    extends Bloc<UploadBottomSheetEvent, UploadBottomSheetState> {
  UploadBottomSheetBloc() : super(const UploadBottomSheetInitial()) {
    on<Select>(select);
    on<ToggleSelectFile>(toggleSelectFile);
    on<SelectAiFeature>(selectAiFeature);
    on<RemoveSelectedFiles>(removeSelectedFiles);
    on<PickFile>(pickFile);
    on<GetResponse>(getResponse);
    on<UploadFiles>(_uploadFiles);
  }

  FutureOr<void> select(Select event, Emitter<UploadBottomSheetState> emit) {
    final currentState = state as UploadBottomSheetInitial;

    // Create a new list of files with all boolean values set to false
    final List<Map<File, bool>> updatedFiles =
        currentState.pickedFiles.map((file) {
      final key = file.keys.first;
      return {key: false};
    }).toList();

    emit(currentState.copyWith(
      isSelected: !currentState.isSelected,
      pickedFiles: updatedFiles,
    ));
  }

  FutureOr<void> toggleSelectFile(
      ToggleSelectFile event, Emitter<UploadBottomSheetState> emit) {
    final currentState = state as UploadBottomSheetInitial;

    // Create a new list by mapping the current files
    final updatedFiles = currentState.pickedFiles.map((fileMap) {
      // Check if the fileMap contains the file with the name from the event
      if (fileMap.containsKey(event.file)) {
        final file = fileMap.keys.first; // Get the file
        final isSelected = fileMap[file]!; // Get the current selection status

        // Toggle the selection status
        return {file: !isSelected};
      }
      return fileMap;
    }).toList();

    emit(currentState.copyWith(pickedFiles: updatedFiles));
  }

  FutureOr<void> selectAiFeature(
      SelectAiFeature event, Emitter<UploadBottomSheetState> emit) {
    final currentState = state as UploadBottomSheetInitial;
    emit(currentState.copyWith(aiFeature: event.aiFeature));
  }

  FutureOr<void> removeSelectedFiles(
      RemoveSelectedFiles event, Emitter<UploadBottomSheetState> emit) {
    final currentState = state as UploadBottomSheetInitial;

    // Filter out files where the boolean value is true
    final List<Map<File, bool>> updatedFiles = currentState.pickedFiles
        .where((fileMap) => fileMap.values.first == false)
        .toList();

    // Emit the updated state with the remaining files
    emit(currentState.copyWith(
      pickedFiles: updatedFiles,
      isSelected: updatedFiles.isNotEmpty,
    ));
  }

  FutureOr<void> pickFile(
    PickFile event,
    Emitter<UploadBottomSheetState> emit,
  ) {
    final currentState = state;
    if (currentState is UploadBottomSheetInitial) {
      // Create a mutable copy of the pickedFiles list
      final updatedFiles = List<Map<File, bool>>.from(currentState.pickedFiles);

      // Add the new file to the mutable list
      updatedFiles.add({event.file: false});

      // Emit the updated state with the modified files list
      emit(currentState.copyWith(
        pickedFiles: updatedFiles, // Ensure this is the mutable updated list
      ));
    }
  }

  // TODO: Separate the logic for translation
  Future<void> getResponse(
    GetResponse event,
    Emitter<UploadBottomSheetState> emit,
  ) async {
    try {
      final currentState = state as UploadBottomSheetInitial;
      final List<Map<File, bool>> pickedFiles = currentState.pickedFiles;
      List<ContentModel> contentList = currentState.content;
      int processedCount = currentState.count;

      Future<void> handleFileProcessing(
        Future<List<ContentModel>> Function() processFunction,
      ) async {
        contentList = List<ContentModel>.from(await processFunction());
        emit(currentState.copyWith(
          status: ReturnResponseStatus.initial,
          content: contentList,
          count: processedCount,
        ));
      }

      for (var pickedFile in pickedFiles) {
        File file = pickedFile.keys.first;
        String fileExtension = file.path.split('.').last.toLowerCase();

        processedCount += 1;
        emit(currentState.copyWith(
          status: ReturnResponseStatus.processing,
          count: processedCount,
        ));

        switch (fileExtension) {
          case 'docx':
          case 'doc':
            await handleFileProcessing(
                () => _processWord(file: file, content: contentList));
            break;
          case 'pdf':
            await handleFileProcessing(
                () => _processPdf(file: file, content: contentList));
            break;
          case 'mp4':
          case 'mkv':
            await handleFileProcessing(
                () => _processVideo(file: file, content: contentList));
            break;
          case 'mp3':
          case 'aac':
          case 'm4a':
            await handleFileProcessing(
                () => _processAudio(file: file, content: contentList));
            break;
          case 'jpeg':
          case 'png':
            await handleFileProcessing(
                () => _processImage(file: file, content: contentList));
            break;
          default:
            print('Unsupported file type: $fileExtension');
            break;
        }
      }

      print("Files Processed Successfully!!");
      add(UploadFiles());
    } catch (e) {
      print("ERROR: $e");
    }
  }

  FutureOr<void> _uploadFiles(
    UploadFiles event,
    Emitter<UploadBottomSheetState> emit,
  ) async {
    try {
      final currentState = state as UploadBottomSheetInitial;
      final pickedFiles = currentState.pickedFiles;
      final contentList = currentState.content;

      final List<File> files = pickedFiles.map((map) {
        final firstKey = map.keys.first;
        return firstKey;
      }).toList();

      await ContentRepository().uploadContentList(
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        contentList: contentList,
        files: files,
      );

      emit(currentState.copyWith(status: ReturnResponseStatus.success));

      print("???${contentList.length}");
    } catch (e) {
      print("Some shit has gotten real $e");
    }
  }

  Future<List<ContentModel>> _processWord({
    required File file,
    required List<ContentModel> content,
  }) async {
    final String filename = file.path.split(path.separator).last;

    final extractedText = await Extraction.extractWordText(docxFile: file);

    // Send extracted text
    final responseText = await ExtractiveModelService()
        .sendText(text: extractedText.trim(), length: 'medium');

    // Update content list
    final updatedContent = List<ContentModel>.from(content)
      ..add(_getContent(
        extractedText: extractedText.trim(),
        responseText: responseText.trim(),
        fileName: filename,
        type: 'document',
      ));

    return updatedContent;
  }

  Future<List<ContentModel>> _processImage({
    required File file,
    required List<ContentModel> content,
  }) async {
    final String filename = file.path.split(path.separator).last;

    // Send image files
    final extractedText = await ExtractiveModelService()
        .sendImage(imageFile: file, fileExtension: filename.split('.').last);

    // Parse the responseData if it's in JSON format
    Map<String, dynamic> jsonResponse = jsonDecode(extractedText);

    // Extract the output_text field and clean it up (remove '\n' if necessary)
    String transcribedText = jsonResponse['output_text'].replaceAll('\\n', ' ');

    // Send extracted text
    final responseText = await ExtractiveModelService()
        .sendText(text: transcribedText.trim(), length: 'medium');

    final updatedContent = List<ContentModel>.from(content)
      ..add(_getContent(
        extractedText: transcribedText.trim(),
        responseText: responseText.trim(),
        fileName: filename,
        type: 'image',
      ));

    return updatedContent;
  }

  Future<List<ContentModel>> _processPdf({
    required File file,
    required List<ContentModel> content,
  }) async {
    final String filename = file.path.split(path.separator).last;

    // Extract text from PDF documents
    final extractedText = await Extraction.extractPdfText(pdfFile: file);

    // Send extracted text
    final responseText = await ExtractiveModelService()
        .sendText(text: extractedText.trim(), length: 'medium');

    // Update content list
    final updatedContent = List<ContentModel>.from(content)
      ..add(_getContent(
        extractedText: extractedText.trim(),
        responseText: responseText.trim(),
        fileName: filename,
        type: 'document',
      ));

    return updatedContent;
  }

  Future<List<ContentModel>> _processVideo({
    required File file,
    required List<ContentModel> content,
  }) async {
    final String filename = file.path.split(path.separator).last;

    // Extract audio from video files
    final extractedAudio =
        await Extraction.extractAudioFromVideo(videoFile: file);

    // Send extracted audio
    final extractedText = await ExtractiveModelService()
        .sendAudio(audioFile: extractedAudio!, fileExtension: 'aac');

    // Parse the responseData if it's in JSON format
    Map<String, dynamic> jsonResponse = jsonDecode(extractedText);

    // Extract the output_text field and clean it up (remove '\n' if necessary)
    String transcribedText = jsonResponse['output_text'].replaceAll('\\n', ' ');

    // Send extracted text
    final responseText = await ExtractiveModelService()
        .sendText(text: transcribedText.trim(), length: 'medium');

    final updatedContent = List<ContentModel>.from(content)
      ..add(_getContent(
        extractedText: transcribedText.trim(),
        responseText: responseText.trim(),
        fileName: filename,
        type: 'video',
      ));
    return updatedContent;
  }

  Future<List<ContentModel>> _processAudio({
    required File file,
    required List<ContentModel> content,
  }) async {
    final String filename = file.path.split(path.separator).last;
// Send audio files
    final extractedText = await ExtractiveModelService()
        .sendAudio(audioFile: file, fileExtension: filename.split('.').last);

    // Parse the responseData if it's in JSON format
    Map<String, dynamic> jsonResponse = jsonDecode(extractedText);

    String transcribedText = jsonResponse['output_text'].replaceAll('\\n', ' ');

    if (transcribedText.isEmpty) {
      throw Exception('Transcribed text is empty');
    }

    // Log before sending the extracted text
    print('Transcribed text: $transcribedText');

    // Send extracted text
    final responseText = await ExtractiveModelService().sendText(
      text: transcribedText.trim(),
      length: 'medium',
    );

    // Log the received response
    print('Response from sendText: $responseText');

    if (responseText.isEmpty) {
      throw Exception('Received empty response from sendText.');
    }

    final updatedContent = List<ContentModel>.from(content)
      ..add(_getContent(
        extractedText: transcribedText.trim(),
        responseText: responseText.trim(),
        fileName: filename,
        type: 'audio',
      ));
    return updatedContent;
  }

  ContentModel _getContent({
    required String extractedText,
    required String responseText,
    required String fileName,
    required String type,
    bool isSummarization = true,
  }) {
    return ContentModel(
        extractedText: extractedText,
        dateUpdated: DateTime.now().toString(),
        translation: !isSummarization
            ? ContentConfigure(
                text: responseText,
                status: Status(isLiked: false, isDisliked: false))
            : null,
        summarization: isSummarization
            ? ContentConfigure(
                text: responseText,
                status: Status(isLiked: false, isDisliked: false))
            : null,
        type: type,
        title: fileName,
        tags: [],
        // Mock Data for now
        thumbnail:
            'https://firebasestorage.googleapis.com/v0/b/nexus-ef4c1.appspot.com/o/mock_data%2Fcontent.png?alt=media&token=e4bbcb71-fa53-4f4f-8481-dde5c7a1e59b');
  }
}
