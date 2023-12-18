import 'dart:io';
import 'package:clippy_flutter/arc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:make_musician/test_firebase.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class pdfFile extends StatefulWidget {
  const pdfFile({super.key});

  @override
  State<pdfFile> createState() => _pdfFileState();
}

class _pdfFileState extends State<pdfFile> {
  final doc = pw.Document();
  File? file;

//Start Design of Billing

  Future<void> GeneratePdf() async {
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.topCenter,
              margin:
                  const pw.EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    height: 30,
                  ),
                  pw.SizedBox(
                    child: pw.Row(
                      children: [
                        pw.Text(
                          "Make Musician",
                          style: const pw.TextStyle(fontSize: 15, height: 2),
                        ),
                      ],
                    ),
                  ),
                  pw.Divider(
                    thickness: 3,
                    indent: 10,
                    endIndent: 10,
                    height: 20,
                  ),
                  pw.SizedBox(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          "INVOICE",
                          style: const pw.TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                        style: const pw.TextStyle(fontSize: 15, height: 1),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 100.0),
                      ),
                      pw.Text(
                        "Order id:",
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 2,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Invoice Id:",
                        style: const pw.TextStyle(fontSize: 15, height: 1),
                      ),

                      pw.SizedBox(height: 5),

                      pw.Text(
                        "10101222",
                        style: const pw.TextStyle(fontSize: 15, height: 1),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 2,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Customer Name:",
                        style: const pw.TextStyle(fontSize: 15, height: 1),
                      ),
                      pw.SizedBox(height: 5),

                      pw.Text(
                        "Mohan Das",
                        style: const pw.TextStyle(fontSize: 15, height: 1),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Address:",
                        style: const pw.TextStyle(fontSize: 15, height: 1),
                      ),
                      pw.SizedBox(height: 5),

                      pw.Text(
                        "Patel vas, Ambika niwas,\nKaligam, Sabarmati,\nAhmedabad - 392020",
                        style: const pw.TextStyle(fontSize: 15, height: 1),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 6,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Payment Mode:",
                        style: const pw.TextStyle(fontSize: 15, height: 1),
                      ),
                      pw.SizedBox(height: 5),

                      pw.Text(
                        "Cash On Delivery",
                        style: const pw.TextStyle(fontSize: 15, height: 1),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 30,
                  ),
                  pw.Divider(
                    thickness: 3, // thickness of the line
                    indent: 10, // empty space to the leading edge of divider.
                    endIndent:
                        10, // empty space to the trailing edge of the divider.
                    // color:
                    // Colors.grey, // The color to use when painting the line.
                    height: 20, // The divider's height extent.
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Table(
                      defaultColumnWidth: const pw.FixedColumnWidth(120.0),
                      border: pw.TableBorder.all(
                          style: pw.BorderStyle.solid, width: 2),
                      children: [
                        pw.TableRow(children: [
                          pw.Column(children: [
                            pw.Text('Product Name',
                                style: const pw.TextStyle(fontSize: 15.0)) //Column-1
                          ]),
                          pw.Column(children: [
                            pw.Text('Quantity',
                                style: const pw.TextStyle(fontSize: 15.0)) //Column-2
                          ]),
                          pw.Column(children: [
                            pw.Text('Price',
                                style: const pw.TextStyle(fontSize: 15.0)) //Column-3
                          ]),
                        ]),
                        pw.TableRow(children: [
                          pw.Column(children: [
                            pw.Text(
                              'Harmonium',
                              style: const pw.TextStyle(fontSize: 15),
                            ),
                          ]),
                          pw.Column(children: [pw.Text('5')]),
                          pw.Column(children: [pw.Text('50000₹')]),
                        ]),
                        pw.TableRow(children: [
                          pw.Column(children: [pw.Text('Tabla')]),
                          pw.Column(children: [pw.Text('2')]),
                          pw.Column(children: [pw.Text('10000₹')]),
                        ]),
                        pw.TableRow(children: [
                          pw.Column(children: [pw.Text('Guitar')]),
                          pw.Column(children: [pw.Text('1')]),
                          pw.Column(children: [pw.Text('2000₹')]),
                        ]),
                      ]),
                  pw.SizedBox(height: 50),
                  pw.Row(children: [
                    pw.Text(
                      "Thank you for Shopping",
                      style: const pw.TextStyle(fontSize: 20),
                    )
                  ]),
                ],
              ));
        }));

    final output = await getExternalStorageDirectory(); //Get The Path
    String PathToWrite = output!.path + '/Billnew7.pdf'; //Path Name
    File outputFile = File(PathToWrite);
    outputFile.writeAsBytesSync(await doc.save()); //Save the pdf file

    print(PathToWrite);
    Fluttertoast.showToast(msg: "$PathToWrite  Save"); //view on console
    print("save");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pdf Generator")),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    GeneratePdf();
                    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Test_Firebase()));
                  },
                  child: const Text("Download Pdf")),
            ],
          )),
    );
  }
}
