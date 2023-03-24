class Student {
  final String name;
  bool hidden;
  Student(this.name, this.hidden);

  String getName(){
    return name;
  }

  String toString(){
    return "Name: " + name;
  }
}