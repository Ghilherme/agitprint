import 'package:agitprint/apis/deletes.dart';
import 'package:agitprint/apis/updates.dart';
import 'package:agitprint/apis/uploads.dart';
import 'package:agitprint/components/borders.dart';
import 'package:agitprint/components/custom_text_form_field.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/components/image_picker.dart';
import 'package:agitprint/models/payments.dart';
import 'package:agitprint/models/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class ReceiptDialog extends StatefulWidget {
  final PaymentsModel payment;

  const ReceiptDialog({Key key, this.payment}) : super(key: key);

  @override
  _ReceiptDialogState createState() => _ReceiptDialogState();
}

class _ReceiptDialogState extends State<ReceiptDialog> {
  bool _progressBarActive = false;
  final _form = GlobalKey<FormState>();
  PaymentsModel _paymentsModel;
  String _fileReceiptUpload = '';

  initState() {
    super.initState();

    _paymentsModel = PaymentsModel.fromPayment(widget.payment);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _form,
        child: SimpleDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          title: widget.payment.filial.isEmpty
              ? Center(
                  child: Text(
                  widget.payment.type,
                  style: GoogleTextStyles.customTextStyle(fontSize: 20),
                ))
              : Center(
                  child: Text(
                  widget.payment.filial + ' - ' + widget.payment.type,
                  style: GoogleTextStyles.customTextStyle(fontSize: 20),
                )),
          children: [
            CustomTextFormField(
              enabled: false,
              textInputType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              labelText: "Fornecedor",
              initialValue: widget.payment.providerName,
              border: Borders.customOutlineInputBorder(),
              enabledBorder: Borders.customOutlineInputBorder(),
              focusedBorder: Borders.customOutlineInputBorder(
                color: const Color(0xFF655796),
              ),
              labelStyle: GoogleTextStyles.customTextStyle(),
              hintTextStyle: GoogleTextStyles.customTextStyle(),
              textStyle: GoogleTextStyles.customTextStyle(),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            ImagePickerSource(
              image: _paymentsModel.imageReceipt,
              callback: callbackImage,
              imageQuality: 40,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Center(
                child: _progressBarActive
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : ElevatedButton(
                        child: Text('Anexar recibo'), onPressed: attachReceipt))
          ],
        ));
  }

  callbackImage(file) {
    setState(() {
      _fileReceiptUpload = file;
    });
  }

  void attachReceipt() async {
    setState(() {
      _progressBarActive = true;
    });

    //referencia o doc e se tiver ID atualiza, se nao cria um ID novo
    DocumentReference paymentDB = FirebaseFirestore.instance
        .collection('pagamentos')
        .doc(_paymentsModel.id);

    String refPath =
        'pagamentos/' + paymentDB.id + '/' + paymentDB.id + '_recibo.png';

    num _pendingPaymentQtnAdd = 0;

    if (_paymentsModel.status == Status.pending) {
      if (_fileReceiptUpload.isNotEmpty) {
        _paymentsModel.imageReceipt =
            await Uploads.uploadFileImage(refPath, _fileReceiptUpload);
        _pendingPaymentQtnAdd -= 1;
      }
    }

    if (_paymentsModel.status == Status.active) {
      if (_fileReceiptUpload.isEmpty) {
        Deletes.deleteFileImage(refPath);
        _pendingPaymentQtnAdd += 1;
        _paymentsModel.imageReceipt = '';
      }
    }

    _fileReceiptUpload.isEmpty
        ? _paymentsModel.status = Status.pending // sem foto fica pendente
        : _paymentsModel.status = Status.active;

    //Sempre atualiza data do anexo comprovante
    _paymentsModel.receiptDate = DateTime.now();

    Updates.attachReceiptTransaction(_paymentsModel, _pendingPaymentQtnAdd)
        .then((value) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Comprovante anexado com sucesso.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ))
        .then((value) => setState(() {
              _progressBarActive = false;
            }))
        .catchError((error) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Falha ao anexar comprovante.'),
                  content: Text('Erro: ' + error),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ))
        .then((value) => setState(() {
              _progressBarActive = false;
            }));
  }
}
