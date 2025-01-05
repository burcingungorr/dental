import 'package:flutter/material.dart';

class HakkimizdaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hakkımızda',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white, // Geri ok simgesinin rengi
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 245, 245, 245), // Koyu beyaz arka plan rengi
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'DENTAI',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16.0),
              // DENTAI nedir? bölümü
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: const ExpansionTile(
                  leading: Icon(Icons.info, color: Colors.blue),
                  title: Text('DENTAI nedir?'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'DENTAI, diş sağlığı alanında gelişmiş yapay zeka destekli çözümler sunan bir platformdur. '
                        'Erken teşhis ve doğru tedavi süreçlerini destekler.',
                      ),
                    ),
                  ],
                ),
              ),
              // Diş Sağlığının Önemi bölümü
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: const ExpansionTile(
                  leading: Icon(Icons.health_and_safety, color: Colors.green),
                  title: Text('Diş Sağlığının Önemi?'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Diş sağlığı, genel sağlık üzerinde önemli bir etkiye sahiptir. Dişlerinizi düzenli olarak kontrol ettirmeniz, '
                        'ağız sağlığınızı korumanın yanı sıra kalp hastalıkları, diyabet gibi genel sağlık problemlerinin de önlenmesine yardımcı olabilir.',
                      ),
                    ),
                  ],
                ),
              ),
              // Diş hastalıklarında erken teşhis bölümü
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: const ExpansionTile(
                  leading: Icon(Icons.healing, color: Colors.red),
                  title: Text('Diş hastalıklarında erken teşhisin önemi?'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Erken teşhis, diş hastalıklarının ilerlemesini önler ve daha az maliyetli tedavi süreçleri sunar. '
                        'DENTAI bu süreci hızlandırmak için yanınızdadır.',
                      ),
                    ),
                  ],
                ),
              ),
              // Sıkça Sorulan Sorular (SSS) bölümü
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: const ExpansionTile(
                  leading: Icon(Icons.people, color: Colors.orange),
                  title: Text('Sıkça Sorulan Sorular (SSS)'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '• DENTAI ile Uzaktan Diş Muayenesi nasıl yapılır?\n'
                        'Hasta ağız görüntüsünü yükler ve bu sayede diş veya ağız hastalığını öğrenmiş olur.\n'
                        '• DENTAI’nin hastalar için avantajları nelerdir?\n'
                        'Hasta için erken teşhis imkanı , daha kolay ve hızlı erişim sağlar.\n '
                        '• DENTAI’nin doktorlar için avantajları nelerdir?\n'
                         'Doktorlar DENTAI sayesinde hastasını teşhis edilmiş bir şekilde ve de erken tedaviye başlamayı sağlar.\n'
                        '• DENTAI uzmanlık alanları nelerdir ?\n'
                        'DENTAI\'da şuanlık sadece 5 farklı hastalık bulunmakta. Tooth Discoloration(Renk Değişimi),Mouth Ulcer(Ağız Yarası),Hypodontia(Hipoodonti),Gingivitis(Dişeti İltihabı),Data Caries(Diş Çürüğü).'
                        ,
                      ),
                    ),
                  ],
                ),
              ),
                 Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  elevation: 4,
  margin: const EdgeInsets.only(bottom: 16.0),
  child: const ExpansionTile(
    leading: Icon(Icons.comment, color: Color.fromARGB(255, 229, 213, 38)),
    title: Text('Kullanıcı Yorumları'),
    children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Hatice Ç.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'DENTAI platformunu kullanarak diş sağlığım hakkında çok değerli bilgiler edindim. Erken teşhis çok önemli ve platform gerçekten hızlı bir şekilde çözüm sundu.',
              ),
              leading: Icon(Icons.person, color: Colors.blue),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Emirhan A.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Diş muayenem için uzaktan destek aldım. Sistem çok kullanışlı hızlı bir şekilde randevu oluşturabildim.',
              ),
              leading: Icon(Icons.person, color: Colors.blue),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Özlem Nur D.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Gerçekten etkili bir platform. DENTAI sayesinde diş sağlığı takibini kolayca yapabiliyorum.',
              ),
              leading: Icon(Icons.person, color: Colors.blue),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Rojin B.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'DENTAI ile uzaktan diş muayenesi yaptım ve oldukça memnun kaldım. Sağlık geçmişimi yükleyerek hızlı bir şekilde doğru sonuçlar aldım. Gerçekten çok kullanışlı bir sistem.',
              ),
              leading: Icon(Icons.person, color: Colors.blue),
            ),
          ],
        ),
      ),
    ],
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
