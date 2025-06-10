// ✅ app_state.dart

import 'package:ecom/models/chat_model.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/models/user_model.dart';

class AppState {
  final List<ChatModel> chats;
  final List<ProductModel> products;
  final User? user;
  final String? token;
  final bool isBusiness;
  final bool isLoading;
  final String? error;

  AppState({
    required this.chats,
    required this.products,
    this.user,
    this.token,
    this.isBusiness = false,
    this.isLoading = false,
    this.error,
  });

  factory AppState.initial() {
    return AppState(
      chats: [],
      products: [],
    );
  }

  AppState copyWith({
    List<ChatModel>? chats,
    List<ProductModel>? products,
    User? user,
    String? token,
    bool? isBusiness,
    bool? isLoading,
    String? error,
  }) {
    return AppState(
      chats: chats ?? this.chats,
      products: products ?? this.products,
      user: user ?? this.user,
      token: token ?? this.token,
      isBusiness: isBusiness ?? this.isBusiness,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}