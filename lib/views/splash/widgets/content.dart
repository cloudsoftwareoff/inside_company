class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Welcome to the Hub!",
    image: "assets/img/image1.png",
    desc:
        "Welcome to the Tunisian Chemical Group's project tracking hub! Let's navigate through success together",
  ),
  OnboardingContents(
    title: "Stay Organized with Your Team",
    image: "assets/img/image3.png",
    desc:
        "With our application, stay connected and informed about the progress of computer investment projects, wherever you are.",
  ),
  OnboardingContents(
    title: "Innovating for a Prosperous Future",
    image: "assets/img/image2.png",
    desc:
        "GCT, committed to innovation and efficiency, for a prosperous future.",
  ),
];
