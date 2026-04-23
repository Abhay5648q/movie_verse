String parseHtml(String htmlString) {
  return htmlString
      .replaceAll(RegExp(r'<[^>]*>'), '') // remove tags
      .trim();
}