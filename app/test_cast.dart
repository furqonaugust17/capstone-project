void main() {
  List<dynamic> list = [null];
  try {
    list.map((json) => json as Map<String, dynamic>).toList();
  } catch (e) {
    print("List null: " + e.toString());
  }

  Map<String, dynamic>? data = null;
  try {
    dynamic d = data;
    Map<String, dynamic> m = d;
  } catch (e) {
    print("Map null implicit: " + e.toString());
  }
}
