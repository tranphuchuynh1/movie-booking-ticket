// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => TicketModel(
  id: json['id'] as String,
  imageMovie: json['imageMovie'] as String,
  hall: json['hall'] as String,
  showTimeDate: json['showTimeDate'] as String,
  showTimeStart: json['showTimeStart'] as String,
  seatRow: json['seatRow'] as String,
  seatNumber: (json['seatNumber'] as num).toInt(),
  qrCode: json['qrCode'] as String,
);

Map<String, dynamic> _$TicketModelToJson(TicketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageMovie': instance.imageMovie,
      'hall': instance.hall,
      'showTimeDate': instance.showTimeDate,
      'showTimeStart': instance.showTimeStart,
      'seatRow': instance.seatRow,
      'seatNumber': instance.seatNumber,
      'qrCode': instance.qrCode,
    };
