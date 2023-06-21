/// 结束符
enum EndSymbol {
  /// 无结束符
  none,

  /// \r - 0x0D
  cr,

  /// \n - 0x0A
  lf,

  /// \r\n - 0x0D0A
  crLF,

  /// \0 - 0x00
  nul,
}
