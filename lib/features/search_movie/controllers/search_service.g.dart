part of 'search_service.dart';

class _SearchService implements SearchService {
  _SearchService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'http://minhtue-001-site1.ktempurl.com/api';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<BaseResponse<List<MovieModel>>> searchMovies(String query) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'Search': query};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseResponse<List<MovieModel>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/movies',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseResponse<List<MovieModel>> _value;
    try {
      _value = BaseResponse<List<MovieModel>>.fromJson(
        _result.data!,
        (json) =>
            json is List<dynamic>
                ? json
                    .map<MovieModel>(
                      (i) => MovieModel.fromJson(i as Map<String, dynamic>),
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
