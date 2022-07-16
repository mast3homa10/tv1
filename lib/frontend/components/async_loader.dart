import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';

typedef RenderLoadCallback = Widget Function();
typedef RenderErrorCallback = Widget Function([dynamic error]);
typedef RenderSuccessCallback = Widget Function({dynamic data});
typedef InitStateCallback = Future<Object> Function();

enum LoadingState { error, loading, success }

class AsyncLoader extends StatefulWidget {
  final RenderLoadCallback renderLoad;
  final RenderSuccessCallback renderSuccess;
  final RenderErrorCallback renderError;
  final InitStateCallback initState;

  const AsyncLoader(
      {Key? key,
      required this.renderLoad,
      required this.renderSuccess,
      required this.renderError,
      required this.initState})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AsyncLoaderState();
}

class AsyncLoaderState extends State<AsyncLoader> {
  var _loadingState = LoadingState.loading;
  dynamic _data;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> reloadState() {
    return _initState();
  }

  Future<void> _initState() async {
    if (!mounted) return;

    setState(() {
      _loadingState = LoadingState.loading;
    });

    try {
      var data = await widget.initState();

      if (!mounted) return;

      setState(() {
        _data = data;
        _loadingState = LoadingState.success;
      });
    } catch (e) {
      log('$e');
      setState(() {
        _error = e;
        _data = null;
        _loadingState = LoadingState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingState == LoadingState.loading) return widget.renderLoad();
    if (_loadingState == LoadingState.error) return widget.renderError(_error);

    return widget.renderSuccess(data: _data);
  }
}
