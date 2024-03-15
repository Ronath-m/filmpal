bool isActorValid(
    String? knownForDepartment, String? actorName, String? query) {
  if (knownForDepartment == 'Acting' &&
      actorName != null &&
      actorName != query) {
    return true;
  } else {
    return false;
  }
}
