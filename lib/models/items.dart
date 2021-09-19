class Items {
  final String movie, code;
  final bool isNew, isLocked;

  Items(
    this.movie,
    this.isLocked,
    this.isNew,
    this.code,
  );

  Items.fromJson(Map<String, dynamic> json)
      : movie = json["movie"],
        isNew = json["isNew"],
        isLocked = json["isLocked"],
        code = json["code"];
}
