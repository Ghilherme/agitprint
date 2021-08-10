import 'dart:io';
import 'package:agitprint/apis/deletes.dart';
import 'package:agitprint/apis/gets.dart';
import 'package:agitprint/apis/updates.dart';
import 'package:agitprint/apis/uploads.dart';
import 'package:agitprint/components/bank_card.dart';
import 'package:agitprint/components/bank_card_blank.dart';
import 'package:agitprint/components/borders.dart';
import 'package:agitprint/components/colors.dart';
import 'package:agitprint/components/custom_button.dart';
import 'package:agitprint/components/custom_text_form_field.dart';
import 'package:agitprint/components/google_text_styles.dart';
import 'package:agitprint/components/image_picker.dart';
import 'package:agitprint/models/payments.dart';
import 'package:agitprint/models/providers.dart';
import 'package:agitprint/models/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import 'package:share/share.dart';

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
  ProvidersModel _providersModel;

  initState() {
    super.initState();

    _paymentsModel = PaymentsModel.fromPayment(widget.payment);
    Gets.getProvidersById(_paymentsModel.idProvider)
        .then((value) => setState(() {
              _providersModel = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _form,
        child: SimpleDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          contentPadding: const EdgeInsets.all(defaultPadding),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              child: Text(
                widget.payment.providerName,
                style: GoogleTextStyles.customTextStyle(fontSize: 20),
              ),
            ),
            IconButton(
              iconSize: 20,
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ]),
          children: [
            CustomTextFormField(
              enabled: false,
              textInputType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              labelText: "Valor",
              initialValue: NumberFormat.simpleCurrency(locale: "pt_BR")
                  .format(widget.payment.amount),
              border: Borders.customOutlineInputBorder(),
              enabledBorder: Borders.customOutlineInputBorder(),
              focusedBorder: Borders.customOutlineInputBorder(
                color: const Color(0xFF655796),
              ),
              labelStyle: GoogleTextStyles.customTextStyle(),
              hintTextStyle: GoogleTextStyles.customTextStyle(),
              textStyle: GoogleTextStyles.customTextStyle(),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            CustomTextFormField(
              enabled: false,
              textInputType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              labelText: "Tipo",
              initialValue: widget.payment.type,
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
            CustomTextFormField(
              enabled: false,
              textInputType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              labelText: "Data da ação",
              initialValue:
                  "${widget.payment.actionDate.day.toString().padLeft(2, '0')}/${widget.payment.actionDate.month.toString().padLeft(2, '0')}/${widget.payment.actionDate.year.toString()}",
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
            _providersModel == null
                ? Stack(children: [
                    BankCardBlank(
                      isAdd: false,
                    ),
                    Positioned(
                        child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ))
                  ])
                : SizedBox(
                    height: 201,
                    child: Container(
                      width: 300,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _providersModel.banks.length,
                          itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: BankCard(
                                  bank: _providersModel.banks[index]))),
                    ),
                  ),
            SizedBox(
              height: defaultPadding,
            ),
            Divider(thickness: 1),
            SizedBox(
              height: defaultPadding,
            ),
            currentPeopleLogged.profiles.contains('user3')
                ? Container(
                    child: ImagePickerSource(
                      image: _paymentsModel.imageReceipt,
                      callback: callbackImage,
                      imageQuality: 40,
                      heightImageNetwork: 500,
                      widthImageNetwork: 400,
                    ),
                  )
                : _paymentsModel.imageReceipt.isEmpty
                    ? Container()
                    : Image(
                        image: Image.network(
                        _paymentsModel.imageReceipt,
                        width: 400,
                        height: 500,
                      ).image),
            SizedBox(
              height: defaultPadding,
            ),
            // _paymentsModel.imageReceipt.isEmpty
            //     ? Container()
            //     : StatefulBuilder(
            //         builder: (BuildContext context, StateSetter shareState) {
            //         return _progressBarActive
            //             ? Center(
            //                 child: CircularProgressIndicator(
            //                   backgroundColor: Colors.white,
            //                 ),
            //               )
            //             : ElevatedButton.icon(
            //                 onPressed: () async {
            //                   shareState(() {
            //                     _progressBarActive = true;
            //                   });
            //                   await _urlFileShare(_paymentsModel.imageReceipt);

            //                   shareState(() {
            //                     _progressBarActive = false;
            //                   });
            //                 },
            //                 icon: Icon(
            //                   Icons.share,
            //                 ),
            //                 label: Text('Compartilhar'));
            //       }),
            SizedBox(
              height: defaultPadding,
            ),
            currentPeopleLogged.profiles.contains('user3')
                ? StatefulBuilder(
                    builder: (BuildContext context, StateSetter buttonState) {
                    return _progressBarActive
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 50, right: 50),
                            child: CustomButton(
                              title: 'Anexar recibo',
                              elevation: 8,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                              color: AppColors.blue,
                              height: 40,
                              onPressed: () async {
                                if (_form.currentState.validate()) {
                                  buttonState(() {
                                    _progressBarActive = true;
                                  });
                                  await attachReceipt();
                                  buttonState(() {
                                    _progressBarActive = false;
                                  });
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          );
                  })
                : Container()
          ],
        ));
  }

  Future<void> _urlFileShare(String imageReceipt) async {
    try {
      if (Platform.isAndroid) {
        var response = await get(Uri.parse(imageReceipt));
        final documentDirectory = (await getExternalStorageDirectory()).path;
        File imgFile = new File(
            '$documentDirectory/' + DateTime.now().toString() + '.png');
        imgFile.writeAsBytesSync(response.bodyBytes);

        await Share.shareFiles([imgFile.path]);
      } else {
        //TODO fazer para ios depois
        Share.share('Hello, check your share files!',
            subject: 'URL File Share');
      }
    } on PlatformException catch (error) {
      print(error);
    }
  }

  callbackImage(file) {
    setState(() {
      _fileReceiptUpload = file;
    });
  }

  Future<void> attachReceipt() async {
    //referencia o doc e se tiver ID atualiza, se nao cria um ID novo
    DocumentReference refDB = FirebaseFirestore.instance
        .collection('pagamentos')
        .doc(_paymentsModel.id);

    String refPath = 'pagamentos/' + refDB.id + '/' + refDB.id + '_recibo.png';

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

    await Updates.attachReceiptTransaction(
            _paymentsModel, _pendingPaymentQtnAdd)
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
            ));
  }
}
