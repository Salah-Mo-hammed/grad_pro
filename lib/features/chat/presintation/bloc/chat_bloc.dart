import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grad_project_ver_1/features/chat/domain/entities/chat_room_entity.dart';
import 'package:grad_project_ver_1/features/chat/domain/entities/message_entity.dart';
import 'package:grad_project_ver_1/features/chat/domain/usecases/get_or_create_chat_room_usecase.dart';
import 'package:grad_project_ver_1/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:grad_project_ver_1/features/chat/domain/usecases/stream_messages_usecases.dart';


part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetOrCreateChatRoomUsecase getOrCreateChatRoom;
  final SendMessageUsecase sendMessage;
  final StreamMessagesUsecases streamMessages;

  ChatBloc({
    required this.getOrCreateChatRoom,
    required this.sendMessage,
    required this.streamMessages,
  }) : super(ChatInitial()) {
    on<LoadChatRoomEvent>(_onLoadChatRoom);
    on<SendMessageEvent>(_onSendMessage);
    on<StartListeningToMessages>(_onStartListeningToMessages);
  }

  ChatRoomEntity? _chatRoom;
  Stream<List<MessageEntity>>? _messagesStream;

  void _onLoadChatRoom(LoadChatRoomEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      _chatRoom = await getOrCreateChatRoom(
        studentId: event.studentId,
        trainerId: event.trainerId,
        // courseId: event.courseId,
      );
      add(StartListeningToMessages(roomId: _chatRoom!.id));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    if (_chatRoom == null) return;
    await sendMessage(roomId: _chatRoom!.id, message: event.message);
  }

  void _onStartListeningToMessages(
      StartListeningToMessages event, Emitter<ChatState> emit) {
    _messagesStream = streamMessages(event.roomId);
    emit(ChatLoaded(messagesStream: _messagesStream!));
  }
}