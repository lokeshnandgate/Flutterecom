// ✅ fetch_chats_thunk.dart

import 'package:ecom/app/app_state.dart';
import 'package:ecom/models/chat_model.dart';
import 'package:ecom/redux/actions.dart';
import 'package:ecom/shared/services/api_service.dart';
import 'package:ecom/shared/services/storage_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> fetchChatsThunk() {
  return (Store<AppState> store) async {
    store.dispatch(FetchChatsAction());
    try {
      final apiService = ApiService(StorageService());
      final response = await apiService.get('chat/chats/getuserchats');
      final chats = (response as List).map((c) => ChatModel.fromJson(c)).toList();
      store.dispatch(FetchChatsSuccessAction(chats));
    } catch (e) {
      store.dispatch(FetchChatsErrorAction(e.toString()));
    }
  };
}
