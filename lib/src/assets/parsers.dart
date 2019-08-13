part of cobblestone;

// Parser for AngelCode .fnt files
class _FontParser {
  static Parser _number =
      (char('-').optional() & digit().plus()).flatten().trim().map(int.parse);
  static Parser _string = (char('"') &
          (word() | whitespace() | char('.') | char('/')).star().flatten() &
          char('"'))
      .pick(1);
  static Parser _literal = (_number | _string);
  static Parser _list = (_number & char(','))
      .and()
      .seq(_number.separatedBy(char(','), includeSeparators: false))
      .pick(1);

  // Parsers for loading .fnt file
  static Parser _variable = word().plus().flatten().trim() &
      char('=').trim() &
      (_string | _list | _number);
  static Parser _line =
      word().plus().flatten().trim() & _variable.plus().trim();

  static Parser _file = _line.star();
}

// Parser for LibGDX .atlas files
class _AtlasParser {
  static Parser _number =
      (char('-').optional() & digit().plus()).flatten().trim().map(int.parse);
  static Parser _string =
      (word() | char('.') | char('/')).plus().flatten().trim();
  static Parser _bool = (string('true') | string('false'))
      .flatten()
      .trim()
      .map((val) => val == 'true');
  static Parser _literal = (_number | _string | _bool);
  static Parser _list = (_literal & char(','))
      .pick(0)
      .and()
      .seq(_literal.separatedBy(char(','), includeSeparators: false)).pick(1);

  static Parser _variable = (word().plus().flatten().trim() &
          char(':').trim() &
          (_list | _bool | _number | _string))
      .permute([0, 2]);
  static Parser _sectionName = (word() | char('.')).plus().flatten().trim();

  static Parser _region = _sectionName & _variable.star();
  static Parser _page = _sectionName & _variable.star() & _region.star();
  static Parser _file = _page.star();
}

Parser _fontParser = _FontParser._file;
Parser _atlasParser = _AtlasParser._file;
