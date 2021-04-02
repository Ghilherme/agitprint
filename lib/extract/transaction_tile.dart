import 'package:agitprint/extract/receipt_dialog.dart';
import 'package:agitprint/models/payments.dart';
import 'package:agitprint/models/status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class TransactionTile extends StatefulWidget {
  final PaymentsModel payment;

  const TransactionTile({Key key, this.payment}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        dense: true,
        trailing: Text(
          NumberFormat.simpleCurrency(locale: "pt_BR")
              .format(widget.payment.amount),
          style: TextStyle(
              inherit: true, fontWeight: FontWeight.w700, fontSize: 16.0),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return ReceiptDialog(
                    payment: widget.payment,
                  );
                }),
            child: Material(
              elevation: 10,
              shape: CircleBorder(),
              shadowColor: Color(0xFFffd60f).withOpacity(0.4),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: widget.payment.status == Status.pending
                      ? Color(0xFFffd60f)
                      : Colors.green,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: checkIconType(),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          widget.payment.description.isEmpty
              ? 'Transação'
              : widget.payment.description,
          overflow: TextOverflow.fade,
          style: TextStyle(
              inherit: true, fontWeight: FontWeight.w700, fontSize: 16.0),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  "${widget.payment.createdAt.day.toString().padLeft(2, '0')}/${widget.payment.createdAt.month.toString().padLeft(2, '0')}/${widget.payment.createdAt.year.toString()} ${widget.payment.createdAt.hour.toString().padLeft(2, '0')}:${widget.payment.createdAt.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(
                      inherit: true, fontSize: 12.0, color: Colors.black45)),
            ],
          ),
        ),
      ),
    );
  }

  Icon checkIconType() {
    switch (widget.payment.type) {
      case 'Crédito':
        return Icon(
          Icons.account_balance,
          color: Colors.white,
        );
        break;
      case 'Débito':
        return Icon(
          Icons.account_balance,
          color: Colors.white,
        );
        break;
      default:
        return Icon(
          Icons.receipt,
          color: Colors.white,
        );
    }
  }
}
