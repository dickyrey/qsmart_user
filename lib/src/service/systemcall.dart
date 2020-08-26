import 'dart:convert';

class SystemCall{
  static String encodetoBase64(String txt){
    List encodetext = utf8.encode(txt);
    String base64str = base64.encode(encodetext);
    print(base64str);
    return base64str;
  }

  static String decodeFromBase64(String txt){
    String decodetext = utf8.decode(base64.decode(txt));
    print(decodetext);
    return decodetext;
  }
}