from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
from PIL import Image
import io

# Flask uygulamasını başlat
app = Flask(__name__)

model = tf.keras.models.load_model('C:\\Users\\gungo\\Desktop\\dental\\my_flutter_app\\assets\\model29.h5')

# Sınıf isimlerini belirleyin
class_names = ['Tooth Discoloration', 'Mouth Ulcer', 'hypodontia', 'Gingivitis', 'Data caries']

# Görüntüyü ön işleme fonksiyonu
def preprocess_image(image_bytes):
    image = Image.open(io.BytesIO(image_bytes))
    image = image.resize((256, 256))  # Modelin beklediği boyuta yeniden boyutlandırın
    image = np.array(image) / 255.0  # Normalizasyon
    image = np.expand_dims(image, axis=0)  # Batch boyutu ekleyin
    return image

# Tahmin yapmak için API endpoint
@app.route('/predict', methods=['POST'])
def predict():
    # Resim dosyasını al
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    try:
        # Resmi ön işleme
        image_bytes = file.read()
        processed_image = preprocess_image(image_bytes)

        # Modelle tahmin yap
        predictions = model.predict(processed_image)
        predicted_class = np.argmax(predictions, axis=1)

        # Tahmin edilen sınıfı döndür
        predicted_class_name = class_names[predicted_class[0]]
        confidence = predictions[0][predicted_class[0]]

        return jsonify({
            'predicted_class': predicted_class_name,
            'confidence': confidence
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Flask uygulamasını başlat
if __name__ == '__main__':
    app.run(debug=True)
