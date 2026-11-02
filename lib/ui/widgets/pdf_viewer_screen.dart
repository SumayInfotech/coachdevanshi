import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String? url;
  final String? assetsPDF;

  const PDFViewerScreen({super.key, this.url, this.assetsPDF});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('PDF Viewer'),
      ),
      body: Builder(
        builder: (context) {
          if(url != null) {
            return SfPdfViewer.network(
              url!,
              canShowScrollStatus: true,
              canShowPaginationDialog: true,
              canShowHyperlinkDialog: true,
              enableTextSelection: true,
            );
          } else {
            return SfPdfViewer.file(
              File(assetsPDF!),
              canShowScrollStatus: true,
              canShowPaginationDialog: true,
              canShowHyperlinkDialog: true,
              enableTextSelection: true,
            );
          }
        }
      ),
    );
  }
}
