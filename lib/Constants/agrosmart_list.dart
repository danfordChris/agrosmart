class AgrosmartList {
  AgrosmartList._();

  static Map<String, dynamic> get cropScale => {
    "prediction": "Tomato___Late_blight",
    "recommendations": {
      "description": "A plant disease that requires attention.",
      "treatment": [
        "Remove infected plant parts",
        "Apply appropriate treatments based on local expert advice",
        "Ensure proper growing conditions",
        "Monitor plant health regularly",
      ],
      "prevention": [
        "Practice crop rotation",
        "Maintain good air circulation",
        "Use disease-resistant varieties when available",
        "Keep garden clean and free of debris",
      ],
    },
    "image_url":
        "http://172.16.189.96:8000/media/plant_images/0b37761a-de32-47ee-a3a4-e138b97ef542___JR_FrgE_TxPnftG.S_2908_90deg.JPG",
  };
}
