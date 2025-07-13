enum TestType 
{
  placement,
  normal;

  static String stringDesc(TestType type)
  {
    switch (type) {
      case TestType.placement:
        return "Test poziomujący";
      case TestType.normal:
        return "Test zwykły";
      default:
        throw ArgumentError('Invalid TestType: $type');
    }
  }

}