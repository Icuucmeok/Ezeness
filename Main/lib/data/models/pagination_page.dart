
class PaginationPage {
  final int? totalCount;
  final int? pageSize;
  int currentPage;
  final int? totalPages;
  final bool hasNext;

  PaginationPage({
     this.totalCount,
       this.pageSize=20,
       this.currentPage=1,
       this.totalPages,
       this.hasNext=true,
      });

  factory PaginationPage.fromJson(Map<String, dynamic> json) =>
      PaginationPage(
        pageSize: json['per_page'] as int?,
        totalCount: json['total'] as int?,
        currentPage: json['page']??1,
        totalPages: json['max_page'] as int?,
        hasNext: json['max_page'] != json['page'],
      );

}
