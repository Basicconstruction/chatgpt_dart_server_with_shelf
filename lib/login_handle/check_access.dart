import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_session/session_middleware.dart';
Response? checkAccess(Request request){
  Session? session = Session.getSession(request);
  if(session==null){
    return Response.forbidden('Access denied');
  }
  if(session.data['user']==null){
    return Response.forbidden('Access denied');
  }
  return null;
}