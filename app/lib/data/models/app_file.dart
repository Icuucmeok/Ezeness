import 'dart:io';

class AppFile{
  final String? fileKey;
   String? fileName;
   String? filePath;
   String? fileType;
   String? fileExtension;

  AppFile({required File file ,required this.fileKey,}){
    fileName=file.path.split("/").last;
    fileExtension=file.path.split(".").last;
    filePath=file.path;
    fileType="file";
  }

}