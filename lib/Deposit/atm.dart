import 'package:flutter/material.dart';

class atmPage extends StatelessWidget {
  const atmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ATM'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              buildResizedImage('https://upload.wikimedia.org/wikipedia/commons/5/59/Logo_ATM.png', width: 200, height: 200),
              SizedBox(height: 20),
              buildElevatedButton(context, 'BCA', 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Bank_Central_Asia.svg/1200px-Bank_Central_Asia.svg.png'),
              SizedBox(height: 10),
              buildElevatedButton(context, 'BNI', 'https://upload.wikimedia.org/wikipedia/id/thumb/5/55/BNI_logo.svg/2560px-BNI_logo.svg.png'),
              SizedBox(height: 10),
              buildElevatedButton(context, 'Mega', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Bank_Mega_2013.svg/2560px-Bank_Mega_2013.svg.png'),
              SizedBox(height: 10),
              buildElevatedButton(context, 'Mandiri', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Bank_Mandiri_logo_2016.svg/2560px-Bank_Mandiri_logo_2016.svg.png'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResizedImage(String imageUrl, {double width = 100, double height = 100}) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }

  Widget buildElevatedButton(BuildContext context, String bankName, String logoImageUrl) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showExtraPage(context, bankName);
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 147, 76, 175),
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
            SizedBox(width: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                bankName,
                style: TextStyle(
                  fontSize: 20,
                ),
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Istruction for $bankName',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
        Text("> Masukkan kartu ATM dan PIN BCA anda."),
        SizedBox(height: 8),
        Text('> Pilih Transaksi Lainnya.'),
        SizedBox(height: 8),
        Text('> Pilih Transfer.'),
        SizedBox(height: 8),
        Text('> Pilih Ke Rek BCA Virtual Account.'),
        SizedBox(height: 8),
        Text('> Masukkan 77665 + nomor ponsel anda :'),
        Text('   77665 08xx-xxxx-xxxx'),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.'),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.'),
      ],
    );
  }
  Column _instruksiBNI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("> Masukkan kartu ATM dan PIN BNI anda."),
        SizedBox(height: 8),
        Text('> Pilih Lainnya.'),
        SizedBox(height: 8),
        Text('> Pilih Transfer.'),
        SizedBox(height: 8),
        Text('> Pilih Virtual Account Billing.'),
        SizedBox(height: 8),
        Text('> Masukkan 0987 + nomor ponsel anda :'),
        Text('   0987 08xx-xxxx-xxxx'),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.'),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.'),
      ],
    );
  }
  Column _instruksiMega() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("> Masukkan kartu ATM dan PIN Mega anda."),
        SizedBox(height: 8),
        Text('> Pilih Pembayaran.'),
        SizedBox(height: 8),
        Text('> Pilih Lainnya.'),
        SizedBox(height: 8),
        Text('> Pilih Dompet Elektronik.'),
        SizedBox(height: 8),
        Text('> Pilih Wizdrawal.'),
        SizedBox(height: 8),
        Text('> Masukkan nomor ponsel anda :'),
        Text('   08xx-xxxx-xxxx'),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.'),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.'),
      ],
    );
  }
  Column _instruksiMANDIRI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("> Masukkan kartu ATM dan PIN Mandiri anda."),
        SizedBox(height: 8),
        Text('> Pilih Bayar/Beli.'),
        SizedBox(height: 8),
        Text('> Pilih Lainnya, kemudian pilih Lainnya lagi.'),
        SizedBox(height: 8),
        Text('> Pilih E-Commerce.'),
        SizedBox(height: 8),
        Text('> Masukkan kode Wizdrawal 19001.'),
        SizedBox(height: 8),
        Text('> Masukkan nomor ponsel anda :'),
        Text('   08xx-xxxx-xxxx'),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.'),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.'),
      ],
    );
  }
}
