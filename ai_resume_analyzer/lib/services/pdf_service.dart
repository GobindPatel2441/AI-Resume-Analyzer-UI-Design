import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  static Future<PlatformFile?> pickPdf() async {
    try {
      debugPrint("PdfService: [STEP 1] Initializing file picking...");
      
      debugPrint("PdfService: [STEP 2] Calling pickFiles...");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
        withData: true, // Crucial for Web
        allowCompression: false, // Essential for some Android devices to prevent hangs
      );

      debugPrint("PdfService: [STEP 3] pickFiles returned. Result is null? ${result == null}");

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        debugPrint("PdfService: File selected: ${file.name} (${file.size} bytes)");

        // Validate file size (5MB limit)
        if (file.size > 5 * 1024 * 1024) {
          debugPrint("PdfService: Validation failed - file too large");
          throw Exception('File size exceeds 5MB limit.');
        }

        if (file.bytes == null) {
          debugPrint("PdfService: Error - picked file has no bytes.");
          throw Exception('Failed to read file data.');
        }
        
        return file;
      } else {
        debugPrint("PdfService: User canceled file picker");
        return null;
      }
    } catch (e) {
      debugPrint("PdfService: CRITICAL ERROR - $e");
      rethrow;
    }
  }

  static Future<String> extractText(Uint8List bytes) async {
    try {
      debugPrint("PdfService: Initializing document extraction...");
      
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      
      String text = "";
      final int pageCount = document.pages.count;
      debugPrint("PdfService: Total pages to process - $pageCount");

      for (int i = 0; i < pageCount; i++) {
        debugPrint("PdfService: Extracting page ${i + 1}...");
        final String pageText = extractor.extractText(startPageIndex: i, endPageIndex: i);
        text += pageText + "\n";
      }

      document.dispose();
      debugPrint("PdfService: Extraction complete (${text.length} chars)");
      
      if (text.trim().isEmpty) {
        debugPrint("PdfService: WARNING - No text extracted from PDF.");
      }
      
      return text;
    } catch (e) {
      debugPrint("PdfService: Extraction failed - $e");
      throw Exception('Failed to extract text from PDF: $e');
    }
  }
}
