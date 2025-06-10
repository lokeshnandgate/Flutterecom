// ✅ reducers.dart

import 'package:ecom/app/app_state.dart';
import 'package:ecom/models/chat_model.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/models/user_model.dart';
import 'package:ecom/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is LoginSuccessAction) {
    return state.copyWith(
      user: action.user,
      token: action.token,
      isBusiness: action.isBusiness,
    );
  }

  return AppState(
    chats: chatReducer(state.chats, action),
    products: productReducer(state.products, action),
    user: userReducer(state.user, action),
    token: tokenReducer(state.token, action),
    isBusiness: isBusinessReducer(state.isBusiness, action),
    isLoading: loadingReducer(state.isLoading, action),
    error: errorReducer(state.error, action),
  );
}

List<ChatModel> chatReducer(List<ChatModel> state, dynamic action) {
  if (action is FetchChatsSuccessAction) {
    return action.chats;
  }
  return state;
}

List<ProductModel> productReducer(List<ProductModel> state, dynamic action) {
  if (action is FetchProductsSuccessAction) {
    return action.products ?? state;
  }
  return state;
}

User? userReducer(User? state, dynamic action) {
  if (action is LoginSuccessAction) {
    return action.user;
  }
  return state;
}

String? tokenReducer(String? state, dynamic action) {
  if (action is LoginSuccessAction) {
    return action.token;
  }
  return state;
}

bool isBusinessReducer(bool state, dynamic action) {
  if (action is LoginSuccessAction) {
    return action.isBusiness;
  }
  return state;
}

bool loadingReducer(bool state, dynamic action) {
  if (action is FetchChatsAction || action is FetchProductsAction) {
    return true;
  }
  if (action is FetchChatsSuccessAction || 
      action is FetchProductsSuccessAction ||
      action is FetchChatsErrorAction ||
      action is FetchProductsErrorAction) {
    return false;
  }
  return state;
}

String? errorReducer(String? state, dynamic action) {
  if (action is FetchChatsErrorAction || action is FetchProductsErrorAction) {
    return action.error;
  }
  if (action is LoginErrorAction) {
    return action.error;
  }
  return null;
}
