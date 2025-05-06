
enum PiceSamples {
  x,o,none;

  static PiceSamples fromString(String pic){
    return switch (pic) {
      'x' => x,
      'o' => o,
      _ => none,
    };
  }
}