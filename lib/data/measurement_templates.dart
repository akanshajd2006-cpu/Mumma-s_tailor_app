class MeasurementField {
  final String key;
  final String label;
  final String placeholder;
  const MeasurementField(this.key, this.label, this.placeholder);
}

/// Ported 1:1 from MEASUREMENT_TEMPLATES in the original web app's app.js
const Map<String, List<MeasurementField>> measurementTemplates = {
  'Kurti': [
    MeasurementField('length', 'Length (लम्बाई)', 'e.g. 38"'),
    MeasurementField('chest', 'Chest (छाती)', 'e.g. 36"'),
    MeasurementField('waist', 'Waist (कमर)', 'e.g. 32"'),
    MeasurementField('hip', 'Hips (हिप्स)', 'e.g. 38"'),
    MeasurementField('shoulder', 'Shoulder (तीरा)', 'e.g. 14"'),
    MeasurementField('sleeve_len', 'Sleeve Length (आस्तीन)', 'e.g. 16"'),
    MeasurementField('sleeve_round', 'Sleeve Round (मोरी)', 'e.g. 10"'),
    MeasurementField('armhole', 'Armhole (मुड्ढा)', 'e.g. 7.5"'),
    MeasurementField('front_neck', 'Front Neck (गला आगे)', 'e.g. 6.5"'),
    MeasurementField('back_neck', 'Back Neck (गला पीछे)', 'e.g. 7"'),
  ],
  'Blouse': [
    MeasurementField('length', 'Length (लम्बाई)', 'e.g. 14"'),
    MeasurementField('chest', 'Chest (छाती)', 'e.g. 34"'),
    MeasurementField('waist', 'Waist (कमर)', 'e.g. 28"'),
    MeasurementField('shoulder', 'Shoulder (तीरा)', 'e.g. 13.5"'),
    MeasurementField('sleeve_len', 'Sleeve Length (आस्तीन)', 'e.g. 10"'),
    MeasurementField('sleeve_round', 'Sleeve Round (मोरी)', 'e.g. 11"'),
    MeasurementField('front_neck', 'Front Neck (गला आगे)', 'e.g. 7"'),
    MeasurementField('back_neck', 'Back Neck (गला पीछे)', 'e.g. 8.5"'),
    MeasurementField('cross_back', 'Cross Back (कंधा)', 'e.g. 12"'),
  ],
  'Salwar': [
    MeasurementField('length', 'Length (लम्बाई)', 'e.g. 38"'),
    MeasurementField('waist', 'Waist/Seat (कमर/सीट)', 'e.g. 36"'),
    MeasurementField('mori', 'Mori / Bottom (मोरी)', 'e.g. 12"'),
    MeasurementField('thigh', 'Thigh (जांघ)', 'e.g. 24"'),
    MeasurementField('asan', 'Asan / Crotch (आसन)', 'e.g. 14"'),
  ],
  'Pant': [
    MeasurementField('length', 'Length (लम्बाई)', 'e.g. 36"'),
    MeasurementField('waist', 'Waist (कमर)', 'e.g. 30"'),
    MeasurementField('hip', 'Hips (हिप्स)', 'e.g. 36"'),
    MeasurementField('mori', 'Mori / Bottom (मोरी)', 'e.g. 13"'),
    MeasurementField('thigh', 'Thigh (जांघ)', 'e.g. 22"'),
    MeasurementField('asan', 'Asan / Crotch (आसन)', 'e.g. 12"'),
  ],
  'Gown': [
    MeasurementField('length', 'Full Length (पूरी लम्बाई)', 'e.g. 54"'),
    MeasurementField('body_len', 'Choli Length (चोली लम्बाई)', 'e.g. 14"'),
    MeasurementField('chest', 'Chest (छाती)', 'e.g. 36"'),
    MeasurementField('waist', 'Waist (कमर)', 'e.g. 30"'),
    MeasurementField('shoulder', 'Shoulder (तीरा)', 'e.g. 14"'),
    MeasurementField('sleeve_len', 'Sleeve Length (आस्तीन)', 'e.g. 18"'),
    MeasurementField('front_neck', 'Front Neck (गला आगे)', 'e.g. 6"'),
    MeasurementField('back_neck', 'Back Neck (गला पीछे)', 'e.g. 7"'),
  ],
  'Shirt': [
    MeasurementField('length', 'Length (लम्बाई)', 'e.g. 28"'),
    MeasurementField('chest', 'Chest (छाती)', 'e.g. 38"'),
    MeasurementField('waist', 'Waist (कमर)', 'e.g. 34"'),
    MeasurementField('shoulder', 'Shoulder (तीरा)', 'e.g. 17"'),
    MeasurementField('sleeve_len', 'Sleeve Length (आस्तीन)', 'e.g. 24"'),
    MeasurementField('collar', 'Collar (कॉलर)', 'e.g. 14.5"'),
  ],
};

const List<String> garmentOptions = [
  'Kurti', 'Blouse', 'Salwar', 'Pant', 'Gown', 'Shirt',
];
