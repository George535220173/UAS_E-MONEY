import 'package:flutter/material.dart';

class atmPage extends StatelessWidget {
  const atmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deposit',
          style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 30, color:Color.fromARGB(255, 51, 22, 138)),
        ),
        backgroundColor: Color.fromARGB(255, 134, 255, 154),
        iconTheme: IconThemeData(
            color: Color.fromARGB(255, 51, 22, 138)),
      ),
      backgroundColor: Color.fromARGB(255, 51, 22, 138),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 70),
              buildResizedImage('assets/ad/ATMLogo.png',
                  width: 200, height: 200),
              SizedBox(height: 40),
              buildElevatedButton(context, 'BCA',
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Bank_Central_Asia.svg/1200px-Bank_Central_Asia.svg.png'),
              SizedBox(height: 30),
              buildElevatedButton(context, 'BNI',
                  'https://upload.wikimedia.org/wikipedia/id/thumb/5/55/BNI_logo.svg/2560px-BNI_logo.svg.png'),
              SizedBox(height: 30),
              buildElevatedButton(context, 'Mega',
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Bank_Mega_2013.svg/2560px-Bank_Mega_2013.svg.png'),
              SizedBox(height: 30),
              buildElevatedButton(context, 'Mandiri',
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Bank_Mandiri_logo_2016.svg/2560px-Bank_Mandiri_logo_2016.svg.png'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResizedImage(String imageUrl,
      {double width = 100, double height = 100}) {
    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }

  Widget buildElevatedButton(
      BuildContext context, String bankName, String logoImageUrl) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showExtraPage(context, bankName);
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 134, 255, 154),
          padding: const EdgeInsets.all(12.0),
        ),
        child: Row(
          children: [
            Image.network(
              logoImageUrl,
              width: 70,
              height: 40,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                bankName,
                style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 24,
                    color: Color.fromARGB(255, 51, 22, 138)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExtraPage(BuildContext context, String bankName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          color: Color.fromARGB(255, 210, 255, 210),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Instruction for $bankName',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: 'PoppinsBold',
                  color: Color.fromARGB(255, 3, 90, 3)
                ),
              ),
              SizedBox(height: 10),
              if (bankName == 'BCA') ...[
                _instruksiBCA()
              ] else if (bankName == 'Mega') ...[
                _instruksiMega()
              ] else if (bankName == 'BNI') ...[
                _instruksiBNI()
              ] else ...[
                _instruksiMANDIRI()
              ]
            ],
          ),
        );
      },
    );
  }

  Column _instruksiBCA() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "> Masukkan kartu ATM dan PIN BCA anda.",
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),
        ),
        SizedBox(height: 8),
        Text('> Pilih Transaksi Lainnya.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih Transfer.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih Ke Rek BCA Virtual Account.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Masukkan 77665 + nomor ponsel anda :',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        Text('   77665 08xx-xxxx-xxxx',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
      ],
    );
  }

  Column _instruksiBNI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("> Masukkan kartu ATM dan PIN BNI anda.",
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih Lainnya.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih Transfer.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih Virtual Account Billing.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Masukkan 0987 + nomor ponsel anda :',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        Text('   0987 08xx-xxxx-xxxx',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
      ],
    );
  }

  Column _instruksiMega() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("> Masukkan kartu ATM dan PIN Mega anda.",
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih Pembayaran.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih Lainnya.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih Dompet Elektronik.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih Wizdrawal.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Masukkan nomor ponsel anda :',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        Text('   08xx-xxxx-xxxx',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
      ],
    );
  }

  Column _instruksiMANDIRI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("> Masukkan kartu ATM dan PIN Mandiri anda.",
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih Bayar/Beli.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih Lainnya, kemudian pilih Lainnya lagi.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Pilih E-Commerce.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Masukkan kode Wizdrawal 19001.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Masukkan nomor ponsel anda :',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        Text('   08xx-xxxx-xxxx',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular'),),
      ],
    );
  }
}
