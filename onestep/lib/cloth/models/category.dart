class Category {
  List<String> _dropdownCategoryItems = new List();

  Category() {
    _dropdownCategoryItems = [
      "전체",
      "티셔츠",
      "블라우스",
      "셔츠/남방",
      "맨투맨",
      "미니원피스",
      "롱원피스",
      "점프수트",
      "바지",
      "미니스커트",
      "롱스커트",
    ];
  }
  List<String> getCategoryItems() {
    return _dropdownCategoryItems;
  }
}
