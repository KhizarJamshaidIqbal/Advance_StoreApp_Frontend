import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/slider_image_model.dart';

class SliderController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<SliderImage> _sliderImages = [];
  bool _isLoading = true;
  String? _error;

  List<SliderImage> get sliderImages => _sliderImages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  SliderController() {
    _fetchSliderImages();
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> _fetchSliderImages() async {
    try {
      _isLoading = true;
      notifyListeners();

      final QuerySnapshot snapshot = await _firestore
          .collection('slider_images')
          .orderBy('createdAt', descending: true)
          .get();

      _sliderImages = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return SliderImage(imageUrl: data['imageUrl']);
      }).toList();

      _error = null;
    } catch (e) {
      _error = 'Error loading slider images: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshImages() async {
    await _fetchSliderImages();
  }
}
