String getHexColor(String pickerRgb) {
  String rgb = pickerRgb;
  rgb = rgb.replaceAll(' ', '').replaceAll('rgb(', '').replaceAll(')', '');

  List<String> p = rgb.split(',');

  String r = int.parse(p[0]).toRadixString(16);
  String g = int.parse(p[1]).toRadixString(16);
  String b = int.parse(p[2]).toRadixString(16);

  if (r.length == 1) {
    r = "0" + r;
  }
  if (g.length == 1) {
    g = "0" + g;
  }
  if (b.length == 1) {
    b = "0" + b;
  }
  return '#$r$g$b';
}