import 'package:flutter/material.dart';

class mobileBankingPage extends StatelessWidget {
  const mobileBankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Banking'),
        backgroundColor: Color.fromARGB(255, 147, 76, 175),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              buildResizedImage(
                  'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/smartphone-design-template-9a9102d0b9ea974ef58f33bb47a1f3b7_screen.jpg?ts=1633702996',
                  width: 200,
                  height: 200),
              SizedBox(height: 20),
              buildElevatedButton(context, 'BCA',
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Bank_Central_Asia.svg/1200px-Bank_Central_Asia.svg.png'),
              SizedBox(height: 10),
              buildElevatedButton(context, 'BNI',
                  'https://upload.wikimedia.org/wikipedia/id/thumb/5/55/BNI_logo.svg/2560px-BNI_logo.svg.png'),
              SizedBox(height: 10),
              buildElevatedButton(context, 'BRI',
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/BANK_BRI_logo.svg/1280px-BANK_BRI_logo.svg.png'),
              SizedBox(height: 10),
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
    return Image.network(
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
              ] else if (bankName == 'BRI') ...[
                _instruksiBRI()
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
        Text('> Login ke akun m-BCA anda.'),
        SizedBox(height: 8),
        Text('> Pilih m-Transfer.'),
        SizedBox(height: 8),
        Text('> Pilih BCA Virtual Account.'),
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
        Text('> Login ke akun BNI Mobile anda.'),
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

  Column _instruksiBRI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('> Login ke akun BRI Mobile anda.'),
        SizedBox(height: 8),
        Text('> Pilih Dompet Digital.'),
        SizedBox(height: 8),
        Text('> Pilih Wizdrawal dan masukkan nomor ponsel anda :'),
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
        Text("> Login ke akun Livin' by Mandiri anda."),
        SizedBox(height: 8),
        Text('> Pilih Pembayaran.'),
        SizedBox(height: 8),
        Text('> Pilih Buat Pembayaran Baru.'),
        SizedBox(height: 8),
        Text('> Pilih Multipayment'),
        SizedBox(height: 8),
        Text('> Pilih Wizdrawal dan masukkan nomor ponsel anda :'),
        Text('   08xx-xxxx-xxxx'),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.'),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.'),
      ],
    );
  }
}
