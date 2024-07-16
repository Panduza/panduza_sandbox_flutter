class AttributeReqEff {

  // Attribute asked by the user
  dynamic requested;

  // Current attribute on the platform
  dynamic effective;

  // Type of the attribute
  Type type;

  // Is currently requesting this variable (usefull only if timer
  // is going to be used)
  bool isRequesting;

  // List of request
  List<dynamic>? curRequests = [];

  AttributeReqEff(this.type, {this.requested, this.effective, this.isRequesting = false, this.curRequests});
}