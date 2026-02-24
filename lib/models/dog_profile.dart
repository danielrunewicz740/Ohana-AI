/// Represents a dog profile shown in the kiosk check-in list.
class DogProfile {
  const DogProfile({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.breed,
    this.imageAsset,
    this.isCheckedIn = false,
  });

  final String id;
  final String name;
  final String ownerName;
  final String breed;
  final String? imageAsset;
  final bool isCheckedIn;

  DogProfile copyWith({bool? isCheckedIn}) {
    return DogProfile(
      id: id,
      name: name,
      ownerName: ownerName,
      breed: breed,
      imageAsset: imageAsset,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }
}

/// Sample dog profiles for the kiosk.
const List<DogProfile> kDefaultDogProfiles = [
  DogProfile(
    id: '1',
    name: 'Anubis',
    ownerName: 'The Carter Family',
    breed: 'German Shepherd',
  ),
  DogProfile(
    id: '2',
    name: 'Rex',
    ownerName: 'The Thompson Family',
    breed: 'Labrador Retriever',
  ),
  DogProfile(
    id: '3',
    name: 'Buddies',
    ownerName: 'The Martinez Family',
    breed: 'Golden Retriever',
  ),
  DogProfile(
    id: '4',
    name: 'Luna',
    ownerName: 'The Kim Family',
    breed: 'Border Collie',
  ),
  DogProfile(
    id: '5',
    name: 'Mochi',
    ownerName: 'The Nguyen Family',
    breed: 'Shiba Inu',
  ),
  DogProfile(
    id: '6',
    name: 'Daisy',
    ownerName: 'The Johnson Family',
    breed: 'Beagle',
  ),
];
