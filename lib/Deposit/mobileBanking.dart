import 'package:flutter/material.dart';

class mobileBankingPage extends StatelessWidget {
  const mobileBankingPage({Key? key}) : super(key: key);

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
              buildResizedImage('assets/ad/HPLogo.png'),
              SizedBox(height: 40),
              buildElevatedButton(context, 'BCA',
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Bank_Central_Asia.svg/1200px-Bank_Central_Asia.svg.png'),
              SizedBox(height: 30),
              buildElevatedButton(context, 'BNI',
                  'https://upload.wikimedia.org/wikipedia/id/thumb/5/55/BNI_logo.svg/2560px-BNI_logo.svg.png'),
              SizedBox(height: 30),
              buildElevatedButton(context, 'BRI',
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/BANK_BRI_logo.svg/1280px-BANK_BRI_logo.svg.png'),
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
      {double width = 150, double height = 150}) { //Function menampilkan gambar di atas layar
    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }

  Widget buildElevatedButton( // Function membuat button dan isi button
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

  void _showExtraPage(BuildContext context, String bankName) { // Menampilkan halaman modal dari bawah ketika button dipencet
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

  Column _instruksiBCA() { // Isi dari halaman modal
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('> Login ke akun m-BCA anda.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Pilih m-Transfer.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Pilih BCA Virtual Account.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Masukkan 77665 + nomor ponsel anda :',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        Text('   77665 08xx-xxxx-xxxx',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
      ],
    );
  }

  Column _instruksiBNI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('> Login ke akun BNI Mobile anda.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Pilih Transfer.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Pilih Virtual Account Billing.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Masukkan 0987 + nomor ponsel anda :',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        Text('   0987 08xx-xxxx-xxxx',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
      ],
    );
  }

  Column _instruksiBRI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('> Login ke akun BRI Mobile anda.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Pilih Dompet Digital.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Pilih Wizdrawal dan masukkan nomor ponsel anda :',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        Text('   08xx-xxxx-xxxx',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
      ],
    );
  }

  Column _instruksiMANDIRI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("> Login ke akun Livin' by Mandiri anda.",
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Pilih Pembayaran.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Pilih Buat Pembayaran Baru.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Pilih Multipayment',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Pilih Wizdrawal dan masukkan nomor ponsel anda :',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        Text('   08xx-xxxx-xxxx',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Masukkan nominal deposit.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
        SizedBox(height: 8),
        Text('> Selesaikan transaksi.',
          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular')),
      ],
    );
  }
}
