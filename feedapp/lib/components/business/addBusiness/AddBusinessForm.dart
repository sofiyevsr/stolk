import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:partner_gainclub/components/common/inputs/address.dart';
import 'package:partner_gainclub/components/common/inputs/businessName.dart';
import 'package:partner_gainclub/components/common/inputs/email.dart';
import 'package:partner_gainclub/components/common/inputs/phone.dart';

import '../FileView.dart';
import '../LogoFileView.dart';
import 'LocationChooser.dart';

class AddBusinessForm extends StatefulWidget {
  AddBusinessForm({Key? key}) : super(key: key);

  @override
  _AddBusinessFormState createState() => _AddBusinessFormState();
}

class _AddBusinessFormState extends State<AddBusinessForm> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();

  // Variables
  String? email;
  String? phone;
  String? address;
  LatLng? location;
  String? businessName;
  io.File? logoImage;
  List<io.File?> images = List.filled(3, null);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      LogoFileView((s) {
                        logoImage = s;
                      }),
                      BusinessNameInput(onSaved: (s) {
                        businessName = s;
                      }),
                      LocationChooser((a) {
                        location = a?.loc;
                      }, _addressController),
                      AddressInput(
                        onSaved: (s) {
                          address = s;
                        },
                        textController: _addressController,
                      ),
                      PhoneInput(onSaved: (s) {
                        phone = s;
                      }),
                      EmailInput(onSaved: (s) {
                        email = s;
                      }),
                      FileView((s) {
                        images[0] = s;
                      }),
                      FileView((s) {
                        images[1] = s;
                      }),
                      FileView((s) {
                        images[2] = s;
                      }),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  final isValid = _formKey.currentState?.validate();
                  if (isValid == true) {
                    print("valid");
                  }
                },
                child: Text("confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
