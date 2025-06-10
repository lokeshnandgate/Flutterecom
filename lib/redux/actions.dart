import 'package:ecom/models/chat_model.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/models/user_model.dart';

class FetchChatsAction {}

class FetchChatsSuccessAction {
  final List<ChatModel> chats;
  FetchChatsSuccessAction(this.chats);
}

class FetchChatsErrorAction {
  final String error;
  FetchChatsErrorAction(this.error);
}

class FetchProductsAction {}

class FetchProductsSuccessAction {
  final List<ProductModel>? products;
  FetchProductsSuccessAction(this.products);
}

class FetchProductsErrorAction {
  final String error;
  FetchProductsErrorAction(this.error);
}

class LoginSuccessAction {
  final String token;
  final User user;
  final bool isBusiness;

  LoginSuccessAction({
    required this.token,
    required this.user,
    required this.isBusiness,
  });
}

class LoginErrorAction {
  final String error;
  LoginErrorAction(this.error);
}