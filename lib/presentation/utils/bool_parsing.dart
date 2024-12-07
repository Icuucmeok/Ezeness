

class BoolParsing {
  final String _bool;


  BoolParsing(this._bool);


  bool toBool() {
    return _bool.toLowerCase()=='true';
  }


}

