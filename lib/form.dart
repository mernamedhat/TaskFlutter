class UserForm {

  String _firstName;
  String _lastName;
  String _address;
  String _area;
  String _landline;
  String _mobile;
  String _nationalId;
  String _frontImageId;
  String _backImageId;
  UserForm(this._firstName, this._lastName, this._address, this._area,this._landline, this._mobile, this._nationalId, this._frontImageId,this._backImageId);

  // Method to make GET parameters.
  String toParams() =>
      "?firstName=$_firstName&lastName=$_lastName&address=$_address&area=$_area&landline=$_landline&mobile=$_mobile&nationalId=$_nationalId&frontImageId=$_frontImageId&backImageId=$_backImageId";


}