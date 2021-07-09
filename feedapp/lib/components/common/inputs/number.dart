import 'package:easy_localization/easy_localization.dart';
import 'package:partner_gainclub/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberedInput extends StatefulWidget {
  final void Function(String?)? onSaved;
  NumberedInput({required this.onSaved});
  @override
  _NumberedInputState createState() => _NumberedInputState();
}

class _NumberedInputState extends State<NumberedInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController(text: "1");
  }

  void increment() {
    final count = int.tryParse(_controller.text);
    if (count != null && count < 5) {
      _controller.text = (count + 1).toString();
    } else if (count == null) _controller.text = "1";
    _controller.selection = TextSelection.collapsed(offset: 1);
  }

  void decrement() {
    final count = int.tryParse(_controller.text);
    if (count != null && count > 1) {
      _controller.text = (count - 1).toString();
    }
    _controller.selection = TextSelection.collapsed(offset: 1);
  }

  @override
  Widget build(ctx) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tr("campaign.count_field"),
          style: Theme.of(ctx).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Container(
          height: 60,
          // margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  validator: ((String? nu) {
                    if (nu == null) {
                      return tr("validations.booking_count_required");
                    }
                    final parsed = int.tryParse(nu);
                    if (parsed == null || parsed < 1 || parsed > 5) {
                      return tr("validations.booking_count_between_1_5");
                    }
                    return null;
                  }),
                  onSaved: widget.onSaved,
                  inputFormatters: [LimitRangeTextInputFormatter(1, 5)],
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 26),
                  decoration: InputDecoration(
                    focusColor: Colors.blue,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  // style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: decrement,
                child: Icon(Icons.remove),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: increment,
                child: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
