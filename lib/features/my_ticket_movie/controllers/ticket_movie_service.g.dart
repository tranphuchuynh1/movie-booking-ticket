// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_movie_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _TicketService implements TicketService {
  _TicketService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://minhtue-001-site1.ktempurl.com/api';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<BaseResponse<List<TicketModel>>> getTicketsByOrderId(
    String orderId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseResponse<List<TicketModel>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/tickets/${orderId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseResponse<List<TicketModel>> _value;
    try {
      _value = BaseResponse<List<TicketModel>>.fromJson(
        _result.data!,
        (json) =>
            json is List<dynamic>
                ? json
                    .map<TicketModel>(
                      (i) => TicketModel.fromJson(i as Map<String, dynamic>),
                    )
                    .toList()
                : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseResponse<List<TicketModel>>> getMovieTicketDetails(
    String userId,
    String movieId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseResponse<List<TicketModel>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/orders/movies/${userId}/tickets/${movieId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseResponse<List<TicketModel>> _value;
    try {
      _value = BaseResponse<List<TicketModel>>.fromJson(
        _result.data!,
        (json) =>
            json is List<dynamic>
                ? json
                    .map<TicketModel>(
                      (i) => TicketModel.fromJson(i as Map<String, dynamic>),
                    )
                    .toList()
                : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
